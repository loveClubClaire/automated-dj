//
//  AutomatorStatus.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/22/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class AutomatorStatus: NSObject {
    //True is same false is different (True, has not changed, False, has changed)
    var totalTime = true
    var tierOnePrecent = true
    var tierTwoPrecent = true
    var tierThreePrecent = true
    var seedPlayist = true
    var bumpersPlaylist = true
    var bumpersPerBlock = true
    var songsBetweenBlocks = true
    var rules = true
    //True means on or off state, false means mixed state
    var rulesState = true
    var bumpersState = true
    var seedState = true
    
    func modifyAutomator(editedAutomator: Automator, masterAutomator: Automator) -> Automator{
        //If the tierOnePrecent has been changed, set the editedAutomator name to the tierOnePrecent contained in the masterAutomator
        if tierOnePrecent == false {
            editedAutomator.tierOnePrecent = masterAutomator.tierOnePrecent
        }
        if tierTwoPrecent == false {
            editedAutomator.tierTwoPrecent = masterAutomator.tierTwoPrecent
        }
        if tierThreePrecent == false {
            editedAutomator.tierThreePrecent = masterAutomator.tierThreePrecent
        }
        if seedPlayist == false {
            editedAutomator.seedPlayist = masterAutomator.seedPlayist
        }
        if bumpersPlaylist == false {
            editedAutomator.bumpersPlaylist = masterAutomator.bumpersPlaylist
        }
        if bumpersPerBlock == false {
            editedAutomator.bumpersPerBlock = masterAutomator.bumpersPerBlock
        }
        if songsBetweenBlocks == false {
            editedAutomator.songsBetweenBlocks = masterAutomator.songsBetweenBlocks
        }
        if rules == false {
            editedAutomator.rules = masterAutomator.rules
        }
        return editedAutomator
    }
    
}