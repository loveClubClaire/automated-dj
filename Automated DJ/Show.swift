//
//  Show.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/11/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Automator

class Show: NSObject{
    //Initial defination of object variables
    var name: String?
    var startDate: NSDate?
    var endDate: NSDate?
    var automator: Automator?
    
    init(aName: String, aStartDate: NSDate, anEndDate: NSDate) {
        name = aName
        startDate = aStartDate
        endDate = anEndDate
    }
    
    override var description: String {
        let timeFormatter = NSDateFormatter();timeFormatter.dateFormat = "hh:mm a"
        let dayFormatter = NSDateFormatter();dayFormatter.dateFormat = "EEEE"
        //Convert the shows dates into strings
        let startDay = dayFormatter.stringFromDate(startDate!);let startTime = timeFormatter.stringFromDate(startDate!)
        let endDay = dayFormatter.stringFromDate(endDate!);let endTime = timeFormatter.stringFromDate(endDate!)
        
        var automatorString = "No"
        if automator != nil {automatorString = "Yes"}
        
        return name! + " " + startDay + ", " + startTime + " - " + endDay + ", " + endTime + " Automator:" + automatorString
    }
}
