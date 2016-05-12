//
//  AppDelegate.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/11/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var ShowWindowObject: ShowWindow!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        //Populate the Show Window drop down menus with the days of the week
        let daysOfTheWeek = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
        ShowWindowObject.startDay.addItemsWithTitles(daysOfTheWeek)
        ShowWindowObject.endDay.addItemsWithTitles(daysOfTheWeek)
        
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

