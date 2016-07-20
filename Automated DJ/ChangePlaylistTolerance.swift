//
//  ChangePlaylistTolerance.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 7/20/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class ChangePlaylistTolerance: NSScriptCommand {
    override func performDefaultImplementation() -> AnyObject? {
        let newTolerance = self.evaluatedArguments!["Tolerance"] as! NSNumber
        let result = true
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.PreferencesObject.tollerence = newTolerance.integerValue
        appDelegate.PreferencesObject.setValuesWith(appDelegate.PreferencesObject.preferencesAsArray())
        return result
    }
}
