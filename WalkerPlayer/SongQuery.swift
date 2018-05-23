import Foundation
import MediaPlayer

struct SongInfo {
    var albumTitle: String
    var title:  String
    var duration: Float
    var durationStr: String
    var url: URL
}

struct AlbumInfo {
    var albumTitle: String
    var songs: [SongInfo]
}

class SongQuery {
    let TAG = "SongQuery:"
    
    func get(songCategory: String) -> [AlbumInfo] {
        print(TAG+"get()")
       
        var albums: [AlbumInfo] = []
       
        let albumsQuery: MPMediaQuery
        if songCategory == "Artist" {
            albumsQuery = MPMediaQuery.artists()
        } else if songCategory == "Album" {
            albumsQuery = MPMediaQuery.albums()
        } else {
            //this is used by caller by default
            albumsQuery = MPMediaQuery.albums()
        }


        let albumItems: [MPMediaItemCollection] = albumsQuery.collections! as [MPMediaItemCollection]

        
        for album in albumItems {

            let albumItems: [MPMediaItem] = album.items as [MPMediaItem]

            var songs: [SongInfo] = []
            var albumTitle: String = ""        

            for song in albumItems {
                if songCategory == "Artist" {
                    albumTitle = song.value( forProperty: MPMediaItemPropertyArtist ) as! String

                } else if songCategory == "Album" {
                    albumTitle = song.value( forProperty: MPMediaItemPropertyAlbumTitle ) as! String


                } else {
                    albumTitle = song.value( forProperty: MPMediaItemPropertyAlbumTitle ) as! String
                }
                let durationInSec = Int(truncating: song.value( forProperty: MPMediaItemPropertyPlaybackDuration ) as! NSNumber)
                
                let songInfo: SongInfo = SongInfo(
                    albumTitle: song.value( forProperty: MPMediaItemPropertyAlbumTitle ) as! String,
                    title:  song.value( forProperty: MPMediaItemPropertyTitle ) as! String,
                    duration: Float(truncating: song.value( forProperty: MPMediaItemPropertyPlaybackDuration ) as! NSNumber),
                    durationStr: "\(durationInSec/60):\(durationInSec % 60)",
                    url: song.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
                )
                songs.append( songInfo )
            }

            
            let albumInfo: AlbumInfo = AlbumInfo(
                albumTitle: albumTitle,
                songs: songs
            )
            albums.append( albumInfo )
        }
 
        /* show albums and songs in each album
        print("number of albums = \(albums.count)")
        for album in albums {
            print("\(album.albumTitle)")
        }
        //return albums // testing
        // cloud item values are 0 and 1, meaning false and true
        for album in albums {
            print("number of songs = \(album.songs.count) in \(album.albumTitle)")
            for song in album.songs { //
                print("\(song.title)")
                print("\(song.url)")
            }
        }
         */
        return albums
    }

    func getItem( songId: NSNumber ) -> MPMediaItem {
        print(TAG+"getItem()")
        let property: MPMediaPropertyPredicate = MPMediaPropertyPredicate( value: songId, forProperty: MPMediaItemPropertyPersistentID )

        let query: MPMediaQuery = MPMediaQuery()
        query.addFilterPredicate( property )

        var items: [MPMediaItem] = query.items! as [MPMediaItem]

        return items[items.count - 1]

    }
}


