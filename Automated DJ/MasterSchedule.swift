//
//  MasterSchedule.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/11/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class MasterSchedule: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    @IBOutlet weak var ShowWindowObject: ShowWindow!
    @IBOutlet weak var tableView: NSTableView!

    var dataArray = [Show]()
    

    @IBAction func createShow(sender: AnyObject) {
        ShowWindowObject.spawnNewShowWindow()
    }
    
    func addShow(aShow: Show){
        dataArray.append(aShow)
        tableView.reloadData()
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return getDataArray().count
    }
    
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // get the item for the row
        let items = getDataArray()
        let item = items[row]
        
        var cellView: NSTableCellView?
       
        // get the NSTableCellView for the column
        let identifier = tableColumn?.identifier

        if identifier == "showName" {
            cellView = (tableView.makeViewWithIdentifier("ShowNameCell", owner: nil) as? NSTableCellView)!
            cellView!.textField?.stringValue = item.valueForKey(identifier!) as! String
        }
        else if identifier == "time"{
            cellView = (tableView.makeViewWithIdentifier("TimeCell", owner: nil) as? NSTableCellView)!
            cellView!.textField?.stringValue = item.valueForKey(identifier!) as! String
        }
        else if identifier == "automated"{
            cellView = (tableView.makeViewWithIdentifier("AutomatedCell", owner: nil) as? NSTableCellView)!
            cellView!.textField?.stringValue = item.valueForKey(identifier!) as! String
        }
        
        // return the populated NSTableCellView
        return cellView
        
    }
    
    
    func getDataArray () -> NSArray{
        let dataArray:[NSDictionary] = [["showName": "Debasis", "time": "Das", "automated": "Yes"],
                                        ["showName": "Nishant", "time": "Singh", "automated": "No"],
                                        ["showName": "John", "time": "Doe", "automated": "Yes"],
                                        ["showName": "Jane", "time": "Doe", "automated": "No"],
                                        ["showName": "Mary", "time": "Jane", "automated": "Yes"]];
        return dataArray;
    }
    
}