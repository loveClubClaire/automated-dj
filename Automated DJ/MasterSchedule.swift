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
    @IBOutlet weak var AppDelegateObject: AppDelegate!
    @IBOutlet weak var tableView: NSTableView!

    var dataArray = [Show]()
    

    @IBAction func createShow(sender: AnyObject) {
        ShowWindowObject.spawnNewShowWindow()
    }
    
    func addShow(aShow: Show){
        dataArray.append(aShow)
        NSKeyedArchiver.archiveRootObject(dataArray, toFile: AppDelegateObject.storedProgramsFilepath)
        tableView.reloadData()
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        //Get the column identifer, the show for the current row, and create an empty cellView variable
        let identifier = tableColumn?.identifier
        let aShow = dataArray[row]
        var cellView: NSTableCellView?
        
        //What column we are working with determins what show information is placed into it. Inside the if statenment places information into a single cell view
        if identifier == "showName" {
            //Create cellView and set its value to the show name. ("ShowNameCell" needs to be defined in IB and be an actual cell in the default table view)
            cellView = (tableView.makeViewWithIdentifier("ShowNameCell", owner: nil) as? NSTableCellView)!
            cellView!.textField?.stringValue = aShow.name!
        }
        else if identifier == "time"{
            //Create cell view
            cellView = (tableView.makeViewWithIdentifier("TimeCell", owner: nil) as? NSTableCellView)!
            //Create date formatters for time and day
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "hh:mm a"
            let dayFormatter = NSDateFormatter()
            dayFormatter.dateFormat = "EEEE"
            //Convert the shows dates into strings
            let startDay = dayFormatter.stringFromDate(aShow.startDate!)
            let startTime = timeFormatter.stringFromDate(aShow.startDate!)
            let endDay = dayFormatter.stringFromDate(aShow.endDate!)
            let endTime = timeFormatter.stringFromDate(aShow.endDate!)
            //Append those strings together and set their value to the cell view
            cellView!.textField?.stringValue = startDay + ", " + startTime + " - " + endDay + ", " + endTime
        }
        else if identifier == "automated"{
            //Create cell view and if there's not an automator set its value to no otherwise set it to no
            cellView = (tableView.makeViewWithIdentifier("AutomatedCell", owner: nil) as? NSTableCellView)!
            if aShow.automator == nil {
                 cellView!.textField?.stringValue = "No"
            }
            else{
                 cellView!.textField?.stringValue = "Yes"
            }
        }
        
        // return the populated NSTableCellView
        return cellView
        
    }
    
}