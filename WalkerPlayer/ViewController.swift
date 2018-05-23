//
//  ViewController.swift
//  WalkerPlayer
//
//  Created by user on 2/26/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioPlayerDelegate {
    //==============
    //button outlets
    //==============
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var buttonForward: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonBackward: UIButton!
    @IBOutlet weak var buttonPrev: UIButton!
   
    @IBOutlet weak var buttonRepeat: UIButton!
    @IBOutlet weak var buttonShuffle: UIButton!
    @IBOutlet weak var progressSong: UIProgressView!
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var labelSongTitle: UILabel!
    
    
    var playerSong: AVAudioPlayer!
    var songIndex = -1          //no song has been selected
    var isShuffle = false
    var isRepeat = false
    var songs: [SongInfo] = []  //the array will be filled by PlaylistTableViewController
    
    var timer = Timer()
    
    //==================
    //override functions
    //==================
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let fileName = "test"
        let documentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        print(fileURL)
        let str = "test text file writing"
        do {
            try str.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        }
        catch let error as NSError{
            print(error)
        }
        
        var readStr = ""
        do {
            readStr = try String(contentsOf: fileURL)
        }
        catch let error as NSError {
            print(error)
        }
        print(readStr)
         */
        if songIndex != -1 {
            print("\(self.songs[songIndex].url)")
            playASong(songIndex: self.songIndex)
        }
        else {
            progressSong.isHidden = true
            labelDuration.isHidden = true
            labelSongTitle.isHidden = true
            print("no music file selected")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playASong(songIndex: Int) {
        do {
            print("\(self.songs[songIndex].title)")
            playerSong = try? AVAudioPlayer(contentsOf: self.songs[songIndex].url)
            playerSong.numberOfLoops = 0
            playerSong.delegate = self //make audioPlayerDidFinishPlaying() called at end
            playerSong.play()
            buttonPlay.setImage(UIImage(named: "img_btn_pause")!, for: .normal)
            
            progressSong.isHidden = false
            progressSong.progress = 0.0 //TODO: should continue from last stopped?
            
            labelSongTitle.isHidden = false
            labelSongTitle.text = songs[songIndex].title
            
            labelDuration.isHidden = false
            labelDuration.text = songs[songIndex].durationStr
            timer.invalidate() //stop last timer
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: progressSongTimer)
            
        }
    }
    func stopASong() {
        playerSong.stop()
        progressSong.isHidden = true
        labelDuration.isHidden = true
        labelSongTitle.isHidden = true
    }
    
    func progressSongTimer(timer: Timer) {
        progressSong.progress += 0.05 / songs[songIndex].duration;
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("audioPlayerDidFinishPlaying()")
        
        if self.isRepeat == false {
            if self.isShuffle {
                songIndex = Int(arc4random_uniform(UInt32(songs.count)))
            }
            else {
                if songIndex < songs.count-1 {
                    songIndex += 1
                }
                else {
                    print("reached the end of the list")
                    songIndex = 0
                }
            }
        }
        playASong(songIndex: songIndex)
    }
    //===============
    //button handlers
    //===============
    @IBAction func playClicked(_ sender: UIButton) {
        print("playClicked()")
        if playerSong == nil {
            if songIndex == -1 {
                print("no song selected")
                //TODO: should go to PlaylistTableviewController automatically?
            }
            else {
                playASong(songIndex: self.songIndex)
            }
        }
        else {
            if playerSong.isPlaying {
                buttonPlay.setImage(UIImage(named: "img_btn_play")!, for: .normal)
                stopASong()
            }
            else {
                //var error: NSError!
                if self.songIndex != -1 {
                    playASong(songIndex: self.songIndex)
                }
                else {
                    print("no music file to play")
                }
                
            }            
        }
    }
    
    @IBAction func nextClicked(_ sender: UIButton) {
        print("nextClicked()")
        if songIndex < songs.count-1 {
            songIndex += 1
        }
        else {
            songIndex = 0
        }
        stopASong()
        playASong(songIndex: songIndex)
    }
    
    @IBAction func forwardClicked(_ sender: UIButton) {
        print("forwardClicked()")
    }
    @IBAction func backwardClicked(_ sender: UIButton) {
        print("backwardClicked()")
    }

    @IBAction func prevClicked(_ sender: UIButton) {
        print("prevClicked()")
        if songIndex == 0 {
            songIndex = songs.count-1
        }
        else {
            songIndex = songIndex-1
        }
        stopASong()
        playASong(songIndex: songIndex)
    }
    
    @IBAction func shuffleClicked(_ sender: UIButton) {
        if self.isShuffle {
            print("shuffleClicked(): off")
            buttonShuffle.setImage(UIImage(named: "img_btn_shuffle")!, for: .normal)
            self.isShuffle = false
        }
        else {
            print("shuffleClicked(): on")
            buttonShuffle.setImage(UIImage(named: "img_btn_shuffle_pressed")!, for: .normal)
            self.isShuffle = true
        }
    }
    
    
    @IBAction func repeatClicked(_ sender: UIButton) {
        
        if self.isRepeat {
            print("repeatClicked(): off")
            self.isRepeat = false
            buttonRepeat.setImage(UIImage(named: "img_btn_repeat")!, for: .normal)
        }
        else {
            print("repeatClicked(): on")
            self.isRepeat = true
            buttonRepeat.setImage(UIImage(named: "img_btn_repeat_pressed")!, for: .normal)
        }
        
    }
    
    //will be called when playlist button in navigation bar is called
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare()")
        //pass a point of this class to PlaylistTableViewController for it to callback getParameters()
        let playlistController = segue.destination as! PlaylistTableViewController
        playlistController.mainVC = self
    }
    
    func getParameters(songsInLib: [SongInfo], songIndex: Int) {
        print("getParameters()")
        self.songs = songsInLib
        self.songIndex = songIndex
        playASong(songIndex: self.songIndex)
    }
}

