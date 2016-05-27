//
//  AutomateShowCommand.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/20/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class AutomateShowCommand: NSScriptCommand {
    
    
    override func performDefaultImplementation() -> AnyObject? {
        var result = false
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        let dataArray = (appDelegate.MasterScheduleObject.dataArray) as NSArray
        let showName = self.evaluatedArguments!["ShowName"] as! String
        let show = Show.init(aName: showName, aStartDate: NSDate.init(), anEndDate: NSDate.init())
        let indexOfShow = dataArray.indexOfObject(show)
        
        if indexOfShow != NSNotFound {
            (dataArray[indexOfShow] as! Show).automator = appDelegate.PreferencesObject.defaultAutomator
            appDelegate.MasterScheduleObject.tableView.reloadData()
            result = true
        }
        else{
            self.scriptErrorNumber = -50
            self.scriptErrorString = "Show does not exist"
        }
        return result
    }
}