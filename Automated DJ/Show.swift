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
        return name!
    }
}
