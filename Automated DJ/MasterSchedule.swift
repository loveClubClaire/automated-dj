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
    @IBOutlet weak var masterScheduleWindow: MasterScheduleWindow!
    @IBOutlet weak var tableView: NSTableView!
    
    var dataArray = [Show]()
    
    //Called by AppDelegate after application has finished launching. Think of this function as an initalization function
    func viewDidLoad(){
        //Create a showColumn variable using an Identifier to get the corresponding column from the tableView
        let showColumn = tableView.tableColumn(withIdentifier: "showName")
        //Create a new sortDescriptor. Key refers to the variable in the object being sorted. So we are sorting our array of Shows by the name field. Assending is true and we use a caseInsensitiveCompare selector to determine the way we sort.
        let showSortDescriptor = NSSortDescriptor(key:"name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        //Set our showColumn's sortDescriptor to the one we just made
        showColumn?.sortDescriptorPrototype = showSortDescriptor
        
        //AutomatorColumn sorting. Not fully tested. Implemented before automator added. 5/13/16. TODO
        let automatorColumn = tableView.tableColumn(withIdentifier: "automated")
        let automatorSortDescriptor = NSSortDescriptor(key: "automator", ascending: true, selector: #selector(Automator.compare(_:)))
        automatorColumn?.sortDescriptorPrototype = automatorSortDescriptor
        
        //TimeColumn sorting. 1000% easier than in 1.0 release because proper data structures
        let timeColumn = tableView.tableColumn(withIdentifier: "time")
        let timeSortDescriptor = NSSortDescriptor(key: "startDate", ascending: true, selector: #selector(NSDate.compare(_:)))
        timeColumn?.sortDescriptorPrototype = timeSortDescriptor
        
    }

    func spawnMasterScheduleWindow(){
        masterScheduleWindow.center()
        masterScheduleWindow.makeKeyAndOrderFront(self)
    }
    
    @IBAction func createShow(_ sender: AnyObject) {
        ShowWindowObject.spawnNewShowWindow()
    }
    
    func addShow(_ aShow: Show){
        dataArray.append(aShow)
        NSKeyedArchiver.archiveRootObject(dataArray, toFile: AppDelegateObject.storedProgramsFilepath)
        tableView.reloadData()
    }
    
    @IBAction func editShows(_ sender: AnyObject) {
        //get all selected elements in the tableview
        var selectedShows = tableView.selectedRowIndexes
        //If the clicked show (if there is one) is not contained in the NSIndexSet, then add it. Because NSIndexSet is not mutable, we need to convert it into a NSMutableIndexSet, add the new value, and then set selectedShows to that new mutable index set.
        if(selectedShows.contains(tableView.clickedRow) == false && tableView.clickedRow != -1){
            let selectedShowsMutable = NSMutableIndexSet.init(indexSet: selectedShows)
            selectedShowsMutable.add(tableView.clickedRow)
            selectedShows = selectedShowsMutable as IndexSet
        }
        //If the number of shows selected is greater than zero, get the value of the first selected show and its automator. Then compare it to all other selected shows and automators. If any fields in either object are different, then change that fields assoicated (position 0 = show.name etc etc. Its not programmably assoicated) status boolean to false. Then sent the automator, show, and status array to the ShowWindow class.
        if selectedShows.count > 0 {
            var userConfirmed = true
            if selectedShows.count > 1 {
                let myPopup: NSAlert = NSAlert()
                myPopup.messageText = "Are you sure you want to edit information for multiple shows?"
                myPopup.alertStyle = NSAlertStyle.warning
                myPopup.addButton(withTitle: "Edit Shows")
                myPopup.addButton(withTitle: "Cancel")
                let res = myPopup.runModal()
                if res != NSAlertFirstButtonReturn {
                    userConfirmed = false
                }
            }
            if userConfirmed == true {
            var index = selectedShows.first
            let status = ShowStatus()
            let automatorStatus = AutomatorStatus()
            let aShow = dataArray[index!]
            var anAutomator = aShow.automator
            index = selectedShows.integerGreaterThan(index!)
            while index != NSNotFound {
                let timeFormatter = DateFormatter();timeFormatter.dateFormat = "hh:mm a"
                let dayFormatter = DateFormatter();dayFormatter.dateFormat = "EEEE"
                
                if aShow.name != dataArray[index!].name {status.name = false}
                if dayFormatter.string(from: aShow.startDate! as Date) !=  dayFormatter.string(from: dataArray[index!].startDate! as Date){status.startDay = false}
                if timeFormatter.string(from: aShow.startDate! as Date) !=  timeFormatter.string(from: dataArray[index!].startDate! as Date){status.startTime = false}
                if dayFormatter.string(from: aShow.endDate! as Date) !=  dayFormatter.string(from: dataArray[index!].endDate! as Date){status.endDay = false}
                if timeFormatter.string(from: aShow.endDate! as Date) != timeFormatter.string(from: dataArray[index!].endDate! as Date){status.endTime = false}
                
               
                if dataArray[index!].automator != nil {
                    if anAutomator == nil {
                        anAutomator = dataArray[index!].automator
                        status.automator = false
                    }
                    else{
                        //DO compares
                        if anAutomator?.totalTime != dataArray[index!].automator?.totalTime {automatorStatus.totalTime = false}
                        if (anAutomator?.tierOnePrecent)! != (dataArray[index!].automator?.tierOnePrecent)! {automatorStatus.tierOnePrecent = false}
                        if (anAutomator?.tierTwoPrecent)! != (dataArray[index!].automator?.tierTwoPrecent)! {automatorStatus.tierTwoPrecent = false}
                        if (anAutomator?.tierThreePrecent)! != (dataArray[index!].automator?.tierThreePrecent)! {automatorStatus.tierThreePrecent = false}
                        if anAutomator?.seedPlayist != dataArray[index!].automator?.seedPlayist {automatorStatus.seedPlayist = false}
                        if anAutomator?.bumpersPlaylist != dataArray[index!].automator?.bumpersPlaylist {automatorStatus.bumpersPlaylist = false}
                        if anAutomator?.bumpersPerBlock != (dataArray[index!].automator?.bumpersPerBlock)! {automatorStatus.bumpersPerBlock = false}
                        if anAutomator?.songsBetweenBlocks != (dataArray[index!].automator?.songsBetweenBlocks)! {automatorStatus.songsBetweenBlocks = false}
                        if anAutomator?.rules != dataArray[index!].automator?.rules {automatorStatus.rules = false}
                        
                        if (anAutomator?.seedPlayist == nil && dataArray[index!].automator?.seedPlayist != nil) || (anAutomator?.seedPlayist != nil && dataArray[index!].automator?.seedPlayist == nil){
                            automatorStatus.seedState = false
                        }
                        if (anAutomator?.bumpersPlaylist == nil && dataArray[index!].automator?.bumpersPlaylist != nil) || (anAutomator?.bumpersPlaylist != nil && dataArray[index!].automator?.bumpersPlaylist == nil){
                            automatorStatus.bumpersState = false
                        }
                        if (anAutomator?.rules == nil && dataArray[index!].automator?.rules != nil) || (anAutomator?.rules != nil && dataArray[index!].automator?.rules == nil){
                            automatorStatus.rulesState = false
                        }
                    }
                }
                else if anAutomator != nil{
                    status.automator = false
                }

                index = selectedShows.integerGreaterThan(index!)
            }
            status.automatorStatus = automatorStatus
            ShowWindowObject.spawnEditShowWindow(aShow, anAutomator: anAutomator, status: status)
            }
        }
    }
    
    func modifyShows(_ aShow: Show, aStatus: ShowStatus){
        //get all selected elements in the tableview
        let selectedShows = tableView.selectedRowIndexes
        var index = selectedShows.first
        //itterate through the selected shows and modify each one
        while index != NSNotFound {
            dataArray[index!] = aStatus.modifyShow(dataArray[index!], masterShow: aShow)
            index = selectedShows.integerGreaterThan(index!)
        }
        NSKeyedArchiver.archiveRootObject(dataArray, toFile: AppDelegateObject.storedProgramsFilepath)
        tableView.reloadData()
    }
    
    @IBAction func deleteShows(_ sender: AnyObject) {
        //get all selected elements in the tableview
        var selectedShows = tableView.selectedRowIndexes
        //If the clicked show (if there is one) is not contained in the NSIndexSet, then add it. Because NSIndexSet is not mutable, we need to convert it into a NSMutableIndexSet, add the new value, and then set selectedShows to that new mutable index set.
        if(selectedShows.contains(tableView.clickedRow) == false && tableView.clickedRow != -1){
            let selectedShowsMutable = NSMutableIndexSet.init(indexSet: selectedShows)
            selectedShowsMutable.add(tableView.clickedRow)
            selectedShows = selectedShowsMutable as IndexSet
        }
        //If the number of shows selected is greater than zero, alert the user about the deletion. If they agree to it, remove the items from the dataArray, save the new state of the dataArray, and refresh the tableView
        if selectedShows.count > 0 {
            let myPopup: NSAlert = NSAlert()
            myPopup.messageText = "Are you sure you want to delete the selected shows?"
            myPopup.informativeText = "This can not be undone"
            myPopup.alertStyle = NSAlertStyle.warning
            myPopup.addButton(withTitle: "OK")
            myPopup.addButton(withTitle: "Cancel")
            let res = myPopup.runModal()
            if res == NSAlertFirstButtonReturn {
                let dataMutableArray = NSMutableArray(array: dataArray)
                dataMutableArray.removeObjects(at: selectedShows)
                dataArray = dataMutableArray as AnyObject as! [Show]
                NSKeyedArchiver.archiveRootObject(dataArray, toFile: AppDelegateObject.storedProgramsFilepath)
                tableView.reloadData()
            }
        }
    }
    
    func getSelectedShows() -> [Show] {
        //get all selected elements in the tableview
        var selectedShows = tableView.selectedRowIndexes
        //If the clicked show (if there is one) is not contained in the NSIndexSet, then add it. Because NSIndexSet is not mutable, we need to convert it into a NSMutableIndexSet, add the new value, and then set selectedShows to that new mutable index set.
        if(selectedShows.contains(tableView.clickedRow) == false && tableView.clickedRow != -1){
            let selectedShowsMutable = NSMutableIndexSet.init(indexSet: selectedShows)
            selectedShowsMutable.add(tableView.clickedRow)
            selectedShows = selectedShowsMutable as IndexSet
        }

        var selectedShowsArray = [Show]()
        var index = selectedShows.first
        while index != NSNotFound {
            selectedShowsArray.append(dataArray[index!])
            index = selectedShows.integerGreaterThan(index!)
        }
        return selectedShowsArray
    }
    
    @IBAction func saveSchedule(_ sender: AnyObject) {
        let savePanel = NSSavePanel()
        let result = savePanel.runModal()
        if result == NSFileHandlingPanelOKButton {
            var filepath = savePanel.url?.path
            filepath = filepath! + ".adjs"
            NSKeyedArchiver.archiveRootObject(dataArray, toFile: filepath!)
        }
    }
    
    @IBAction func loadSchedule(_ sender: AnyObject) {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = "All unsaved scheduler data will be lost"
        myPopup.informativeText = "Are you sure you want to continue?"
        myPopup.alertStyle = NSAlertStyle.critical
        myPopup.addButton(withTitle: "OK")
        myPopup.addButton(withTitle: "Cancel")
        let res = myPopup.runModal()
        if res == NSAlertFirstButtonReturn {
            let openPanel = NSOpenPanel()
            openPanel.allowedFileTypes = ["adjs"]
            openPanel.allowsMultipleSelection = false
            openPanel.canChooseDirectories = false
            openPanel.canChooseFiles = true
            let result = openPanel.runModal()
            if result == NSFileHandlingPanelOKButton {
                let filepath = openPanel.url?.path
                dataArray = NSKeyedUnarchiver.unarchiveObject(withFile: filepath!) as! [Show]
                NSKeyedArchiver.archiveRootObject(dataArray, toFile: AppDelegateObject.storedProgramsFilepath)
                tableView.reloadData()
            }
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        //Get the column identifer, the show for the current row, and create an empty cellView variable
        let identifier = tableColumn?.identifier
        let aShow = dataArray[row]
        var cellView: NSTableCellView?
        
        //What column we are working with determins what show information is placed into it. Inside the if statenment places information into a single cell view
        if identifier == "showName" {
            //Create cellView and set its value to the show name. ("ShowNameCell" needs to be defined in IB and be an actual cell in the default table view)
            cellView = (tableView.make(withIdentifier: "ShowNameCell", owner: nil) as? NSTableCellView)!
            cellView!.textField?.stringValue = aShow.name!
        }
        else if identifier == "time"{
            //Create cell view
            cellView = (tableView.make(withIdentifier: "TimeCell", owner: nil) as? NSTableCellView)!
            //Create date formatters for time and day
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm a"
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEEE"
            //Convert the shows dates into strings
            let startDay = dayFormatter.string(from: aShow.startDate! as Date)
            let startTime = timeFormatter.string(from: aShow.startDate! as Date)
            let endDay = dayFormatter.string(from: aShow.endDate! as Date)
            let endTime = timeFormatter.string(from: aShow.endDate! as Date)
            //Append those strings together and set their value to the cell view
            cellView!.textField?.stringValue = startDay + ", " + startTime + " - " + endDay + ", " + endTime
        }
        else if identifier == "automated"{
            //Create cell view and if there's not an automator set its value to no otherwise set it to no
            cellView = (tableView.make(withIdentifier: "AutomatedCell", owner: nil) as? NSTableCellView)!
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
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        //Convert the data array into an NSMutableArray, sort that using the given SortDescriptor, and then convert it back to an array. Then reload the data. We do this because array can not be sorted by SortDescriptor as of Swift 2.2 but NSMutableArray can.
        let dataMutableArray = NSMutableArray(array: dataArray)
        dataMutableArray.sort(using: tableView.sortDescriptors)
        dataArray = dataMutableArray as AnyObject as! [Show]
        tableView.reloadData()
    }
    
}
