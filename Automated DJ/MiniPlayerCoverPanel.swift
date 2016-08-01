//
//  MiniPlayerCoverWindow.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 6/29/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class MiniPlayerCoverPanel: NSPanel {
    override func orderOut(sender: AnyObject?) {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.deactivateMiniPlayerCover()
        super.orderOut(sender)
    }
}