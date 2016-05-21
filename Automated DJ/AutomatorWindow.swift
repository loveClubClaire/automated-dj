//
//  AutomatorWindow.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/11/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class AutomatorWindow: NSObject {
    @IBOutlet weak var RuleScrollViewObject: RuleScrollView!
    @IBOutlet weak var ShowWindowObject: ShowWindow!
    @IBOutlet weak var MasterScheduleObject: MasterSchedule!
    
    @IBOutlet weak var automatorWindow: NSWindow!
    @IBOutlet weak var timeTextField: NSTextField!
    @IBOutlet weak var tierOneTextField: NSTextField!
    @IBOutlet weak var tierTwoTextField: NSTextField!
    @IBOutlet weak var tierThreeTextField: NSTextField!
    
    @IBOutlet weak var seedPlaylistButton: NSPopUpButton!
    @IBOutlet weak var bumpersPlaylistButton: NSPopUpButton!
    @IBOutlet weak var bumpersPerBlockTextField: NSTextField!
    @IBOutlet weak var songsBetweenBlocksTextField: NSTextField!
    
    @IBOutlet weak var hasSeedPlaylistButton: NSButton!
    @IBOutlet weak var hasBumpersButton: NSButton!
    @IBOutlet weak var hasRulesButton: NSButton!

    @IBOutlet weak var predicateTypePopUp: NSPopUpButton!
    
    var show: Show!
    var finalSubmit = false
    
    func spawnNewAutomatorWindow(length: Double, aShow: Show){
        automatorWindow.title = "New Automator"
        timeTextField.doubleValue = length
        show = aShow
        automatorWindow.center()
        automatorWindow.makeKeyAndOrderFront(self)
        NSApp.runModalForWindow(automatorWindow)
    }
    
    
    @IBAction func okButton(sender: AnyObject) {
        let time = timeTextField.doubleValue
        let tier1 = tierOneTextField.integerValue
        let tier2 = tierTwoTextField.integerValue
        let tier3 = tierThreeTextField.integerValue
        var seed: String? = nil
        var bumpers: String? = nil
        var bumpersPerBlock: Int? = nil
        var songsBetweenBumpers: Int? = nil
        var rules: NSPredicate? = nil
        
        if hasSeedPlaylistButton.state == NSOnState {
            seed = seedPlaylistButton.titleOfSelectedItem
        }
        if hasBumpersButton.state == NSOnState {
            bumpers = bumpersPlaylistButton.titleOfSelectedItem
            bumpersPerBlock = bumpersPerBlockTextField.integerValue
            songsBetweenBumpers = songsBetweenBlocksTextField.integerValue
        }
        if hasRulesButton.state == NSOnState {
            rules = getRules()
        }
        
        let anAutomator = Automator.init(aTotalTime: time, aTierOnePrecent: tier1, aTierTwoPrecent: tier2, aTierThreePrecent: tier3, aSeedPlaylist: seed, aBumpersPlaylist: bumpers, aBumpersPerBlock: bumpersPerBlock, aSongBetweenBlocks: songsBetweenBumpers, aRules: rules)
        
        //test new automator 
        
        //return or something. IDK yet
        show.automator = anAutomator
        if ShowWindowObject.showWindow.title == "New Show" {MasterScheduleObject.addShow(show)}
        else{MasterScheduleObject.modifyShows(show, aStatus: ShowWindowObject.getWindowStatus())}
        finalSubmit = true
        cancelButton(self)
        ShowWindowObject.cancelButton(self)
        finalSubmit = false
        
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        //Make all the text fields empty
        timeTextField.stringValue = ""
        tierOneTextField.stringValue = ""
        tierTwoTextField.stringValue = ""
        tierThreeTextField.stringValue = ""
        bumpersPerBlockTextField.stringValue = ""
        songsBetweenBlocksTextField.stringValue = ""
        //Disable all of the buttons
        hasSeedPlaylistButton.state = NSOffState
        hasBumpersButton.state = NSOffState
        hasRulesButton.state = NSOffState
        //Unselect the popup buttons
        seedPlaylistButton.selectItemAtIndex(-1)
        bumpersPlaylistButton.selectItemAtIndex(-1)
        //Disable all the UI which is disabled when the buttons are all of
        seedPlaylistButton.enabled = false
        bumpersPlaylistButton.enabled = false
        bumpersPerBlockTextField.enabled = false
        songsBetweenBlocksTextField.enabled = false
        RuleScrollViewObject.predicateEditorView.hidden = true
        //Replace all rules with the default rule
        let predicate = NSPredicate(format: "Artist = ''")
        RuleScrollViewObject.predicateEditor.objectValue = predicate
        RuleScrollViewObject.predicateEditor.reloadPredicate()
        //Select tierOneTextField as is the default behavior 
        tierOneTextField.selectText(self)
        //StopModal and orderout window
        NSApp.stopModal()
        automatorWindow.orderOut(self)
        //TODO If new or editing
        if finalSubmit == false {
            ShowWindowObject.spawnNewShowWindow()
        }
        
    }

    @IBAction func seedPlaylistPressed(sender: AnyObject) {
        if hasSeedPlaylistButton.state == NSOnState {
            seedPlaylistButton.enabled = true
        }
        else{
            seedPlaylistButton.enabled = false
        }
    }
    @IBAction func bumpersPlaylistPressed(sender: AnyObject) {
        if hasBumpersButton.state == NSOnState {
            bumpersPlaylistButton.enabled = true
            bumpersPerBlockTextField.enabled = true
            songsBetweenBlocksTextField.enabled = true
        }
        else{
            bumpersPlaylistButton.enabled = false
            bumpersPerBlockTextField.enabled = false
            songsBetweenBlocksTextField.enabled = false
        }
    }
    @IBAction func rulesPressed(sender: AnyObject) {
        if hasRulesButton.state == NSOnState {
            RuleScrollViewObject.predicateEditorView.hidden = false
        }
        else{
            RuleScrollViewObject.predicateEditorView.hidden = true
        }
    }
    func changeWindowSizeBy(aHeight: CGFloat){
        var windowFrame = automatorWindow.frame
        windowFrame.size.height = 415 + aHeight
        //If true, window is shrinking
        if (automatorWindow.frame.size.height - windowFrame.size.height) > 0 {
            windowFrame.origin.y = windowFrame.origin.y + 25
        }
        //If true, window is growing
        if (automatorWindow.frame.size.height - windowFrame.size.height) < 0 {
            windowFrame.origin.y = windowFrame.origin.y - 25
        }
        automatorWindow.setFrame(windowFrame, display: true, animate: false)
    }
    
    func getRules() -> NSPredicate{
        var result: NSPredicate
        if RuleScrollViewObject.predicateEditor.numberOfRows == 1{
            result = RuleScrollViewObject.predicateEditor.objectValue as! NSPredicate
        }
        else{
            let predicate = RuleScrollViewObject.predicateEditor.objectValue as! NSCompoundPredicate
            if predicateTypePopUp.titleOfSelectedItem == "Any" {
                result = NSCompoundPredicate.init(orPredicateWithSubpredicates: predicate.subpredicates as! [NSPredicate])
            }
            else{
                result = NSCompoundPredicate.init(andPredicateWithSubpredicates: predicate.subpredicates as! [NSPredicate])
            }
        }
        return result
        //        let result = RuleScrollViewObject.predicateEditor.objectValue
        //        let pred = result as! NSCompoundPredicate
        //        let change = NSCompoundPredicate.init(type: NSCompoundPredicateType.OrPredicateType, subpredicates: pred.subpredicates as! [NSPredicate])
        
        //        let bobPredicate = NSPredicate(format: "Artist = 'U2'")
        //        RuleScrollViewObject.predicateEditor.objectValue = bobPredicate
        //        RuleScrollViewObject.predicateEditor.reloadPredicate()
    }
    
    //TODO on ok / cancel check to see if window was called by show object or preferences object, different actions will need to be taken depending
    
}
