//
//  CustomDatePicker.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/14/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa
//Class allows for a placeholder value in NSDatePicker. Its not really a value, it just turns the text white but the user just sees an empty NSDatePicker. MouseDown and keyUp are overridden so that when the user clicks on the NSDatePicker it is no longer "empty" and the text color changes back to black
class CustomDatePicker: NSDatePicker {

    func makePlaceholder(){
        self.textColor = NSColor.whiteColor()
    }
    
    func disablePlaceholder(){
        self.textColor = NSColor.blackColor()
    }
    
    func isPlaceholder() -> Bool{
        if self.textColor == NSColor.blackColor() {
            return false
        }
        else{
            return true
        }
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