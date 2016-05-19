//
//  Preferences.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/19/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class Preferences: NSObject {
    @IBOutlet weak var preferencesWindow: NSWindow!
    @IBOutlet weak var defaultPreferencesView: NSView!
    @IBOutlet weak var advancedPreferencesView: NSView!
    @IBOutlet weak var globalAnnouncementsDelayTextField: NSTextField!
    @IBOutlet weak var isAdminButton: NSButton!
    @IBOutlet weak var tollerenceTextField: NSTextField!
    @IBOutlet weak var testAdminButton: NSButton!

    var defaultAutomator: Automator = Automator()
    
    @IBAction func customizeDefaultAutomator(sender: AnyObject) {
        
    }
    
    @IBAction func okButton(sender: AnyObject) {
        
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        
    }

    
}