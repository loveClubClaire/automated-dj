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
    override func orderOut(_ sender: Any?) {
        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        appDelegate.deactivateMiniPlayerCover()
        super.orderOut(sender)
    }
}
