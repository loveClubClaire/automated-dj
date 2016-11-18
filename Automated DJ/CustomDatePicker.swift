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
        self.textColor = NSColor.white
    }
    
    func disablePlaceholder(){
        self.textColor = NSColor.textColor
    }
    
    func isPlaceholder() -> Bool{
        if self.textColor == NSColor.textColor {
            return false
        }
        else{
            return true
        }
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        if self.textColor == NSColor.white {
            self.textColor = NSColor.textColor
        }
        super.mouseDown(with: theEvent)
    }
    
    override func keyUp(with theEvent: NSEvent) {
        if self.textColor == NSColor.white {
            self.textColor = NSColor.textColor
        }
        super.keyUp(with: theEvent)
    }
 
    
}
