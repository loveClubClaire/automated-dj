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
    //True is same false is different
    var name = true
    var startDay = true
    var startTime = true
    var endDay = true
    var endTime = true
    var automator = true
    
    
     override var description: String {
        let part = "Name:" + name.description
        let part1 =  " Start Day:" + startDay.description + " Start Time:" + startTime.description
        let part2 = " End Day:" + endDay.description + " End Time:" + endTime.description
        let part3 = " Automator:" + automator.description
        return part + part1 + part2 + part3
    }
}
