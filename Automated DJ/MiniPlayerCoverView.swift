//
//  MiniPlayerCoverPanel.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 6/28/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class MiniPlayerCoverView: NSView {
    
    override func mouseEntered(theEvent: NSEvent) {
        Swift.print("Object has entered")
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.MiniPlayerCoverObject.showButton()
        super.mouseEntered(theEvent)
    }
    override func mouseExited(theEvent: NSEvent) {
        Swift.print("Obejct has left")
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.MiniPlayerCoverObject.hideButton()
        super.mouseExited(theEvent)
    }
    func addTrackingArea() {
        self.addTrackingArea(NSTrackingArea.init(rect: self.bounds, options:[NSTrackingAreaOptions.ActiveAlways,NSTrackingAreaOptions.MouseEnteredAndExited], owner: self, userInfo: nil))
    }
}