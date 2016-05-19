//
//  GlobalAnnouncements.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/17/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class GloablAnnouncements: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    @IBOutlet weak var AppDelegateObject: AppDelegate!
    @IBOutlet weak var globalAnnouncementsWindow: NSWindow!
    @IBOutlet weak var addGlobalAnnouncementWindow: NSWindow!
    @IBOutlet var addGlobalAnnouncementText: NSTextView!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet var settingTextView: NSTextView!
    @IBOutlet weak var addAnnouncementButton: NSToolbarItem!
    @IBOutlet weak var editMenuItem: NSMenuItem!
    @IBOutlet weak var deleteMenuItem: NSMenuItem!

    
    var isMutable = false
    var dataArray = [String]()
    
    func spawnMutableGlobalAnnouncements(){
        addAnnouncementButton.view?.hidden = false
        editMenuItem.hidden = false; deleteMenuItem.hidden = false;
        globalAnnouncementsWindow.center()
        globalAnnouncementsWindow.makeKeyAndOrderFront(self)
        isMutable = true
    }
    
    func spawnImmutableGlobalAnnouncements(){
        addAnnouncementButton.view?.hidden = true
        editMenuItem.hidden = true; deleteMenuItem.hidden = true;
        globalAnnouncementsWindow.center()
        globalAnnouncementsWindow.makeKeyAndOrderFront(self)
        isMutable = false
    }
    
    
    @IBAction func spawnNewAnnouncementWindow(sender: AnyObject) {
        addGlobalAnnouncementWindow.title = "New Announcement"
        addGlobalAnnouncementWindow.center()
        addGlobalAnnouncementWindow.makeKeyAndOrderFront(self)
        NSApp.runModalForWindow(addGlobalAnnouncementWindow)
    }
    
    @IBAction func addAnnouncement(sender: AnyObject) {
        if addGlobalAnnouncementWindow.title == "New Announcement" {
            dataArray.append(addGlobalAnnouncementText.string!)
        }
        else{
            dataArray.removeAtIndex(tableView.selectedRow)
            dataArray.insert((addGlobalAnnouncementText.string!), atIndex: tableView.selectedRow)
        }
        NSKeyedArchiver.archiveRootObject(dataArray, toFile: AppDelegateObject.storedAnnouncementsFilepath)
        tableView.reloadData()
        cancelNewAnnouncement(self)
    }
    
    @IBAction func cancelNewAnnouncement(sender: AnyObject) {
        addGlobalAnnouncementWindow.title = "New Announcement"
        addGlobalAnnouncementText.string = ""
        NSApp.stopModal()
        addGlobalAnnouncementWindow.orderOut(self)
    }
    
    @IBAction func editAnnouncement(sender: AnyObject) {
        //get all selected elements in the tableview
        var selectedShows = tableView.selectedRowIndexes
        //If the clicked show (if there is one) is not contained in the NSIndexSet, then add it. Because NSIndexSet is not mutable, we need to convert it into a NSMutableIndexSet, add the new value, and then set selectedShows to that new mutable index set.
        if(selectedShows.containsIndex(tableView.clickedRow) == false && tableView.clickedRow != -1){
            let selectedShowsMutable = NSMutableIndexSet.init(indexSet: selectedShows)
            selectedShowsMutable.addIndex(tableView.clickedRow)
            selectedShows = selectedShowsMutable
        }
        if selectedShows.count > 1 {
            let myPopup: NSAlert = NSAlert()
            myPopup.messageText = "Can not edit multiple announcements"
            myPopup.alertStyle = NSAlertStyle.CriticalAlertStyle
            myPopup.addButtonWithTitle("OK")
            myPopup.runModal()
        }
        else if selectedShows.count == 1{
            addGlobalAnnouncementWindow.title = "Edit Announcement"
            addGlobalAnnouncementText.string = dataArray[tableView.selectedRow]
            addGlobalAnnouncementWindow.center()
            addGlobalAnnouncementWindow.makeKeyAndOrderFront(self)
            NSApp.runModalForWindow(addGlobalAnnouncementWindow)
        }
        
    }
    
    @IBAction func deleteAnnouncements(sender: AnyObject) {
        //get all selected elements in the tableview
        var selectedShows = tableView.selectedRowIndexes
        //If the clicked show (if there is one) is not contained in the NSIndexSet, then add it. Because NSIndexSet is not mutable, we need to convert it into a NSMutableIndexSet, add the new value, and then set selectedShows to that new mutable index set.
        if(selectedShows.containsIndex(tableView.clickedRow) == false && tableView.clickedRow != -1){
            let selectedShowsMutable = NSMutableIndexSet.init(indexSet: selectedShows)
            selectedShowsMutable.addIndex(tableView.clickedRow)
            selectedShows = selectedShowsMutable
        }
        //If the number of shows selected is greater than zero, alert the user about the deletion. If they agree to it, remove the items from the dataArray, save the new state of the dataArray, and refresh the tableView
        if selectedShows.count > 0 {
            let myPopup: NSAlert = NSAlert()
            myPopup.messageText = "Are you sure you want to delete the selected announcements?"
            myPopup.informativeText = "This can not be undone"
            myPopup.alertStyle = NSAlertStyle.WarningAlertStyle
            myPopup.addButtonWithTitle("OK")
            myPopup.addButtonWithTitle("Cancel")
            let res = myPopup.runModal()
            if res == NSAlertFirstButtonReturn {
                let dataMutableArray = NSMutableArray(array: dataArray)
                dataMutableArray.removeObjectsAtIndexes(selectedShows)
                dataArray = dataMutableArray as AnyObject as! [String]
                NSKeyedArchiver.archiveRootObject(dataArray, toFile: AppDelegateObject.storedAnnouncementsFilepath)
                tableView.reloadData()
            }
    }
    }

    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        //set the TextView (Which as the same width as the GlobalAnnouncements tableView cell) to the string at the given row in the data array. Then calculate how large the cell needs to be and retrun that value.
        settingTextView.string = dataArray[row]
        return (17.0 * CGFloat(numOfLinesIn(settingTextView)))
    }
    
    func numOfLinesIn(aTextView: NSTextView) -> Int {
        let layoutManager = aTextView.layoutManager
        var numberOfLines = 0
        var index = 0
        var lineRange = NSRange()
        let numberOfGlyphs = layoutManager!.numberOfGlyphs
        
        while index < numberOfGlyphs {
            layoutManager!.lineFragmentRectForGlyphAtIndex(index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange);
            numberOfLines += 1
        }
        if numberOfLines == 0 {return 1}
        return numberOfLines
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        //Get the column identifer, the show for the current row, and create an cellView variable
        let anAnnouncement = dataArray[row]
        let cellView = (tableView.makeViewWithIdentifier("announcementsCell", owner: nil) as? NSTableCellView)!
        
        cellView.textField?.stringValue = anAnnouncement
        
        // return the populated NSTableCellView
        return cellView
        
    }



}