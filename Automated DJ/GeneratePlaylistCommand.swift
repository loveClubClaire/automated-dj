//
//  GeneratePlaylistCommand.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 7/2/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class GeneratePlaylistCommand: NSScriptCommand {
    override func performDefaultImplementation() -> AnyObject? {
        let playlistName = self.evaluatedArguments!["PlaylistName"] as! String
        let result = true
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        let automatorController = appDelegate.AutomatorControllerObject
        let defaultAutomator = appDelegate.PreferencesObject.defaultAutomator
        automatorController.generatePlaylist(playlistName, anAutomator: defaultAutomator)
        return result
    }
}
