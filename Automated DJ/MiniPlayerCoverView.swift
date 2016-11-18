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
    override func mouseEntered(with theEvent: NSEvent) {
        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        appDelegate.MiniPlayerCoverObject.showButton()
        super.mouseEntered(with: theEvent)
    }
    override func mouseExited(with theEvent: NSEvent) {
        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        appDelegate.MiniPlayerCoverObject.hideButton()
        super.mouseExited(with: theEvent)
    }
    func addTrackingArea() {
        self.addTrackingArea(NSTrackingArea.init(rect: self.bounds, options:[NSTrackingAreaOptions.activeAlways,NSTrackingAreaOptions.mouseEnteredAndExited], owner: self, userInfo: nil))
    }
}
