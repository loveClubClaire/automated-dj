//
//  ShowStatus.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/14/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class ShowStatus: NSObject {
    var automatorStatus = AutomatorStatus()
    //True is same false is different (True, has not changed, False, has changed)
    var name = true
    var startDay = true
    var startTime = true
    var endDay = true
    var endTime = true
    var automator = true
    
    func modifyShow(editedShow: Show, masterShow: Show) -> Show{
        //If the name has been changed, set the editedShows name to the name contained in the masterShow
        if name == false {
            editedShow.name = masterShow.name
        }
        //If the day changed, change the day. If the time changed, change the time. If they both changed, just set the editedShow date to the date provided by the masterShow
        if startDay == false && startTime == true {
            //Create a Gregorian calendar object and create NSDateComponents for the start and end time of the show which contain the hour and minute.
            let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
            let startDateComponents = calendar!.components([.Hour, .Minute], fromDate: editedShow.startDate!)
            //Get the day component from the masterShow
            let masterShowComponents = calendar!.components([.Day], fromDate: masterShow.startDate!)
            //Set the date to a day in the first week of June, 2015. This month and year were picked because June 1 is a Monday. The actual day isn't relevant, as long as the correct day of the week is preserved in the date.
            startDateComponents.year = 2015
            startDateComponents.month = 6
            //Set the day of the startDate to the day parsed from the masterShow
            startDateComponents.day = masterShowComponents.day
            //Set the new edited show start date to the result of the components
            editedShow.startDate = calendar?.dateFromComponents(startDateComponents)
        }
        if startTime == false && startDay == true {
            //Create a Gregorian calendar object and create NSDateComponents for the start and end time of the show which contain the hour and minute.
            let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
            let startTimeComponents = calendar!.components([.Day], fromDate: editedShow.startDate!)
            //Get the day component from the masterShow
            let masterShowComponents = calendar!.components([.Hour, .Minute], fromDate: masterShow.startDate!)
            //Set the date to a day in the first week of June, 2015. This month and year were picked because June 1 is a Monday. The actual day isn't relevant, as long as the correct day of the week is preserved in the date.
            startTimeComponents.year = 2015
            startTimeComponents.month = 6
            startTimeComponents.hour = masterShowComponents.hour
            startTimeComponents.minute = masterShowComponents.minute
            //Set the new edited show start date to the result of the components
            editedShow.startDate = calendar?.dateFromComponents(startTimeComponents)
        }
        if startTime == false && startDay == false {
            editedShow.startDate = masterShow.startDate
        }
        
        if endDay == false && endTime == true{
            //Create a Gregorian calendar object and create NSDateComponents for the start and end time of the show which contain the hour and minute.
            let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
            let endDateComponents = calendar!.components([.Hour, .Minute], fromDate: editedShow.endDate!)
            //Get the day component from the masterShow
            let masterShowComponents = calendar!.components([.Day], fromDate: masterShow.endDate!)
            //Set the date to a day in the first week of June, 2015. This month and year were picked because June 1 is a Monday. The actual day isn't relevant, as long as the correct day of the week is preserved in the date.
            endDateComponents.year = 2015
            endDateComponents.month = 6
            //Set the day of the startDate to the day parsed from the masterShow
            endDateComponents.day = masterShowComponents.day
            //Set the new edited show start date to the result of the components
            editedShow.endDate = calendar?.dateFromComponents(endDateComponents)
        }
        if endTime == false && endDay == true{
            //Create a Gregorian calendar object and create NSDateComponents for the start and end time of the show which contain the hour and minute.
            let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
            let endTimeComponents = calendar!.components([.Day], fromDate: editedShow.endDate!)
            //Get the day component from the masterShow
            let masterShowComponents = calendar!.components([.Hour, .Minute], fromDate: masterShow.endDate!)
            //Set the date to a day in the first week of June, 2015. This month and year were picked because June 1 is a Monday. The actual day isn't relevant, as long as the correct day of the week is preserved in the date.
            endTimeComponents.year = 2015
            endTimeComponents.month = 6
            endTimeComponents.hour = masterShowComponents.hour
            endTimeComponents.minute = masterShowComponents.minute
            //Set the new edited show start date to the result of the components
            editedShow.endDate = calendar?.dateFromComponents(endTimeComponents)
        }
        if endTime == false && endDay == false {
            editedShow.endDate = masterShow.endDate
        }
        //If the automator has been changed, get a new automator object with the approperate values and set it to the editedShow automator
        if automator == false {
            //Create a shallow copy of the editedShow's automator. This is done because shows can potenically share automator objects. If two shows share an automator object and a shallow copy is not made, when the automator object is modified the modifications effect both shows. Because they share an automator object. Creating a shallow copy which is not an identical object allows us to avoid this issue
            var editedShowAutomator: Automator?
            if editedShow.automator == nil {
                editedShowAutomator = nil
            }
            else{
                editedShowAutomator = Automator.init(aTotalTime: editedShow.automator!.totalTime, aTierOnePrecent: editedShow.automator!.tierOnePrecent, aTierTwoPrecent: editedShow.automator!.tierTwoPrecent, aTierThreePrecent: editedShow.automator!.tierThreePrecent, aSeedPlaylist: editedShow.automator!.seedPlayist, aBumpersPlaylist: editedShow.automator!.bumpersPlaylist, aBumpersPerBlock: editedShow.automator!.bumpersPerBlock, aSongBetweenBlocks: editedShow.automator!.songsBetweenBlocks, aRules: editedShow.automator!.rules)
            }
            
            if masterShow.automator != nil {
                if editedShowAutomator == nil {
                    editedShowAutomator = masterShow.automator
                }
                else{
                     editedShowAutomator = automatorStatus.modifyAutomator(editedShowAutomator!, masterAutomator: masterShow.automator!)
                }
            }
            else{
                editedShowAutomator = nil
            }
            //Set the automator of the edited show to the, now modified, shallow copy of its automator
            editedShow.automator = editedShowAutomator
        }
        
        return editedShow
    }
    
     override var description: String {
        let part = "Name:" + name.description
        let part1 =  " Start Day:" + startDay.description + " Start Time:" + startTime.description
        let part2 = " End Day:" + endDay.description + " End Time:" + endTime.description
        let part3 = " Automator:" + automator.description
        return part + part1 + part2 + part3
    }
}
