//
//  MyApplescript.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 8/1/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

@objc protocol MyApplescript{
    
    func iTunesPause()
    
    func iTunesStop()
    
    func getPlaylists() -> NSArray
    
    func getPlaylist(aPlaylist: NSString) -> NSAppleEventDescriptor
    
    func getSongsInPlaylist(aPlaylist: NSString) -> NSArray
    
    func getNumberOfSongsInPlaylist(aPlaylist: NSString) -> NSNumber
    
    func createPlaylistWithName(aName: NSString)
    
    func getCurrentPlaylist() -> NSString
    
    func deletePlaylistWithName(aName: NSString)
    
    func disableShuffle()
    
    func disableRepeat()
    
    func timeLeftInCurrentSong() -> NSNumber
    
    func playPlaylist(aPlaylist: NSString)
    
    func getiTunesPlayerState() -> NSAppleEventDescriptor
    
    func getLastSongInPlaylist(aPlaylist: NSString) -> NSAppleEventDescriptor
    
    func removeLastSongInPlaylist(aPlaylist: NSString)
    
    func playSongFromPlaylist(aTrack: NSNumber, aPlaylist: NSString)
    
    func addSongToPlaylist(aPlaylist: NSString, aSongID: NSString)
    
    func getPersistentIDsOfSongsInPlaylist(aPlaylist: NSString) -> [String]
}