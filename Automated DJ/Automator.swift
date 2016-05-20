//
//  Automator.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/11/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation

class Automator: NSObject {
    
    
    
  

    //Decode each individual object and then create a new object instance
    required convenience init?(coder decoder: NSCoder) {
        self.init()
    }
    //Encoding fucntion for saving. Encode each object with a key for retervial
    func encodeWithCoder(coder: NSCoder) {
       
    }
    
    func compare(anAutomator: Automator?) -> NSComparisonResult {
        if anAutomator == nil {
            return NSComparisonResult.OrderedDescending
        }
        else{
            return NSComparisonResult.OrderedSame
        }
}
    
}