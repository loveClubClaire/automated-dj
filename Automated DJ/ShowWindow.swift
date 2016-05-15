//
//  ShowWindow.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/11/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class ShowWindow: NSObject {
    @IBOutlet weak var showWindow: NSWindow!
    @IBOutlet weak var showName: NSTextField!
    @IBOutlet weak var startTime: NSDatePicker!
    @IBOutlet weak var endTime: NSDatePicker!
    @IBOutlet weak var isAutomated: NSButton!
    @IBOutlet weak var startDay: NSPopUpButton!
    @IBOutlet weak var endDay: NSPopUpButton!
    
    @IBOutlet weak var MasterScheduleObject: MasterSchedule!
    
    func spawnNewShowWindow(){
        showWindow.title = "New Show"
        showWindow.center()
        showWindow.makeKeyAndOrderFront(self)
        NSApp.runModalForWindow(showWindow)
    }
    
    func spawnEditShowWindow(aShow: Show, anAutomator: Automator?, status: ShowStatus){
        showWindow.title = "Edit Shows"
        //Set the values passed to their respective objects
        let timeFormatter = NSDateFormatter();timeFormatter.dateFormat = "hh:mm a"
        let dayFormatter = NSDateFormatter();dayFormatter.dateFormat = "EEEE"
        if status.name == true {showName.stringValue = aShow.name!}
        else{showName.placeholderString = "Mixed"}
        
        if status.startTime == true {startTime.dateValue = aShow.startDate!}
        else{(startTime as! CustomDatePicker).makePlaceholder()}
        
        if status.startDay == true {startDay.selectItemWithTitle(dayFormatter.stringFromDate(aShow.startDate!))}
        else{startDay.selectItem(nil)}
        
        if status.endTime == true {endTime.dateValue = aShow.endDate!}
        else{(endTime as! CustomDatePicker).makePlaceholder()}

        if status.endDay == true {endDay.selectItemWithTitle(dayFormatter.stringFromDate(aShow.endDate!))}
        else{endDay.selectItem(nil)}
        
        if status.automator == true{
            if anAutomator == nil {
               isAutomated.state = 0
            }
            else{
                isAutomated.state = 1
            }
        }
        else{
            isAutomated.state = -1
        }
        //end value setting
        
        showWindow.center()
        showWindow.makeKeyAndOrderFront(self)
        NSApp.runModalForWindow(showWindow)
    }
    
    func getWindowStatus() -> ShowStatus{
        let isNotChanged = ShowStatus()
        if showName.placeholderString != "Mixed" {
            isNotChanged.name = false
        }
        if startDay.indexOfSelectedItem != -1 {
            isNotChanged.startDay = false
        }
        if (startTime as! CustomDatePicker).isPlaceholder() == false {
            isNotChanged.startTime = false
        }
        if endDay.indexOfSelectedItem != -1 {
            isNotChanged.endDay = false
        }
        if (endTime as! CustomDatePicker).isPlaceholder() == false {
            isNotChanged.endTime = false
        }
        if isAutomated.state != -1 {
            isNotChanged.automator = false
        }
        return isNotChanged
    }
    
    @IBAction func okButton(sender: AnyObject) {
        //Create a Gregorian calendar object and create NSDateComponents for the start and end time of the show which contain the hour and minute.
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let startDateComponents: NSDateComponents = calendar!.components([.Hour, .Minute], fromDate: startTime.dateValue)
        let endDateComponents: NSDateComponents = calendar!.components([.Hour, .Minute], fromDate: endTime.dateValue)
        //Set the date to a day in the first week of June, 2015. This month and year were picked because June 1 is a Monday. The actual day isn't relevant, as long as the correct day of the week is preserved in the date.
        startDateComponents.year = 2015
        startDateComponents.month = 6
        startDateComponents.day = startDay.indexOfSelectedItem + 1
        endDateComponents.year = 2015
        endDateComponents.month = 6
        endDateComponents.day = endDay.indexOfSelectedItem + 1
        
        //Check for validity

        //Create a new show object using this information
        let show = Show.init(aName: showName.stringValue, aStartDate: (calendar?.dateFromComponents(startDateComponents))!, anEndDate: (calendar?.dateFromComponents(endDateComponents))!)
        //Depending on the state of the isAutomated button...
        if isAutomated.state == 0 {
            //Add it to the MasterScheduleObject or
            if showWindow.title == "New Show" {MasterScheduleObject.addShow(show)}
            else{MasterScheduleObject.modifyShows(show, aStatus: getWindowStatus())}
            cancelButton(self)
        }
        else{
            if showWindow.title == "New Show" {
                cancelButton(self)
            }
            else{
                
            }
        }
       
        
    }
    
    
    @IBAction func cancelButton(sender: AnyObject) {
        //Create the NSDates which contain the default values for the two NSDatePickers
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let startTimeComponents = NSDateComponents()
        startTimeComponents.hour = 8
        let endTimeComponents = NSDateComponents()
        endTimeComponents.hour = 10
        //Set the NSDatePickers to their default values
        startTime.dateValue = (calendar?.dateFromComponents(startTimeComponents))!
        endTime.dateValue = (calendar?.dateFromComponents(endTimeComponents))!
        //Make the NSDatePickers not placeholders 
        (startTime as! CustomDatePicker).disablePlaceholder()
        (endTime as! CustomDatePicker).disablePlaceholder()
        //Set the show name to its default value and make it selected (like the state it was in when the app launched)
        showName.stringValue = ""
        showName.selectText(self)
        //Set the NSPopUpButtons to their default values (Index at 0 should be Monday)
        startDay.selectItemAtIndex(0)
        endDay.selectItemAtIndex(0)
        //Set the isAutomated Button to its default value (off)
        isAutomated.state = 0
        //Stop the NSApp modal and dismiss the window
        NSApp.stopModal()
        showWindow.orderOut(self)
    }
 
    
}