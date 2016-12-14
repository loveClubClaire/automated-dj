//
//  MiniPlayerCover.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 6/28/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class MiniPlayerCover: NSObject {
    @IBOutlet weak var AutomatorControllerObject: AutomatorController!
    @IBOutlet weak var PreferencesObject: Preferences!
    @IBOutlet weak var MiniPlayerCoverPanel: NSPanel!
    @IBOutlet weak var MiniPlayerButton: NSButton!
    var wasPressed = false
    
    
    func spawnMiniPlayerCover(){
        MiniPlayerCoverPanel.center()
        self.showMiniPlayerCover()
    }
    //Make the MiniPlayer cover invisible but still active
    func hideMiniPlayerCover(){
        //Prevents panel from appering in exposé
        MiniPlayerCoverPanel.collectionBehavior = NSWindowCollectionBehavior.stationary
        //Set the panel level so the panel is always above normal windows
        MiniPlayerCoverPanel.level = Int(CGWindowLevelForKey(CGWindowLevelKey.popUpMenuWindow))
        //Makes the max and min size of the panel equal to its current size, so the size of the panel can not be modifed when it is hidded
        MiniPlayerCoverPanel.minSize = NSSize.init(width: MiniPlayerCoverPanel.frame.width, height: MiniPlayerCoverPanel.frame.height)
        MiniPlayerCoverPanel.maxSize = NSSize.init(width: MiniPlayerCoverPanel.frame.width, height: MiniPlayerCoverPanel.frame.height)
        ((MiniPlayerCoverPanel.contentView) as! MiniPlayerCoverView).addTrackingArea()
        //Setting the styleMask to 14 disables the menu bar but allows the panel to still exist (i.e. when clicking, our panel takes the click action, not any object beneith it)
        MiniPlayerCoverPanel.styleMask = NSWindowStyleMask(rawValue: UInt(14))
        //Make the panel invisible and imovable
        MiniPlayerCoverPanel.isOpaque = false
        MiniPlayerCoverPanel.backgroundColor = NSColor.clear
        MiniPlayerCoverPanel.isMovable = false
    }
    //Make the MiniPlayer cover visable and adjustable
    func showMiniPlayerCover(){
        //Allows panel to appear in exposé
        MiniPlayerCoverPanel.collectionBehavior = NSWindowCollectionBehavior.managed
        //Set the panel level so the panel behaves as expected
        MiniPlayerCoverPanel.level = Int(CGWindowLevelForKey(CGWindowLevelKey.normalWindow))
        //Makes the max and min size of the panel equal to their defaults, so that the window can be adjusted
        MiniPlayerCoverPanel.minSize = NSSize.init(width: 148, height: 44)
        MiniPlayerCoverPanel.maxSize = NSSize.init(width: 400, height: 44)
        //Adds close, minimise, and resize buttons to the window without adding a menu bar
        MiniPlayerCoverPanel.titleVisibility = NSWindowTitleVisibility.hidden;
        MiniPlayerCoverPanel.styleMask = NSWindowStyleMask(rawValue: UInt(15))
        MiniPlayerCoverPanel.styleMask.insert(.fullSizeContentView)
        MiniPlayerCoverPanel.styleMask.insert(.closable)
        MiniPlayerCoverPanel.styleMask.insert(.miniaturizable)
        MiniPlayerCoverPanel.styleMask.insert(.resizable)
        MiniPlayerCoverPanel.titlebarAppearsTransparent = true
        //Makes the panel white, visible, and movable
        MiniPlayerCoverPanel.backgroundColor = NSColor.white
        MiniPlayerCoverPanel.isOpaque = true
        MiniPlayerCoverPanel.isMovable = true
        MiniPlayerCoverPanel.isMovableByWindowBackground = true
        
        MiniPlayerCoverPanel.makeKeyAndOrderFront(self)
    }
    
    func showButton(){
        if isHidden() == true {
            if ApplescriptBridge().isiTunesPlaying() == true {
                //Center the button
                let centerX = (MiniPlayerCoverPanel.frame.width / 2) - (28 / 2)
                let centerY = (MiniPlayerCoverPanel.frame.height / 2) - (32 / 2)
                MiniPlayerButton.frame = NSRect.init(x: centerX, y: centerY, width: 28, height: 32)
                MiniPlayerButton.image = NSImage.init(named:"PauseMain.png")
                MiniPlayerButton.alternateImage = NSImage.init(named: "PauseAlternate.pmg")
            }
            else{
                //Center the button
                let centerX = (MiniPlayerCoverPanel.frame.width / 2) - (36 / 2)
                let centerY = (MiniPlayerCoverPanel.frame.height / 2) - (36 / 2)
                MiniPlayerButton.frame = NSRect.init(x: centerX, y: centerY, width: 36, height: 36)
                MiniPlayerButton.image = NSImage.init(named:"PlayMain.png")
                MiniPlayerButton.alternateImage = NSImage.init(named: "PlayAlternate.pmg")
            }
            MiniPlayerCoverPanel.isOpaque = true
            MiniPlayerCoverPanel.backgroundColor = NSColor.white
        }
    }
    
    func hideButton(){
        if isHidden() == true {
            MiniPlayerButton.frame = NSRect.init(x: 0, y: 0, width: 0, height: 0)
            MiniPlayerButton.image = nil
            MiniPlayerCoverPanel.isOpaque = false
            MiniPlayerCoverPanel.backgroundColor = NSColor.clear
        }
    }
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        //Was pressed prevents the button from having any effect after it has been pressed but before the effects have taken affect. So if a user hits stop, the application waits for the song to finish, but the user can not flood the system with more stop requests.
        if wasPressed == false {
            let applescriptBridge = ApplescriptBridge()
            if ApplescriptBridge().isiTunesPlaying() == true {
                //**Clear all upcoming songs from iTunes**
                //I wish. Apperently you can't do that with applescript. (At least not directly, and I refuse to and any 'tell system events to press a button' bullshit because that is SO breakable its not even funny. 
                //What actually occures is that the stop command is issued once the track has completed. 
                wasPressed = true
                let rawDelayTime = applescriptBridge.timeLeftInCurrentSong()
                let delayTime = DispatchTime.now() + Double(Int64( (rawDelayTime - 1.0) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    applescriptBridge.iTunesStop()
                    self.wasPressed = false
                }
            }
            else{
                wasPressed = true
                //Immediatily start playing a track from tier 1
                let numOfSongs = applescriptBridge.getNumberOfSongsInPlaylist(aPlaylist: "Tier 1")
                let randomNumber = arc4random_uniform(numOfSongs.uint32Value) + 1
                applescriptBridge.playSongFromPlaylist(aTrack: Int(randomNumber), aPlaylist: "Tier 1")
                //Then start generating a playlist using the default automator
                //Determine the name of our generated playlist. This is done to prevent name overlap. We also delete any automated DJ playlist which is not currently playing so that we do not have duplicates of the same playlist.
                var generatedPlaylistName = "Automated DJ"
                //get currently playing playlist
                let currentPlaylist = applescriptBridge.getCurrentPlaylist()
                if currentPlaylist != "Automated DJ" && currentPlaylist != "Automated DJ2" {
                    applescriptBridge.deletePlaylistWithName(aName: "Automated DJ")
                    applescriptBridge.deletePlaylistWithName(aName: "Automated DJ2")
                }
                else if currentPlaylist == "Automated DJ2" {
                    applescriptBridge.deletePlaylistWithName(aName: "Automated DJ")
                }
                else if currentPlaylist == "Automated DJ" {
                    applescriptBridge.deletePlaylistWithName(aName: "Automated DJ2")
                    generatedPlaylistName = "Automated DJ2"
                }
                let rawDelayTime = applescriptBridge.timeLeftInCurrentSong()
                let delayTime = DispatchTime.now() + Double(Int64( (rawDelayTime - 1.0) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.AutomatorControllerObject.playGeneratedPlaylist(generatedPlaylistName)
                    self.wasPressed = false
                }
                AutomatorControllerObject.generatePlaylist(generatedPlaylistName, anAutomator: PreferencesObject.defaultAutomator)
                //Change button icon to stop
                let centerX = (MiniPlayerCoverPanel.frame.width / 2) - (28 / 2)
                let centerY = (MiniPlayerCoverPanel.frame.height / 2) - (32 / 2)
                MiniPlayerButton.frame = NSRect.init(x: centerX, y: centerY, width: 28, height: 32)
                MiniPlayerButton.image = NSImage.init(named:"PauseMain.png")
                MiniPlayerButton.alternateImage = NSImage.init(named: "PauseAlternate.pmg")
            }
        }
    }
    func isHidden() -> Bool {
        if MiniPlayerCoverPanel.styleMask.rawValue == 14 {
            return true
        }
        else{
            return false
        }
    }
}
