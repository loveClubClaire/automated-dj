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
    
    //Will need to take parameters. The values of the show being edited
    func spawnEditShowWindow(){
        showWindow.title = "Edit Show"
        //Set the values passed to their respective objects
        showWindow.center()
        showWindow.makeKeyAndOrderFront(self)
        NSApp.runModalForWindow(showWindow)
    }
    
    @IBAction func okButton(sender: AnyObject) {
        //Convert the index of the selected date to that days correcponding day value in the gregorian calendar. (We start with monday at index zero. The gregorian calendar starts on Sunday at index 1.)
        var correctedStartDay = startDay.indexOfSelectedItem
        correctedStartDay = correctedStartDay + 2
        if correctedStartDay == 8 {
            correctedStartDay = 1
        }
        var correctedEndDay = endDay.indexOfSelectedItem
        correctedEndDay = correctedEndDay + 2
        if correctedEndDay == 8 {
            correctedEndDay = 1
        }
        //Create a Gregorian calendar object and create NSDateComponents for the start and end time of the show which contain the hour and minute.
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let startDateComponents: NSDateComponents = calendar!.components([.Hour, .Minute], fromDate: startTime.dateValue)
        startDateComponents.weekday = correctedStartDay
        let endDateComponents: NSDateComponents = calendar!.components([.Hour, .Minute], fromDate: endTime.dateValue)
        endDateComponents.weekday = correctedEndDay
        
        //Check for validity
        
        //Create a new show object using this information
        let show = Show.init(aName: showName.stringValue, aStartDate: (calendar?.dateFromComponents(startDateComponents))!, anEndDate: (calendar?.dateFromComponents(endDateComponents))!)
        //Depending on the state of the isAutomated button...
        if isAutomated.state == 0 {
            //Add it to the MasterScheduleObject or
            MasterScheduleObject.addShow(show)
            cancelButton(self)
        }
        else{
            //Create an automated program
            cancelButton(self)
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
        //Set the show name to its default value
        showName.stringValue = ""
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