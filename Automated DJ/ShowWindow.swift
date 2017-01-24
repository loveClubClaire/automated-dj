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
    @IBOutlet weak var MasterScheduleObject: MasterSchedule!
    @IBOutlet weak var AutomatorWindowObject: AutomatorWindow!
    
    @IBOutlet weak var showWindow: NSWindow!
    @IBOutlet weak var showName: NSTextField!
    @IBOutlet weak var startTime: NSDatePicker!
    @IBOutlet weak var endTime: NSDatePicker!
    @IBOutlet weak var isAutomated: NSButton!
    @IBOutlet weak var startDay: NSPopUpButton!
    @IBOutlet weak var endDay: NSPopUpButton!
    
    var showStatus = ShowStatus()
    var editAutomator: Automator?
    
    func spawnNewShowWindow(){
        showWindow.title = "New Show"
        isAutomated.allowsMixedState = false
        showWindow.center()
        showWindow.makeKeyAndOrderFront(self)
        NSApp.runModal(for: showWindow)
    }
    
    func spawnEditShowWindow(_ aShow: Show, anAutomator: Automator?, status: ShowStatus){
        showWindow.title = "Edit Shows"
        isAutomated.allowsMixedState = false
        showStatus = status
        if(anAutomator != nil){
            //Creates a deep copy of the passed automator object to prevent any unexpected value modification due to shared objects
            editAutomator = Automator.init(aTotalTime: (anAutomator?.totalTime)!, aTierOnePrecent: (anAutomator?.tierOnePrecent)!, aTierTwoPrecent: (anAutomator?.tierTwoPrecent)!, aTierThreePrecent: (anAutomator?.tierThreePrecent)!, aSeedPlaylist: anAutomator?.seedPlayist, aBumpersPlaylist: anAutomator?.bumpersPlaylist, aBumpersPerBlock: anAutomator?.bumpersPerBlock, aSongBetweenBlocks: anAutomator?.songsBetweenBlocks, aRules: anAutomator?.rules)
        }
        else{
            editAutomator = nil
        }
        //Set the values passed to their respective objects
        let timeFormatter = DateFormatter();timeFormatter.dateFormat = "hh:mm a"
        let dayFormatter = DateFormatter();dayFormatter.dateFormat = "EEEE"
        if status.name == true {showName.stringValue = aShow.name!}
        else{showName.placeholderString = "Mixed"}
        
        if status.startTime == true {startTime.dateValue = aShow.startDate! as Date}
        else{(startTime as! CustomDatePicker).makePlaceholder()}
        
        if status.startDay == true {startDay.selectItem(withTitle: dayFormatter.string(from: aShow.startDate! as Date))}
        else{startDay.select(nil)}
        
        if status.endTime == true {endTime.dateValue = aShow.endDate! as Date}
        else{(endTime as! CustomDatePicker).makePlaceholder()}

        if status.endDay == true {endDay.selectItem(withTitle: dayFormatter.string(from: aShow.endDate! as Date))}
        else{endDay.select(nil)}
        
        if status.automator == true{
            if anAutomator == nil {
               isAutomated.state = NSOffState
            }
            else{
                isAutomated.state = NSOnState
            }
        }
        else{
            isAutomated.allowsMixedState = true
            isAutomated.state = NSMixedState
        }
        //end value setting
        
        showWindow.center()
        showWindow.makeKeyAndOrderFront(self)
        NSApp.runModal(for: showWindow)
    }
    
    func getWindowStatus() -> ShowStatus{
        let isNotChanged = ShowStatus()
        if showName.stringValue != "" {
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
    
    @IBAction func okButton(_ sender: AnyObject) {
        //Create a Gregorian calendar object and create NSDateComponents for the start and end time of the show which contain the hour and minute.
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var startDateComponents: DateComponents = (calendar as NSCalendar).components([.hour, .minute], from: startTime.dateValue)
        var endDateComponents: DateComponents = (calendar as NSCalendar).components([.hour, .minute], from: endTime.dateValue)
        //Set the date to a day in the first week of June, 2015. This month and year were picked because June 1 is a Monday. The actual day isn't relevant, as long as the correct day of the week is preserved in the date.
        startDateComponents.year = 2015
        startDateComponents.month = 6
        startDateComponents.day = startDay.indexOfSelectedItem + 1
        endDateComponents.year = 2015
        endDateComponents.month = 6
        endDateComponents.day = endDay.indexOfSelectedItem + 1
        //Create a new show object using this information
        let show = Show.init(aName: showName.stringValue, aStartDate: (calendar.date(from: startDateComponents))!, anEndDate: (calendar.date(from: endDateComponents))!)
        //Check for validity
        var selectedShows = MasterScheduleObject.getSelectedShows()
        if selectedShows.count == 0 {selectedShows.append(show)}
        let isValidShow = ErrorChecker.checkShowValidity(show, aShowStatus: getWindowStatus(), selectedShows: selectedShows)
        
        if isValidShow == true {
        //Depending on the state of the isAutomated button...
        if isAutomated.state == NSOffState {
            //Add it to the MasterScheduleObject or
            if showWindow.title == "New Show" {MasterScheduleObject.addShow(show)}
            else{MasterScheduleObject.modifyShows(show, aStatus: getWindowStatus())}
            cancelButton(self)
        }
        else{
            //Calculate the length of the show and thusly the length of the automator
            //dayDifference is redundent code because shows cannot be longer than 24 hours, so if a showlength time is negative, we can safely assume the dayDifference is 1 and there is no need to calculate it. Sue me I'm lazy. 
            //Because we make sure showLength will never be a negative, we can use -1 as an error code. I.E. when spawnEditAutomatorWindow gets a -1 for show length, it can set the labels value to "mixed"
            var dayDifference = endDateComponents.day! - startDateComponents.day!
            if startDateComponents.day == 7 && endDateComponents.day == 1 {dayDifference = 1}
            let endTime = ((Double(endDateComponents.minute!)  / 60.0) + Double(endDateComponents.hour!))
            let startTime = ((Double(startDateComponents.minute!) as Double / 60.0) + Double(startDateComponents.hour!))
            var showLength = (endTime - startTime) + (Double(dayDifference) * 24.0)
            if showLength < 0 {showLength = showLength + 24}
            if((self.startTime as! CustomDatePicker).isPlaceholder() == true || (self.endTime as! CustomDatePicker).isPlaceholder() == true){
                showLength = -1
                showStatus.automatorStatus.totalTime = false
            }
            NSApp.stopModal()
            showWindow.orderOut(self)
            
            if showWindow.title == "New Show" || editAutomator == nil{
                AutomatorWindowObject.spawnNewAutomatorWindow(showLength, aShow: show)
            }
            else{
                editAutomator?.totalTime = showLength
                show.automator = editAutomator
                AutomatorWindowObject.spawnEditAutomatorWindow(show, status: showStatus.automatorStatus)
            }
        }
        }
        
    }
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        //Create the NSDates which contain the default values for the two NSDatePickers
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var startTimeComponents = DateComponents()
        startTimeComponents.hour = 8
        var endTimeComponents = DateComponents()
        endTimeComponents.hour = 10
        //Set the NSDatePickers to their default values
        startTime.dateValue = (calendar.date(from: startTimeComponents))!
        endTime.dateValue = (calendar.date(from: endTimeComponents))!
        //Make the NSDatePickers not placeholders 
        (startTime as! CustomDatePicker).disablePlaceholder()
        (endTime as! CustomDatePicker).disablePlaceholder()
        //Set the show name to its default value and make it selected (like the state it was in when the app launched)
        showName.stringValue = ""
        showName.selectText(self)
        //Set the NSPopUpButtons to their default values (Index at 0 should be Monday)
        startDay.selectItem(at: 0)
        endDay.selectItem(at: 0)
        //Set the isAutomated Button to its default value (off)
        isAutomated.state = 0
        //Stop the NSApp modal and dismiss the window
        showWindow.orderOut(self)
        NSApp.stopModal()

    }
 
    @IBAction func isAutomatorButton(_ sender: AnyObject) {
        isAutomated.allowsMixedState = false
    }
    
}
