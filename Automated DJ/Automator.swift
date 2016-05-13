//
//  Automator.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/11/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation

class Automator: NSObject {
    
    
    
    
func compare(anAutomator: Automator?) -> NSComparisonResult {
    if anAutomator == nil {
        return NSComparisonResult.OrderedDescending
    }
    else{
        return NSComparisonResult.OrderedSame
    }
}
    
}