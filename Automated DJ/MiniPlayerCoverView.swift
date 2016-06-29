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
        super.mouseEntered(theEvent)
    }
    override func mouseExited(theEvent: NSEvent) {
        Swift.print("Obejct has left")
        super.mouseExited(theEvent)
    }
    override func mouseMoved(theEvent: NSEvent) {
        Swift.print("Object has moved")
        super.mouseMoved(theEvent)
    }
    override func mouseDown(theEvent: NSEvent) {
        Swift.print("Object has pressed")
        self.addTrackingArea(NSTrackingArea.init(rect: self.bounds, options:[NSTrackingAreaOptions.ActiveAlways,NSTrackingAreaOptions.MouseEnteredAndExited], owner: self, userInfo: nil))
        super.mouseDown(theEvent)
    }
}