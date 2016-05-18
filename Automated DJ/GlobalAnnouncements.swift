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
    @IBOutlet weak var globalAnnouncementsWindow: NSWindow!
    
    var dataArray = [String]()
    
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