//
//  Show.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/11/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Automator

class Show: NSObject, NSCoding{
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
    
    //Decode each individual object and then create a new object instance
    required convenience init?(coder decoder: NSCoder) {
        guard let name = decoder.decodeObjectForKey("name") as? String,
            let startDate = decoder.decodeObjectForKey("startDate") as? NSDate,
            let endDate = decoder.decodeObjectForKey("endDate") as? NSDate,
            let automator = decoder.decodeObjectForKey("automator") as? Automator?
            else { return nil }
        
        self.init(aName: name, aStartDate: startDate, anEndDate: endDate)
        self.automator = automator
    }
    //Encoding fucntion for saving. Encode each object with a key for retervial
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(name, forKey: "name")
        coder.encodeObject(startDate, forKey: "startDate")
        coder.encodeObject(endDate, forKey: "endDate")
        coder.encodeObject(automator, forKey: "automator")
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
