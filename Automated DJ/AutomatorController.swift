//
//  AutomatorController.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 6/5/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class AutomatorController: NSObject {
    
    
    func spawnMasterTimer(){
        NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(masterTimerFunction), userInfo: nil, repeats: true)
    }
    
    func masterTimerFunction(){
        //Create a date object 3 minutes in the future
        let futureTime = NSDate.init().dateByAddingTimeInterval(180)
        //Create date formatter, which represents a date as a weekday and the hour and minute 
        let dateFormatterShowTime = NSDateFormatter()
        dateFormatterShowTime.dateFormat = "EEEE 'at' HH:mm"

        print(dateFormatterShowTime.stringFromDate(futureTime))
        
        

        
    }
    
}