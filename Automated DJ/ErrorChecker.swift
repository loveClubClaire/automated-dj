//
//  ErrorChecker.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/15/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class ErrorChecker: NSObject {
    //do playlists exist
    
    
    func checkShowValidity(aShow: Show, aShowStatus: ShowStatus, selectedShows: [Show]) -> Bool {
        
        var result = true
        var isOverTime = false
        var isSameDate = false
        var missingName = false
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let startDateComponents = calendar!.components([.Hour, .Minute, .Day], fromDate: aShow.startDate!)
        let endDateComponents = calendar!.components([.Hour,.Minute,.Day], fromDate: aShow.endDate!)
        
        if aShow.name == "" && selectedShows[0] == aShow{
           missingName = true
        }
        
       

        
        for aSelectedShow in selectedShows {
            let newStartComp = calendar!.components([.Hour, .Minute, .Day], fromDate: aSelectedShow.startDate!)
            let newEndComp = calendar!.components([.Hour,.Minute,.Day], fromDate: aSelectedShow.endDate!)
            if aShowStatus.startTime == true {startDateComponents.hour = newStartComp.hour; startDateComponents.minute = newStartComp.minute}
            if aShowStatus.startDay == true {startDateComponents.day = newStartComp.day}
            if aShowStatus.endTime == true {endDateComponents.hour = newEndComp.hour; endDateComponents.minute = newEndComp.minute}
            if aShowStatus.endDay == true {endDateComponents.day = newEndComp.day}
            
            var dayDifference = endDateComponents.day - startDateComponents.day
            
            if startDateComponents.day == 7 && endDateComponents.day == 1 {dayDifference = 1}
            
            if dayDifference > 1 {
                isOverTime = true
                break
            }
            
            let endTime = ((Double(endDateComponents.minute)  / 60.0) + Double(endDateComponents.hour))
            let startTime = ((Double(startDateComponents.minute) as Double / 60.0) + Double(startDateComponents.hour))
            let showLength = (endTime - startTime) + (Double(dayDifference) * 24.0)
            
            if showLength > 24.0 || showLength < 0{
               isOverTime = true
                break
            }
            
            if aShow.startDate == aShow.endDate {
                isSameDate = true
                break
            }
        }
        
        
        let myPopup: NSAlert = NSAlert()
        myPopup.alertStyle = NSAlertStyle.CriticalAlertStyle
        myPopup.addButtonWithTitle("OK")

        
        if isOverTime == true {
            result = false
            myPopup.messageText = "Shows can not be greater than 24 hours"
            myPopup.runModal()
        }
        if isSameDate == true {
            result = false
            myPopup.messageText = "Shows can not start and end at the same time"
            myPopup.runModal()
        }
        if missingName == true {
            result = false
            myPopup.messageText = "Shows must have a name"
            myPopup.runModal()
        }

        return result
    }
    
}