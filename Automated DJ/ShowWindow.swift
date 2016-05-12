//
//  ShowWindow.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/11/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class ShowWindow: NSObject {
    @IBOutlet weak var showWindow: NSWindow!
    @IBOutlet weak var showName: NSTextField!
    @IBOutlet weak var startTime: NSDatePicker!
    @IBOutlet weak var endTime: NSDatePicker!
    @IBOutlet weak var isAutomated: NSButton!
    

    func spawnShowWindow(){
        
    }
    
    @IBAction func okButton(sender: AnyObject) {
    }
    
    
    @IBAction func cancelButton(sender: AnyObject) {
    }
 
    
}