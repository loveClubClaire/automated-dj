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
    
    let instance: NSObject.Type
    
    override init() {
        let c: NSObject.Type = (NSClassFromString("MyApplescript") as? NSObject.Type)!
        instance = c
        super.init()
    }
    
    func iTunesPause(){
        let name = "iTunesPause"
        let selector = NSSelectorFromString(name)
        instance.perform(selector)
    }
    
    func iTunesStop(){
        let name = "iTunesStop"
        let selector = NSSelectorFromString(name)
        instance.perform(selector)
    }

    func getPlaylists() -> [Playlist] {
        let name = "getPlaylists"
        let selector = NSSelectorFromString(name)
        let returnObject = instance.perform(selector)
        let rawPlaylists = returnObject?.takeUnretainedValue() as! NSArray
        //If rawPlaylists == {} then iTunes is not configured. Please configure iTunes and then relaunch the automated DJ. 
        if rawPlaylists.count == 0{
            let myPopup: NSAlert = NSAlert()
            myPopup.messageText = "Fatal Error: iTunes not configured"
            myPopup.informativeText = "Please configure iTunes then relaunch the Automated DJ"
            myPopup.alertStyle = NSAlertStyle.critical
            myPopup.addButton(withTitle: "OK")
            myPopup.runModal()
            //Kill applicaiton
            NSApp.terminate(self)
        }
        
        var playlists = [Playlist]()
        for aRawPlaylist in rawPlaylists {
            playlists.append(Playlist().initWithString((aRawPlaylist as! NSAppleEventDescriptor).debugDescription))
        }
        return playlists
    }

    func getPlaylist(aPlaylist: String) -> Playlist {
        let name = "getPlaylist:"
        let selector = NSSelectorFromString(name)
        let result = instance.perform(selector, with: aPlaylist)
        let rawPlaylist = result?.takeUnretainedValue() as! NSAppleEventDescriptor
        return Playlist().initWithString(rawPlaylist.debugDescription)
    }
    
    func getSongsInPlaylist(aPlaylist: String) -> NSMutableArray {
        //Older versions of iTunes with missing tracks will crash the application without explination. Update iTunes or fix the library
        let name = "getSongsInPlaylist:"
        let selector = NSSelectorFromString(name)
        let result = instance.perform(selector, with: aPlaylist)
        let rawSongs = result?.takeUnretainedValue() as! NSArray
        let songs = NSMutableArray()
        for song in rawSongs {
            songs.add(Song().initWithString((song as! NSAppleEventDescriptor).debugDescription))
        }
        return songs
    }
    
    func getNumberOfSongsInPlaylist(aPlaylist: String) -> NSNumber{
        let name = "getNumberOfSongsInPlaylist:"
        let selector = NSSelectorFromString(name)
        let result = instance.perform(selector, with: aPlaylist)
        return result?.takeUnretainedValue() as! NSNumber
    }

    func getLastSongInPlaylist(aPlaylist: String) -> Song {
        let name = "getLastSongInPlaylist:"
        let selector = NSSelectorFromString(name)
        let result = instance.perform(selector, with: aPlaylist)
        let rawSong = (result?.takeUnretainedValue() as! NSAppleEventDescriptor).debugDescription
        return Song().initWithString(rawSong)
    }
    
    func removeLastSongInPlaylist(aPlaylist: String){
        let name = "removeLastSongInPlaylist:"
        let selector = NSSelectorFromString(name)
        instance.perform(selector, with: aPlaylist)
    }
    
    func createPlaylistWithName(aName: String){
        let name = "createPlaylistWithName:"
        let selector = NSSelectorFromString(name)
        instance.perform(selector, with: aName)
    }

    func deletePlaylistWithName(aName: String){
        let name = "deletePlaylistWithName:"
        let selector = NSSelectorFromString(name)
        instance.perform(selector, with: aName)
    }
    
    func getCurrentPlaylist() -> String {
        let name = "getCurrentPlaylist"
        let selector = NSSelectorFromString(name)
        let returnObject = instance.perform(selector)
        return returnObject?.takeUnretainedValue() as! String
    }

    func disableShuffle(){
        let name = "disableShuffle"
        let selector = NSSelectorFromString(name)
        instance.perform(selector)
    }
    
    func disableRepeat(){
        let name = "disableRepeat"
        let selector = NSSelectorFromString(name)
        instance.perform(selector)
    }

    func timeLeftInCurrentSong() -> Double {
        let name = "timeLeftInCurrentSong"
        let selector = NSSelectorFromString(name)
        let returnObject = instance.perform(selector)
        let result = returnObject?.takeUnretainedValue() as! NSNumber
        return result.doubleValue
    }

    func playPlaylist(aPlaylist: String){
        //When a playlist does not exist, this function does nothing rather then throw an error. (Part of the reason for this is that the applescript error which would be thrown isn't intutive)
        let name = "playPlaylist:"
        let selector = NSSelectorFromString(name)
        instance.perform(selector, with: aPlaylist)
    }

    func isiTunesPlaying() -> Bool {
        let name = "getiTunesPlayerState"
        let selector = NSSelectorFromString(name)
        let returnObject = instance.perform(selector)
        let applescriptResult = returnObject?.takeUnretainedValue() as! NSAppleEventDescriptor
        var result = false
        let state = applescriptResult.stringValue
        if state == "kPSP" {
            result = true
        }
        return result
    }
    
    func playSongFromPlaylist(aTrack: Int, aPlaylist:String){
        let name = "playSongFromPlaylist:aPlaylist:"
        let selector = NSSelectorFromString(name)
        instance.perform(selector, with: aTrack, with: aPlaylist)
    }
    
    func addSongsToPlaylist(aPlaylist: String, songArray: NSArray){
        for song in songArray {
            let name = "addSongToPlaylist:aSongID:"
            let selector = NSSelectorFromString(name)
            instance.perform(selector, with: aPlaylist, with: (song as! Song).persistentID as String)
        }
    }
    
    func getPersistentIDsOfSongsInPlaylist(aPlaylist: String) -> [String]{
        let name = "getPersistentIDsOfSongsInPlaylist:"
        let selector = NSSelectorFromString(name)
        let result = instance.perform(selector, with: aPlaylist)
        return result?.takeUnretainedValue() as! [String]
    }
    
    func getSong(anID: NSString) -> Song{
        let name = "getSong:"
        let selector = NSSelectorFromString(name)
        let result = instance.perform(selector, with: anID)
        let rawSong = ((result?.takeUnretainedValue() as! NSArray)[0] as! NSAppleEventDescriptor).debugDescription
        return Song().initWithString(rawSong)
    }
}
