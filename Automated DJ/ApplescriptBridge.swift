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

    func getPlaylist(aPlaylist: String) -> Playlist {
        let rawPlaylist = instance.getPlaylist(aPlaylist)
        return Playlist().initWithString(rawPlaylist.debugDescription)
    }
    
    func getSongsInPlaylist(aPlaylist: String) -> NSMutableArray {
        //Older versions of iTunes with missing tracks will crash the application without explination. Update iTunes or fix the library
        let rawSongs = instance.getSongsInPlaylist(aPlaylist)
        let songs = NSMutableArray()
        for song in rawSongs {
            songs.addObject(Song().initWithString((song as! NSAppleEventDescriptor).debugDescription))
        }
        return songs
    }
    
    func getNumberOfSongsInPlaylist(aPlaylist: String) -> NSNumber{
        return instance.getNumberOfSongsInPlaylist(aPlaylist)
    }

    func getLastSongInPlaylist(aPlaylist: String) -> Song {
        return Song().initWithString(instance.getLastSongInPlaylist(aPlaylist).debugDescription)
    }
    
    func removeLastSongInPlaylist(aPlaylist: String){
        instance.removeLastSongInPlaylist(aPlaylist)
    }
    
    func createPlaylistWithName(aName: String){
        instance.createPlaylistWithName(aName)
    }

    func deletePlaylistWithName(aName: String){
        instance.deletePlaylistWithName(aName)
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

    func playPlaylist(aPlaylist: String){
        //When a playlist does not exist, this function does nothing rather then throw an error. (Part of the reason for this is that the applescript error which would be thrown isn't intutive)
        instance.playPlaylist(aPlaylist)
    }

    func isiTunesPlaying() -> Bool {
        var result = false
        let state = instance.getiTunesPlayerState().stringValue
        if state == "kPSP" {
            result = true
        }
        return result
    }
    
    func playSongFromPlaylist(aTrack: NSNumber, aPlaylist:String){
        instance.playSongFromPlaylist(aTrack, aPlaylist: aPlaylist)
    }
    
    func addSongsToPlaylist(aPlaylist: String, songArray: NSArray){
        for song in songArray {
            instance.addSongToPlaylist(aPlaylist, aSongID: (song as! Song).persistentID)
        }
    }
    
    func getPersistentIDsOfSongsInPlaylist(aPlaylist: NSString) -> [String]{
        let rawIDs = instance.getPersistentIDsOfSongsInPlaylist(aPlaylist)
        return rawIDs
    }
    
    func getSong(anID: NSString) -> Song{
        return Song().initWithString(instance.getSong(anID).debugDescription)
    }
}