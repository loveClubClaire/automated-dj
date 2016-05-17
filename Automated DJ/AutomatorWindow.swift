//
//  AutomatorWindow.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/11/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class AutomatorWindow: NSObject {
    
    @IBOutlet weak var automatorWindow: NSWindow!
    
    func changeWindowSizeBy(aHeight: CGFloat){
        var windowFrame = automatorWindow.frame
        windowFrame.size.height = 420 + aHeight
        
        //If true, window is shrinking
        if (automatorWindow.frame.size.height - windowFrame.size.height) > 0 {
            windowFrame.origin.y = windowFrame.origin.y + 25
        }
       

        //If true, window is growing
        if (automatorWindow.frame.size.height - windowFrame.size.height) < 0 {
            windowFrame.origin.y = windowFrame.origin.y - 25
        }
 
        

        automatorWindow.setFrame(windowFrame, display: true, animate: true)
    }
    
}
