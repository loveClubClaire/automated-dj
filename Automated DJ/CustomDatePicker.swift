//
//  CustomDatePicker.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/14/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class CustomDatePicker: NSDatePicker {

    func makePlaceholder(){
        self.textColor = NSColor.whiteColor()
    }
    
    override func mouseDown(theEvent: NSEvent) {
        if self.textColor == NSColor.whiteColor() {
            self.textColor = NSColor.blackColor()
        }
        super.mouseDown(theEvent)
    }
    
    override func keyUp(theEvent: NSEvent) {
        if self.textColor == NSColor.whiteColor() {
            self.textColor = NSColor.blackColor()
        }
        super.keyUp(theEvent)
    }
 
    
}