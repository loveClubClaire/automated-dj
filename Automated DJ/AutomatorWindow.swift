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
    
    func spawnEditAutomatorWindow(aShow: Show, status: AutomatorStatus){
        automatorWindow.title = "Edit Automators"
        show = aShow
        if status.totalTime == true {timeTextField.doubleValue = (aShow.automator?.totalTime)!}
        else{timeTextField.placeholderString = "Mixed"}
        if status.tierOnePrecent == true {tierOneTextField.integerValue = (aShow.automator?.tierOnePrecent)!}
        else{tierOneTextField.placeholderString = "Mixed"}
        if status.tierTwoPrecent == true {tierTwoTextField.integerValue = (aShow.automator?.tierTwoPrecent)!}
        else{tierTwoTextField.placeholderString = "Mixed"}
        if status.tierThreePrecent == true {tierThreeTextField.integerValue = (aShow.automator?.tierThreePrecent)!}
        else{tierThreeTextField.placeholderString = "Mixed"}
        
        
        
        //If seedState == true, it means all automators are either on or off. If the seedPlaylist of the automator we have is nil, we know that ALL of the automators seedPlaylist are nil, and thusly we can set the button to the NSOffState. If its not nil, we know ALL of the automators have a seedPlaylist and we set the button to NSOnState. If all of the automators seedPlaylist's are the same, we set the seedPlaylistButton to that playlist. Otherwise, it will remain unselected. 
        //If seedState == false, we allow the button to have a mixed state and then set the state to mixed.
        seedPlaylistButton.selectItemAtIndex(-1)
        if status.seedState == true {
            if aShow.automator?.seedPlayist == nil {
                hasSeedPlaylistButton.state = NSOffState
            }
            else{
                hasSeedPlaylistButton.state = NSOnState
                seedPlaylistButton.enabled = true
                if status.seedPlayist == true {seedPlaylistButton.selectItemWithTitle((aShow.automator?.seedPlayist)!)}
            }
        }
        else{
            hasSeedPlaylistButton.allowsMixedState = true
            hasSeedPlaylistButton.state = NSMixedState
        }

        //See seedState == true comment
        bumpersPlaylistButton.selectItemAtIndex(-1)
        if status.bumpersState == true {
            if aShow.automator?.bumpersPlaylist == nil {
                hasBumpersButton.state = NSOffState
            }
            else{
                hasBumpersButton.state = NSOnState
                bumpersPlaylistButton.enabled = true
                bumpersPerBlockTextField.enabled = true
                songsBetweenBlocksTextField.enabled = true
                if status.bumpersPlaylist == true {bumpersPlaylistButton.selectItemWithTitle((aShow.automator?.bumpersPlaylist)!)}
            }
        }
        else{
            hasBumpersButton.allowsMixedState = true
            hasBumpersButton.state = NSMixedState
        }
        if hasBumpersButton.state == NSOnState || hasBumpersButton.state == NSMixedState {
            if status.bumpersPerBlock == true {bumpersPerBlockTextField.integerValue = (aShow.automator?.bumpersPerBlock)!}
            else{bumpersPerBlockTextField.placeholderString = "Mixed"}
            if status.songsBetweenBlocks == true {songsBetweenBlocksTextField.integerValue = (aShow.automator?.songsBetweenBlocks)!}
            else{songsBetweenBlocksTextField.placeholderString = "Mixed"}
        }
        
        //See seedState == true comment
        if status.rulesState == true {
            if aShow.automator?.rules == nil {
                hasRulesButton.state = NSOffState
            }
            else{
                hasRulesButton.state = NSOnState
                if status.rules == true {
                    RuleScrollViewObject.predicateEditor.objectValue = aShow.automator?.rules
                    RuleScrollViewObject.predicateEditor.reloadPredicate()
                    RuleScrollViewObject.predicateEditorView.hidden = false
                }
            }
        }
        else{
            hasRulesButton.allowsMixedState = true
            hasRulesButton.state = NSMixedState
        }
        
        //end value setting
        automatorWindow.center()
        automatorWindow.makeKeyAndOrderFront(self)
        NSApp.runModalForWindow(automatorWindow)

    }
    
    func getWindowStatus() -> AutomatorStatus{
        let isNotChanged = AutomatorStatus()
        if tierOneTextField.stringValue != "" {
            isNotChanged.tierOnePrecent = false
        }
        if tierTwoTextField.stringValue != "" {
            isNotChanged.tierTwoPrecent = false
        }
        if tierThreeTextField.stringValue != "" {
            isNotChanged.tierThreePrecent = false
        }
        
        if seedPlaylistButton.indexOfSelectedItem != -1 {
            isNotChanged.seedPlayist = false
        }
        if bumpersPlaylistButton.indexOfSelectedItem != -1 {
            isNotChanged.bumpersPlaylist = false
        }
        
        if bumpersPerBlockTextField.stringValue != "" {
            isNotChanged.bumpersPerBlock = false
        }
        if songsBetweenBlocksTextField.stringValue != "" {
            isNotChanged.songsBetweenBlocks = false
        }
        
        if RuleScrollViewObject.predicateEditorView.hidden != true{
            isNotChanged.rules = false
        }
    
        return isNotChanged
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
        let status = ShowWindowObject.getWindowStatus()
        status.automatorStatus = getWindowStatus()
        if ShowWindowObject.showWindow.title == "New Show" {MasterScheduleObject.addShow(show)}
        else{MasterScheduleObject.modifyShows(show, aStatus: status)}
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
        //Make all the placeholder strings empty as well
        timeTextField.placeholderString = ""
        tierOneTextField.placeholderString = ""
        tierTwoTextField.placeholderString = ""
        tierThreeTextField.placeholderString = ""
        bumpersPerBlockTextField.placeholderString = ""
        songsBetweenBlocksTextField.placeholderString = ""
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
            if automatorWindow.title == "Edit Automators" {
                ShowWindowObject.showWindow.center()
                ShowWindowObject.showWindow.makeKeyAndOrderFront(self)
                NSApp.runModalForWindow(ShowWindowObject.showWindow)
            }
            else{
                ShowWindowObject.spawnNewShowWindow()
            }
        }
        
    }

    //Funciton is bound to the seedPlaylist button. When changed to an off state, it disables the correcponding seed popupButton. When changed to an on state, it endables it. Whenever the button is pressed, it sets its allowsMixedState value to false. This allows for a button to have an NSMixedState to represent mixed values, but the user can not choose NSMixedState
    @IBAction func seedPlaylistPressed(sender: AnyObject) {
        hasSeedPlaylistButton.allowsMixedState = false
        if hasSeedPlaylistButton.state == NSOnState {
            seedPlaylistButton.enabled = true
        }
        else{
            seedPlaylistButton.enabled = false
        }
    }
    @IBAction func bumpersPlaylistPressed(sender: AnyObject) {
        hasBumpersButton.allowsMixedState = false
        if hasBumpersButton.state == NSOnState {
            bumpersPlaylistButton.enabled = true
            bumpersPerBlockTextField.enabled = true
            songsBetweenBlocksTextField.enabled = true
        }
        else{
            bumpersPlaylistButton.enabled = false
            bumpersPerBlockTextField.enabled = false
            songsBetweenBlocksTextField.enabled = false
            bumpersPerBlockTextField.placeholderString = ""
            songsBetweenBlocksTextField.placeholderString = ""
        }
    }
    @IBAction func rulesPressed(sender: AnyObject) {
        hasRulesButton.allowsMixedState = false
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
