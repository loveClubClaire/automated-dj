//
//  AutomateShowCommand.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/20/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class AutomateShowCommand: NSScriptCommand {
    
    
    override func performDefaultImplementation() -> Any? {
        var result = false
        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        let dataArray = (appDelegate.MasterScheduleObject.dataArray) as NSArray
        let showName = self.evaluatedArguments!["ShowName"] as! String
        let show = Show.init(aName: showName, aStartDate: Date.init(), anEndDate: Date.init())
        let indexOfShow = dataArray.index(of: show)
        
        if indexOfShow != NSNotFound {
            (dataArray[indexOfShow] as! Show).automator = appDelegate.PreferencesObject.defaultAutomator
            appDelegate.MasterScheduleObject.tableView.reloadData()
            result = true
            
            //Get time between now and the end date of the next show
            //Get the weekdays of the current date and the showEndDate 
            let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
            let currentDateComponents = (calendar as NSCalendar).components([.weekday, .hour, .minute], from: Date.init())
            let endDateCompoents = (calendar as NSCalendar).components([.weekday, .hour, .minute], from: (dataArray[indexOfShow] as! Show).endDate!)
            let currentWeekday = currentDateComponents.weekday
            let endWeekday = endDateCompoents.weekday
            //Get the difference of endWeekday and currentWeekday. This difference gives us the number of days until the end date. If the difference is zero, we check to see if the date is later in the day. If its not later that day, we state that the end date is seven days away.
            var dayDifference =  endWeekday! - currentWeekday!
            if dayDifference < 0 {dayDifference = dayDifference + 7}
            else if dayDifference == 0{
                if ((currentDateComponents.hour! * 60) + currentDateComponents.minute!) > ((endDateCompoents.hour! * 60) + endDateCompoents.minute!) {
                    dayDifference = 7
                }
            }
            //Create a new date from getting the current date and adding the number of days away the end date occures. Then add the hour and minute from the end date. We create a new date from those components. This is done because the default end date only requires the weekday, hour, and minute to be correct. Doing this creates a date which has the correct day, month, and year along with hour and minute.
            var newEndDate = Date.init().addingTimeInterval(86400.0 * Double(dayDifference))
            var newEndDateComponents = (calendar as NSCalendar).components([.day, .month, .year, .timeZone], from: newEndDate)
            newEndDateComponents.hour = endDateCompoents.hour
            newEndDateComponents.minute = endDateCompoents.minute
            newEndDate = calendar.date(from: newEndDateComponents)!
            //Dispatch code to unautomate the show to execute when the show ends.
            let delayTime = DispatchTime.now() + Double(Int64(newEndDate.timeIntervalSinceNow * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.global(qos: .background).asyncAfter(deadline: delayTime) {
                (dataArray[indexOfShow] as! Show).automator = nil
                appDelegate.MasterScheduleObject.tableView.reloadData()
            }
        }
        else{
            //Setting these values forces (or emulates not 100% sure) the function returning an error
            self.scriptErrorNumber = -50
            self.scriptErrorString = "Show does not exist"
        }
        return result
    }
}
