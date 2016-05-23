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
}