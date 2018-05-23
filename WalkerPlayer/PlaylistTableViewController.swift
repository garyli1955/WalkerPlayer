//
//  PlaylistTableViewController.swift
//  WalkerPlayer
//
//  Created by user on 2/27/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class PlaylistTableViewController: UITableViewController{
    let TAG = "PlaylistTableViewController:"
    
    var mainVC: ViewController?
    
    var allSongs: [SongInfo] = [] //to hold all songs from different album when isMultiAlbum = false
   
    var albums: [AlbumInfo] = []
    var songQuery: SongQuery = SongQuery()
    var audio: AVAudioPlayer?
    
    var isMultiAlbums = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(TAG+"viewDidLoad()")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //MPMediaLibrary.requestAuthorization { (status) in
          //  if status == .authorized {
                self.albums = self.songQuery.get(songCategory: "")
                print("num of albums=\(self.albums.count)")
                DispatchQueue.main.async {
                    self.tableView?.rowHeight = UITableViewAutomaticDimension;
                    self.tableView?.estimatedRowHeight = 60.0;
                    self.tableView?.reloadData()
                }
            //}
            //else {
            //    self.displayMediaLibraryError()
            //}
        //}
        if self.isMultiAlbums == false {
            //if all songs are in same album, and put them into songs[] and durations[]
            for album in self.albums {
                for song in album.songs {
                    self.allSongs.append(song)
                }
            }
            print("num of songs = \(self.allSongs.count)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        print("numberOfSections()")
        if isMultiAlbums == true {
            print("number of sections = \(self.albums.count)")
            return albums.count
        }
        else {
            print("number of sections = 1")
            return 1 //all songs are in one section
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView(): numberOfRowsInSection")
        if isMultiAlbums == true {
            if albums.count > 0 {
                print("number of albums = \(self.albums[section].songs.count)")
                return self.albums[section].songs.count //return the number of available songs in the designated section
            }
            else
            {
                print("no album found")
                return 0
            }
        }
        else {
            if section == 0 {
                print("number of songs = \(self.allSongs.count)")
                return self.allSongs.count
            }
            else {
                return 0
            }
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("tableView(): cellForRowAt")
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath) as! PlaylistTableViewCell
        if isMultiAlbums == true {
            cell.labelTitle.text = self.albums[indexPath.section].songs[indexPath.row].title
            cell.labelDuration.text = self.albums[indexPath.section].songs[indexPath.row].durationStr
        }
        else {
            cell.labelTitle.text = self.allSongs[indexPath.row].title
            cell.labelDuration.text = self.allSongs[indexPath.row].durationStr
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isMultiAlbums == true {
            print("tableView(): didSelectRowAt(): row=\(indexPath), \(albums[indexPath.section].songs[indexPath.row].title)")
            
            //mainVC?.getParameters(songsInLib: albums[indexPath.section].songs, songIndex: index)
            
        }
        else {
            print("tableView(): didSelectRowAt(): row=\(indexPath), \(allSongs[indexPath.row].title)")
            mainVC?.getParameters(songsInLib: allSongs, songIndex: indexPath.row)
        }
        //return to caller
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return albums[section].albumTitle
        return "Play List"
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //===============
    //private functions
    //=================
    func displayMediaLibraryError() {
        
        var error: String
        switch MPMediaLibrary.authorizationStatus() {
        case .restricted:
            error = "Media library access restricted by corporate or parental settings"
        case .denied:
            error = "Media library access denied by user"
        default:
            error = "Unknown error"
        }
        
        let controller = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }))
        present(controller, animated: true, completion: nil)
    }

}
