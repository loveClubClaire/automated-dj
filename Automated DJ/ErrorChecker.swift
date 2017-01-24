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
    
    //Only checks if the tiered playlists sum to 100%
    static func simpleAutomatorValidityCheck(anAutomator: Automator, anAutomatorStatus: AutomatorStatus, selectedShows: [Show], isValid:@escaping (Bool) -> Void){
        var is100Precent = true
        
        for aSelectedShow in selectedShows {
        var tier1 = anAutomator.tierOnePrecent
        var tier2 = anAutomator.tierTwoPrecent
        var tier3 = anAutomator.tierThreePrecent
        if anAutomatorStatus.tierOnePrecent == true {tier1 = (aSelectedShow.automator?.tierOnePrecent)!}
        if anAutomatorStatus.tierTwoPrecent == true {tier2 = (aSelectedShow.automator?.tierTwoPrecent)!}
        if anAutomatorStatus.tierThreePrecent == true {tier3 = (aSelectedShow.automator?.tierThreePrecent)!}
            if (tier1 + tier2 + tier3) != 100 {
                is100Precent = false
                break
            }
        }
        let myPopup: NSAlert = NSAlert()
        myPopup.alertStyle = NSAlertStyle.critical
        myPopup.addButton(withTitle: "OK")
        isValid(true)
        if is100Precent == false {
            isValid(false)
            myPopup.messageText = "Tiered precentages must add up to 100!"
            myPopup.runModal()
        }
    }
    
    static func checkAutomatorValidity(isValid: @escaping (Bool) -> Void, anAutomator: Automator, anAutomatorStatus: AutomatorStatus, selectedShows: [Show], dispatchGroup: DispatchGroup) {
        DispatchQueue.global(qos: .background).async {
            let appDelegate = NSApplication.shared().delegate as! AppDelegate
            let isCacheFull = appDelegate.updateCachedPlaylists()
            if(isCacheFull == true){
                let masterTier1Songs = NSMutableArray(); masterTier1Songs.addObjects(from: appDelegate.cachedTier1Playlist as [AnyObject])
                let masterTier2Songs = NSMutableArray(); masterTier2Songs.addObjects(from: appDelegate.cachedTier2Playlist as [AnyObject])
                let masterTier3Songs = NSMutableArray(); masterTier3Songs.addObjects(from: appDelegate.cachedTier3Playlist as [AnyObject])
                
                var is100Precent = true
                var validBumpers = true
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
                    
                    
                    if anAutomatorStatus.tierOnePrecent == true {tier1 = (aSelectedShow.automator?.tierOnePrecent) ?? 0}
                    if anAutomatorStatus.tierTwoPrecent == true {tier2 = (aSelectedShow.automator?.tierTwoPrecent) ?? 0}
                    if anAutomatorStatus.tierThreePrecent == true {tier3 = (aSelectedShow.automator?.tierThreePrecent) ?? 0}
                    
                    if (tier1 + tier2 + tier3) != 100 {
                        is100Precent = false
                        break
                    }
                    
                    if anAutomator.bumpersPlaylist != nil{
                        if anAutomator.bumpersPerBlock == 0 || anAutomator.songsBetweenBlocks == 0{
                            validBumpers = false
                        }
                    }
       
                    var rules = anAutomator.rules
                    
                    if anAutomatorStatus.rules == true {
                        rules = aSelectedShow.automator?.rules
                    }
                    
                    if rules != nil {
                        tier1Songs.filter(using: rules!)
                        tier2Songs.filter(using: rules!)
                        tier3Songs.filter(using: rules!)
                    }
                    
                    var totalTime = anAutomator.totalTime
                    if anAutomatorStatus.totalTime == true && aSelectedShow.automator != nil {totalTime = (aSelectedShow.automator?.totalTime)!}
                    
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
            
            DispatchQueue.main.async {
                let myPopup: NSAlert = NSAlert()
                myPopup.alertStyle = NSAlertStyle.critical
                myPopup.addButton(withTitle: "OK")
                isValid(true)
                    
                if is100Precent == false {
                    isValid(false)
                    myPopup.messageText = "Tiered precentages must add up to 100!"
                    myPopup.runModal()
                }
                if validBumpers == false{
                    isValid(false)
                    myPopup.messageText = "Bumpers Per Block and Songs Between Blocks must be greater than zero"
                    myPopup.runModal()
                }
                if isTier1LongEnough == false {
                    isValid(false)
                    myPopup.messageText = "Tier 1 is not long enough!"
                    myPopup.runModal()
                }
                if isTier2LongEnough == false {
                    isValid(false)
                    myPopup.messageText = "Tier 2 is not long enough!"
                    myPopup.runModal()
                }
                if isTier3LongEnough == false {
                   isValid(false)
                    myPopup.messageText = "Tier 3 is not long enough!"
                    myPopup.runModal()
                }
            }
                
                
                
            }
            dispatchGroup.leave()
        }
    }
    
    static func checkShowValidity(_ aShow: Show, aShowStatus: ShowStatus, selectedShows: [Show]) -> Bool {
        //TODO prevent shows from having the same name as other shows (Make show names unique)
        var result = true
        var isOverTime = false
        var isSameDate = false
        var missingName = false
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)

        
        if aShow.name == "" && selectedShows[0] == aShow{
           missingName = true
        }
        
        for aSelectedShow in selectedShows {
            var startDateComponents = (calendar as NSCalendar).components([.hour, .minute, .day], from: aShow.startDate! as Date)
            var endDateComponents = (calendar as NSCalendar).components([.hour,.minute,.day], from: aShow.endDate! as Date)
            let newStartComp = (calendar as NSCalendar).components([.hour, .minute, .day], from: aSelectedShow.startDate! as Date)
            let newEndComp = (calendar as NSCalendar).components([.hour,.minute,.day], from: aSelectedShow.endDate! as Date)
            if aShowStatus.startTime == true {startDateComponents.hour = newStartComp.hour; startDateComponents.minute = newStartComp.minute}
            if aShowStatus.startDay == true {startDateComponents.day = newStartComp.day}
            if aShowStatus.endTime == true {endDateComponents.hour = newEndComp.hour; endDateComponents.minute = newEndComp.minute}
            if aShowStatus.endDay == true {endDateComponents.day = newEndComp.day}
            
            var dayDifference = endDateComponents.day! - startDateComponents.day!
            
            if startDateComponents.day == 7 && endDateComponents.day == 1 {dayDifference = 1}
            
            if dayDifference > 1 {
                isOverTime = true
                break
            }
            
            let endTime = ((Double(endDateComponents.minute!)  / 60.0) + Double(endDateComponents.hour!))
            let startTime = ((Double(startDateComponents.minute!) as Double / 60.0) + Double(startDateComponents.hour!))
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
        myPopup.alertStyle = NSAlertStyle.critical
        myPopup.addButton(withTitle: "OK")

        
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
