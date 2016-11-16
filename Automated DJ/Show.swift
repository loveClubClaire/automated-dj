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
    var startDate: Date?
    var endDate: Date?
    var automator: Automator?
    
    init(aName: String, aStartDate: Date, anEndDate: Date) {
        name = aName
        startDate = aStartDate
        endDate = anEndDate
    }
    
    //Decode each individual object and then create a new object instance
    required convenience init?(coder decoder: NSCoder) {
        guard let name = decoder.decodeObject(forKey: "name") as? String,
            let startDate = decoder.decodeObject(forKey: "startDate") as? Date,
            let endDate = decoder.decodeObject(forKey: "endDate") as? Date,
            let automator = decoder.decodeObject(forKey: "automator") as? Automator?
            else { return nil }
        
        self.init(aName: name, aStartDate: startDate, anEndDate: endDate)
        self.automator = automator
    }
    //Encoding fucntion for saving. Encode each object with a key for retervial
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(startDate, forKey: "startDate")
        coder.encode(endDate, forKey: "endDate")
        coder.encode(automator, forKey: "automator")
    }
    
    //If two shows have the same name they are equal 
    override func isEqual(_ object: Any?) -> Bool {
        var result = false
        if (object! as AnyObject).isKind(of: Show.self) {
            if (object as! Show).name == name {
                result = true
            }
        }
        return result
    }
    
    override var description: String {
        let timeFormatter = DateFormatter();timeFormatter.dateFormat = "hh:mm a"
        let dayFormatter = DateFormatter();dayFormatter.dateFormat = "EEEE"
        //Convert the shows dates into strings
        let startDay = dayFormatter.string(from: startDate!);let startTime = timeFormatter.string(from: startDate!)
        let endDay = dayFormatter.string(from: endDate!);let endTime = timeFormatter.string(from: endDate!)
        
        var automatorString = "No"
        if automator != nil {automatorString = "Yes"}
        
        return name! + " " + startDay + ", " + startTime + " - " + endDay + ", " + endTime + " Automator:" + automatorString
    }
}
