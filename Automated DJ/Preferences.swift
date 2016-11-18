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
    @IBOutlet weak var AutomatorWindowObject: AutomatorWindow!
    
    @IBOutlet weak var preferencesWindow: NSWindow!
    @IBOutlet weak var advancedPreferencesWindow: NSWindow!
    @IBOutlet weak var globalAnnouncementsDelayTextField: NSTextField!
    @IBOutlet weak var isAdminButton: NSButton!
    @IBOutlet weak var tollerenceTextField: NSTextField!
    @IBOutlet weak var testAutomatorButton: NSButton!
    @IBOutlet weak var preferencesToolbar: NSToolbar!
    @IBOutlet weak var enableLoggingButton: NSButton!
    @IBOutlet weak var logLocationPopUpButton: NSPopUpButton!
    @IBOutlet weak var logLocationMenu: NSMenu!


    var defaultPreferencesView: NSView!
    var advancedPreferencesView: NSView!
    
    fileprivate var tempAutomator: Automator = Automator.init(aTotalTime: 2.0, aTierOnePrecent: 15, aTierTwoPrecent: 25, aTierThreePrecent: 60)
    var defaultAutomator: Automator = Automator.init(aTotalTime: 2.0, aTierOnePrecent: 15, aTierTwoPrecent: 25, aTierThreePrecent: 60)
    var isAdmin = false
    var globalAnnouncementsDelay = 0
    var tollerence = 0
    var testAutomator = true
    var useLogs = false
    fileprivate var originalLogFilepath = ""
    var logFilepath = ""
    
    //using custom initialize and not init because this is guaranteed to be called after application has finished launching and all of our outlets have sucessfully bound.
    func initialize(){
        defaultPreferencesView = preferencesWindow.contentView
        advancedPreferencesView = advancedPreferencesWindow.contentView
        preferencesWindow.title = "General"
        preferencesToolbar.selectedItemIdentifier = "general"
    }
    
    func setValuesWith(_ anArray: [AnyObject]) {
        defaultAutomator = anArray[0] as! Automator
        tempAutomator = defaultAutomator
        isAdmin = anArray[1] as! Bool
        globalAnnouncementsDelay = anArray[2] as! Int
        tollerence = anArray[3] as! Int
        testAutomator = anArray[4] as! Bool
        useLogs = anArray[5] as! Bool
        logFilepath = anArray[6] as! String
        originalLogFilepath = logFilepath
        //CancelButton is called so that the UI reflects the changes made to the internal values
        cancelButton(self)
    }
    
    func preferencesAsArray() -> [AnyObject] {
        return [defaultAutomator,isAdmin as AnyObject,globalAnnouncementsDelay as AnyObject,tollerence as AnyObject,testAutomator as AnyObject,useLogs as AnyObject,logFilepath as AnyObject]
    }
    
    func spawnPreferencesWindow(){
        tempAutomator = defaultAutomator
        originalLogFilepath = logFilepath
        preferencesWindow.center()
        preferencesWindow.makeKeyAndOrderFront(self)
    }
    
    //Gets a filepath and a menu and sets the first menuItem in the menu to the file given by the filepath and then selects that menuItem
    func setFolderMenu(_ aFilepath: String, aMenu: NSMenu){
        let myWorkspace = NSWorkspace()
        let fileImage = myWorkspace.icon(forFile: aFilepath)
        var imageSize = NSSize(); imageSize.width = 16; imageSize.height = 16;
        fileImage.size = imageSize
        var filepathParts = aFilepath.components(separatedBy: "/")
        let fileName = filepathParts[filepathParts.count - 1]
        aMenu.item(at: 0)?.image = fileImage
        aMenu.item(at: 0)?.title = fileName
        aMenu.performActionForItem(at: 0)
    }
    
    @IBAction func customizeDefaultAutomator(_ sender: AnyObject) {
        let tempShow = Show.init(aName: "Temp", aStartDate: Date.init(), anEndDate: Date.init())
        tempShow.automator = defaultAutomator
        AutomatorWindowObject.automatorWindow.title = "Edit Default Automator"
        AutomatorWindowObject.timeTextField.isEnabled = true
        AutomatorWindowObject.spawnEditAutomatorWindow(tempShow, status: AutomatorStatus())
    }
    
    @IBAction func generalPreferencesButton(_ sender: AnyObject) {
        var tempFrame = preferencesWindow.frame
        tempFrame.origin.y += tempFrame.size.height
        tempFrame.origin.y -= 242
        tempFrame.size.height = 242
        preferencesWindow.setFrame(tempFrame, display: true, animate: true)
        preferencesWindow.title = "General"
        preferencesWindow.contentView = defaultPreferencesView
    }
    
    @IBAction func advancedPrefernecesButton(_ sender: AnyObject) {
        //preferencesWindow.contentView = NSView()
        var tempFrame = preferencesWindow.frame
        tempFrame.origin.y += tempFrame.size.height
        tempFrame.origin.y -= 257
        tempFrame.size.height = 257
        preferencesWindow.setFrame(tempFrame, display: true, animate: true)
        preferencesWindow.title = "Advanced"
        preferencesWindow.contentView = advancedPreferencesView
    }
    
    @IBAction func enableLoggingButton(_ sender: AnyObject) {
        if enableLoggingButton.state == NSOnState {
            logLocationPopUpButton.isEnabled = true
        }
        else{
            logLocationPopUpButton.isEnabled = false
        }
    }
    
    @IBAction func getLogLocationFolder(_ sender: AnyObject) {
        let myPanel = NSOpenPanel()
        myPanel.allowsMultipleSelection = false
        myPanel.canChooseDirectories = true
        myPanel.canChooseFiles = false;
        //If user confirms then call setFolderMenu to update the menu object and update the filepath by setting the signinFilepath variable
        if myPanel.runModal() == NSModalResponseOK {
            setFolderMenu(myPanel.urls[0].path, aMenu: logLocationMenu)
            logFilepath = myPanel.urls[0].path
        }
            //If the user cancels then make the menu have the current directory selected, not the change filepath option selected. Its a UI thing.
        else{
            logLocationMenu.performActionForItem(at: 0)
        }
    }
    
    @IBAction func okButton(_ sender: AnyObject) {
        if isAdminButton.state == NSOnState {isAdmin = true}
        else{isAdmin = false}
        if testAutomatorButton.state == NSOnState {testAutomator = true}
        else{testAutomator = false}
        globalAnnouncementsDelay = globalAnnouncementsDelayTextField.integerValue
        tollerence = tollerenceTextField.integerValue
        if enableLoggingButton.state == NSOnState {useLogs = true}
        else{useLogs = false}
        
        let prefArray = preferencesAsArray()
        NSKeyedArchiver.archiveRootObject(prefArray, toFile: AppDelegateObject.storedPreferencesFilepath)
        preferencesWindow.orderOut(self)
        preferencesToolbar.selectedItemIdentifier = "general"
        generalPreferencesButton(self)
    }
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        defaultAutomator = tempAutomator
        if isAdmin == true {isAdminButton.state = NSOnState}
        else{isAdminButton.state = NSOffState}
        if testAutomator == true {testAutomatorButton.state = NSOnState}
        else{testAutomatorButton.state = NSOffState}
        globalAnnouncementsDelayTextField.integerValue = globalAnnouncementsDelay
        tollerenceTextField.integerValue = tollerence
        if useLogs == true {enableLoggingButton.state = NSOnState}
        else{enableLoggingButton.state = NSOffState}
        enableLoggingButton(self)
        logFilepath = originalLogFilepath
        setFolderMenu(logFilepath, aMenu: logLocationMenu)
        
        preferencesWindow.orderOut(self)
        preferencesToolbar.selectedItemIdentifier = "general"
        generalPreferencesButton(self)
    }
}
