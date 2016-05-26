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
    
    static func doTieredPlaylistsExist() -> (tier1Exist: Bool, tier2Exist: Bool, tier3Exist: Bool){
        var tierOneExist = true
        var tierTwoExist = true
        var tierThreeExist = true
        let playlists = ApplescriptBridge().getPlaylists()
        let playlistNames = Playlist.getPlaylistNames(true,aPlaylistArray: playlists as NSArray as! [Playlist])
        if playlistNames.contains("Tier 1") == false {
            tierOneExist = false
        }
        if playlistNames.contains("Tier 2") == false {
            tierTwoExist = false
        }
        if playlistNames.contains("Tier 3") == false {
            tierThreeExist = false
        }
        return (tierOneExist,tierTwoExist,tierThreeExist)
    }
    
    static func checkAutomatorValidity(inout isValid: NSMutableDictionary, anAutomator: Automator, anAutomatorStatus: AutomatorStatus, selectedShows: [Show], dispatchGroup: dispatch_group_t) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT

        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let applescriptBridge = ApplescriptBridge()
            let masterTier1Songs = applescriptBridge.getSongsInPlaylist("Tier 1")
            let masterTier2Songs = applescriptBridge.getSongsInPlaylist("Tier 2")
            let masterTier3Songs = applescriptBridge.getSongsInPlaylist("Tier 3")
            
            var is100Precent = true
            var isTier1LongEnough = true
            var isTier2LongEnough = true
            var isTier3LongEnough = true
            

            for aSelectedShow in selectedShows {
                var tier1 = anAutomator.tierOnePrecent
                var tier2 = anAutomator.tierTwoPrecent
                var tier3 = anAutomator.tierThreePrecent
                let tier1Songs = NSMutableArray.init(array: masterTier1Songs)
                let tier2Songs = NSMutableArray.init(array: masterTier2Songs)
                let tier3Songs = NSMutableArray.init(array: masterTier3Songs)
                
                
                if anAutomatorStatus.tierOnePrecent == true {tier1 = (aSelectedShow.automator?.tierOnePrecent)!}
                if anAutomatorStatus.tierTwoPrecent == true {tier2 = (aSelectedShow.automator?.tierTwoPrecent)!}
                if anAutomatorStatus.tierThreePrecent == true {tier3 = (aSelectedShow.automator?.tierThreePrecent)!}
                
                if (tier1 + tier2 + tier3) != 100 {
                    is100Precent = false
                    break
                }
                
                var rules = anAutomator.rules
                
                if anAutomatorStatus.rules == true {
                    rules = aSelectedShow.automator?.rules
                }
                
                if rules != nil {
                    tier1Songs.filterUsingPredicate(rules!)
                    tier2Songs.filterUsingPredicate(rules!)
                    tier3Songs.filterUsingPredicate(rules!)
                }
                
                var totalTime = anAutomator.totalTime
                if anAutomatorStatus.totalTime == true {totalTime = (aSelectedShow.automator?.totalTime)!}
                
                if (((totalTime * 3600) * (Double(tier1) / 100.0) * 1.15) > Playlist.getNewPlaylistDuration(tier1Songs as NSArray as! [Song])) {
                    isTier1LongEnough = false
                    break
                }
                if (((totalTime * 3600) * (Double(tier2) / 100.0) * 1.15) > Playlist.getNewPlaylistDuration(tier2Songs as NSArray as! [Song])) {
                    isTier2LongEnough = false
                    break
                }
                if (((totalTime * 3600) * (Double(tier3) / 100.0) * 1.15) > Playlist.getNewPlaylistDuration(tier3Songs as NSArray as! [Song])) {
                    isTier3LongEnough = false
                    break
                }
                
            }
        
        dispatch_async(dispatch_get_main_queue()) {
            let myPopup: NSAlert = NSAlert()
            myPopup.alertStyle = NSAlertStyle.CriticalAlertStyle
            myPopup.addButtonWithTitle("OK")
            
            if is100Precent == false {
                isValid.setValue(false, forKey: "isValid")
                myPopup.messageText = "Tiered precentages must add up to 100!"
                myPopup.runModal()
            }
            if isTier1LongEnough == false {
                isValid.setValue(false, forKey: "isValid")
                myPopup.messageText = "Tier 1 is not long enough!"
                myPopup.runModal()
            }
            if isTier2LongEnough == false {
                isValid.setValue(false, forKey: "isValid")
                myPopup.messageText = "Tier 2 is not long enough!"
                myPopup.runModal()
            }
            if isTier3LongEnough == false {
                isValid.setValue(false, forKey: "isValid")
                myPopup.messageText = "Tier 3 is not long enough!"
                myPopup.runModal()
            }
            dispatch_group_leave(dispatchGroup)
        }
        }
    }
    
    static func checkShowValidity(aShow: Show, aShowStatus: ShowStatus, selectedShows: [Show]) -> Bool {
        
        var result = true
        var isOverTime = false
        var isSameDate = false
        var missingName = false
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)

        
        if aShow.name == "" && selectedShows[0] == aShow{
           missingName = true
        }
        
        for aSelectedShow in selectedShows {
            let startDateComponents = calendar!.components([.Hour, .Minute, .Day], fromDate: aShow.startDate!)
            let endDateComponents = calendar!.components([.Hour,.Minute,.Day], fromDate: aShow.endDate!)
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