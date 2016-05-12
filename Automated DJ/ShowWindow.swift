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
    @IBOutlet weak var startDay: NSPopUpButton!
    @IBOutlet weak var endDay: NSPopUpButton!
    

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
        //Create the NSDates which contain the default values for the two NSDatePickers
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let startTimeComponents = NSDateComponents()
        startTimeComponents.hour = 8
        let endTimeComponents = NSDateComponents()
        endTimeComponents.hour = 10
        //Set the NSDatePickers to their default values
        startTime.dateValue = (calendar?.dateFromComponents(startTimeComponents))!
        endTime.dateValue = (calendar?.dateFromComponents(endTimeComponents))!
        //Set the show name to its default value
        showName.stringValue = ""
        //Set the NSPopUpButtons to their default values (Index at 0 should be Monday)
        startDay.selectItemAtIndex(0)
        endDay.selectItemAtIndex(0)
        //Set the isAutomated Button to its default value (off)
        isAutomated.state = 0
        //Stop the NSApp modal and dismiss the window
        NSApp.stopModal()
        showWindow.orderOut(self)
    }
 
    
}