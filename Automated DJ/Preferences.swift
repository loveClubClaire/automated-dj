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
    @IBOutlet weak var AppDelegateObject: AppDelegate!
    
    @IBOutlet weak var preferencesWindow: NSWindow!
    @IBOutlet weak var advancedPreferencesWindow: NSWindow!
    @IBOutlet weak var globalAnnouncementsDelayTextField: NSTextField!
    @IBOutlet weak var isAdminButton: NSButton!
    @IBOutlet weak var tollerenceTextField: NSTextField!
    @IBOutlet weak var testAutomatorButton: NSButton!
    @IBOutlet weak var preferencesToolbar: NSToolbar!

    var defaultPreferencesView: NSView!
    var advancedPreferencesView: NSView!
    
    private var tempAutomator: Automator = Automator.init(aTotalTime: 2.0, aTierOnePrecent: 15, aTierTwoPrecent: 25, aTierThreePrecent: 60)
    var defaultAutomator: Automator = Automator.init(aTotalTime: 2.0, aTierOnePrecent: 15, aTierTwoPrecent: 25, aTierThreePrecent: 60)
    var isAdmin = false
    var globalAnnouncementsDelay = 0
    var tollerence = 0
    var testAutomator = true
    
    //using custom initialize and not init because this is guaranteed to be called after application has finished launching and all of our outlets have sucessfully bound.
    func initialize(){
        defaultPreferencesView = preferencesWindow.contentView
        advancedPreferencesView = advancedPreferencesWindow.contentView
        preferencesWindow.title = "General"
        preferencesToolbar.selectedItemIdentifier = "general"
    }
    
    func setValuesWith(anArray: [AnyObject]) {
        defaultAutomator = anArray[0] as! Automator
        isAdmin = anArray[1] as! Bool
        globalAnnouncementsDelay = anArray[2] as! Int
        tollerence = anArray[3] as! Int
        testAutomator = anArray[4] as! Bool
        //CancelButton is called so that the UI reflects the changes made to the internal values
        cancelButton(self)
    }
    
    func preferencesAsArray() -> [AnyObject] {
        return [defaultAutomator,isAdmin,globalAnnouncementsDelay,tollerence,testAutomator]
    }
    
    func spawnPreferencesWindow(){
        tempAutomator = defaultAutomator
        preferencesWindow.center()
        preferencesWindow.makeKeyAndOrderFront(self)
    }
    
    @IBAction func customizeDefaultAutomator(sender: AnyObject) {
        //Sets tempAutomator
        print("TODO")
    }
    
    @IBAction func generalPreferencesButton(sender: AnyObject) {
        //preferencesWindow.contentView = NSView()
        var tempFrame = preferencesWindow.frame
        tempFrame.origin.y += tempFrame.size.height
        tempFrame.origin.y -= 242
        tempFrame.size.height = 242
        preferencesWindow.setFrame(tempFrame, display: true, animate: true)
        preferencesWindow.title = "General"
        preferencesWindow.contentView = defaultPreferencesView
    }
    
    @IBAction func advancedPrefernecesButton(sender: AnyObject) {
        //preferencesWindow.contentView = NSView()
        var tempFrame = preferencesWindow.frame
        tempFrame.origin.y += tempFrame.size.height
        tempFrame.origin.y -= 226
        tempFrame.size.height = 226
        preferencesWindow.setFrame(tempFrame, display: true, animate: true)
        preferencesWindow.title = "Advanced"
        preferencesWindow.contentView = advancedPreferencesView
    }
    
    @IBAction func okButton(sender: AnyObject) {
        defaultAutomator = tempAutomator
        if isAdminButton.state == NSOnState {isAdmin = true}
        else{isAdmin = false}
        if testAutomatorButton.state == NSOnState {testAutomator = true}
        else{testAutomator = false}
        globalAnnouncementsDelay = globalAnnouncementsDelayTextField.integerValue
        tollerence = tollerenceTextField.integerValue
        
        let prefArray = preferencesAsArray()
        NSKeyedArchiver.archiveRootObject(prefArray, toFile: AppDelegateObject.storedPreferencesFilepath)
        preferencesWindow.orderOut(self)
        generalPreferencesButton(self)
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        if isAdmin == true {isAdminButton.state = NSOnState}
        else{isAdminButton.state = NSOffState}
        if testAutomator == true {testAutomatorButton.state = NSOnState}
        else{testAutomatorButton.state = NSOffState}
        globalAnnouncementsDelayTextField.integerValue = globalAnnouncementsDelay
        tollerenceTextField.integerValue = tollerence
        
        preferencesWindow.orderOut(self)
        generalPreferencesButton(self)
    }
}