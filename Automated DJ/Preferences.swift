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
    @IBOutlet weak var testAutomatorButton: NSButton!

    private var tempAutomator: Automator = Automator()
    var defaultAutomator: Automator = Automator()
    var isAdmin = false
    var globalAnnouncementsDelay = 0
    var tollerence = 0
    var testAutomator = true
    
    func spawnPreferencesWindow(){
        tempAutomator = defaultAutomator
        preferencesWindow.center()
        preferencesWindow.makeKeyAndOrderFront(self)
    }
    
    @IBAction func customizeDefaultAutomator(sender: AnyObject) {
        //Sets tempAutomator
    }
    
    @IBAction func okButton(sender: AnyObject) {
        defaultAutomator = tempAutomator
        if isAdminButton.state == NSOnState {isAdmin = true}
        else{isAdmin = false}
        if testAutomatorButton.state == NSOnState {testAutomator = true}
        else{testAutomator = false}
        globalAnnouncementsDelay = globalAnnouncementsDelayTextField.integerValue
        tollerence = tollerenceTextField.integerValue
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        if isAdmin == true {isAdminButton.state = NSOnState}
        else{isAdminButton.state = NSOffState}
        if testAutomator == true {testAutomatorButton.state = NSOnState}
        else{testAutomatorButton.state = NSOffState}
        globalAnnouncementsDelayTextField.integerValue = globalAnnouncementsDelay
        tollerenceTextField.integerValue = tollerence
    }

    
}