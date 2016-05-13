//
//  MasterSchedule.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/11/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class MasterSchedule: NSObject, NSTableViewDataSource, NSTableViewDelegate{
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
    
    func tableView(tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        //Convert the data array into an NSMutableArray, sort that using the given SortDescriptor, and then convert it back to an array. Then reload the data. We do this because array can not be sorted by SortDescriptor as of Swift 2.2 but NSMutableArray can.
        let dataMutableArray = NSMutableArray(array: dataArray)
        dataMutableArray.sortUsingDescriptors(tableView.sortDescriptors)
        dataArray = dataMutableArray as AnyObject as! [Show]
        tableView.reloadData()
    }
    
    //Called by AppDelegate after application has finished launching. Think of this function as an initalization function
    func viewDidLoad(){
        //Create a showColumn variable using an Identifier to get the corresponding column from the tableView
        let showColumn = tableView.tableColumnWithIdentifier("showName")
        //Create a new sortDescriptor. Key refers to the variable in the object being sorted. So we are sorting our array of Shows by the name field. Assending is true and we use a caseInsensitiveCompare selector to determine the way we sort.
        let showSortDescriptor = NSSortDescriptor(key:"name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        //Set our showColumn's sortDescriptor to the one we just made
        showColumn?.sortDescriptorPrototype = showSortDescriptor

        //AutomatorColumn sorting. Not fully tested. Implemented before automator added. 5/13/16. TODO
        let automatorColumn = tableView.tableColumnWithIdentifier("automated")
        let automatorSortDescriptor = NSSortDescriptor(key: "automator", ascending: true, selector: #selector(Automator.compare(_:)))
        automatorColumn?.sortDescriptorPrototype = automatorSortDescriptor
        
        //TimeColumn sorting. 1000% easier than in 1.0 release because proper data structures 
        let timeColumn = tableView.tableColumnWithIdentifier("time")
        let timeSortDescriptor = NSSortDescriptor(key: "startDate", ascending: true, selector: #selector(NSDate.compare(_:)))
        timeColumn?.sortDescriptorPrototype = timeSortDescriptor

    }
}