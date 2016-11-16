//
//  ApplescriptBridgeNew.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 8/1/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class ApplescriptBridge: NSObject {
    
    let instance: MyApplescript
    
    override init() {
        instance = NSClassFromString("MyApplescript") as! MyApplescript
        super.init()
    }
    
    func iTunesPause(){
        instance.iTunesPause()
    }
    
    func iTunesStop(){
        instance.iTunesStop()
    }

    func getPlaylists() -> [Playlist] {
        let rawPlaylists = instance.getPlaylists()
        var playlists = [Playlist]()
        for aRawPlaylist in rawPlaylists {
            playlists.append(Playlist().initWithString((aRawPlaylist as! NSAppleEventDescriptor).debugDescription))
        }
        return playlists
    }

    func getPlaylist(_ aPlaylist: String) -> Playlist {
        let rawPlaylist = instance.getPlaylist(
            aPlaylist as NSString)
        return Playlist().initWithString(rawPlaylist.debugDescription)
    }
    
    func getSongsInPlaylist(_ aPlaylist: String) -> NSMutableArray {
        //Older versions of iTunes with missing tracks will crash the application without explination. Update iTunes or fix the library
        let rawSongs = instance.getSongsInPlaylist(aPlaylist as NSString)
        let songs = NSMutableArray()
        for song in rawSongs {
            songs.add(Song().initWithString((song as! NSAppleEventDescriptor).debugDescription))
        }
        return songs
    }
    
    func getNumberOfSongsInPlaylist(_ aPlaylist: String) -> NSNumber{
        return instance.getNumberOfSongsInPlaylist(aPlaylist as NSString)
    }

    func getLastSongInPlaylist(_ aPlaylist: String) -> Song {
        return Song().initWithString(instance.getLastSongInPlaylist(aPlaylist as NSString).debugDescription)
    }
    
    func removeLastSongInPlaylist(_ aPlaylist: String){
        instance.removeLastSongInPlaylist(aPlaylist as NSString)
    }
    
    func createPlaylistWithName(_ aName: String){
        instance.createPlaylistWithName(aName as NSString)
    }

    func deletePlaylistWithName(_ aName: String){
        instance.deletePlaylistWithName(aName as NSString)
    }
    
    func getCurrentPlaylist() -> String {
        return instance.getCurrentPlaylist() as String
    }

    func disableShuffle(){
        instance.disableShuffle()
    }
    
    func disableRepeat(){
        instance.disableRepeat()
    }

    func timeLeftInCurrentSong() -> Double {
        return instance.timeLeftInCurrentSong().doubleValue
    }

    func playPlaylist(_ aPlaylist: String){
        //When a playlist does not exist, this function does nothing rather then throw an error. (Part of the reason for this is that the applescript error which would be thrown isn't intutive)
        instance.playPlaylist(aPlaylist as NSString)
    }

    func isiTunesPlaying() -> Bool {
        var result = false
        let state = instance.getiTunesPlayerState().stringValue
        if state == "kPSP" {
            result = true
        }
        return result
    }
    
    func playSongFromPlaylist(_ aTrack: NSNumber, aPlaylist:String){
        instance.playSongFromPlaylist(aTrack, aPlaylist: aPlaylist as NSString)
    }
    
    func addSongsToPlaylist(_ aPlaylist: String, songArray: NSArray){
        for song in songArray {
            instance.addSongToPlaylist(aPlaylist as NSString, aSongID: (song as! Song).persistentID as NSString)
        }
    }
    
    func getPersistentIDsOfSongsInPlaylist(_ aPlaylist: NSString) -> [String]{
        let rawIDs = instance.getPersistentIDsOfSongsInPlaylist(aPlaylist)
        return rawIDs
    }
    
    func getSong(_ anID: NSString) -> Song{
        return Song().initWithString(instance.getSong(anID).debugDescription)
    }
}
