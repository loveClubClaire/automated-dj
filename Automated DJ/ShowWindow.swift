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
    

    func spawnNewShowWindow(){
        showWindow.title = "New Show"
        showWindow.center()
        showWindow.makeKeyAndOrderFront(self)
        NSApp.runModalForWindow(showWindow)
    }
    
    //Will need to take parameters. The values of the show being edited
    func spawnEditShowWindow(){
        showWindow.title = "Edit Show"
        //Set the values passed to their respective objects
        showWindow.center()
        showWindow.makeKeyAndOrderFront(self)
        NSApp.runModalForWindow(showWindow)
    }
    
    @IBAction func okButton(sender: AnyObject) {
    }
    
    
    @IBAction func cancelButton(sender: AnyObject) {
    }
 
    
}