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
    @IBOutlet weak var MasterScheduleObject: MasterSchedule!
    @IBOutlet weak var GlobalAnnouncementsObject: GloablAnnouncements!
    @IBOutlet weak var PreferencesObject: Preferences!

    @IBOutlet weak var RuleScrollViewObject: RuleScrollView!
    var storedProgramsFilepath = ""
    var storedAnnouncementsFilepath = ""
    var storedPreferencesFilepath = ""
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        //Inatalizes things in the masterScheduleObject related to its UI. Check this function for more information.
        MasterScheduleObject.viewDidLoad()
        
        //Intalized the ruleScrollView object. Check this function for more information
        RuleScrollViewObject.initalize()
        
        //Intalized the Preferences Object. Check this function for more information
        PreferencesObject.initialize()
        
        //Hides the gloablAnnouncementsToolbar and places its buttons on the same level as the quit button and title
        GlobalAnnouncementsObject.globalAnnouncementsWindow.titleVisibility = NSWindowTitleVisibility.Hidden
        
        //Populate the Show Window drop down menus with the days of the week
        let daysOfTheWeek = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
        ShowWindowObject.startDay.addItemsWithTitles(daysOfTheWeek)
        ShowWindowObject.endDay.addItemsWithTitles(daysOfTheWeek)

        //Get the filepaths of our applications stored data. 
        //We grab the URL for the application support folder and append the application name to the end of it, giving us the filepath where all data is stored. If the app has been run before, we should have a valid URL, if not, we create the directory so that the URL is valid. We then create constants with individual file names appended to the stored data directory. If a file does not exist, it will be created using that filepath.
        let applicationSupportFilepath = try! NSFileManager().URLForDirectory(NSSearchPathDirectory.ApplicationSupportDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false)
        let storedDataFilepath = applicationSupportFilepath.path! + "/Automated DJ"
        if(NSFileManager().fileExistsAtPath(storedDataFilepath) == false){
            try! NSFileManager().createDirectoryAtPath(storedDataFilepath, withIntermediateDirectories:false, attributes: nil)
        }
        storedProgramsFilepath = storedDataFilepath + "/MasterSchedule.txt"
        storedAnnouncementsFilepath = storedDataFilepath + "/GlobalAnnouncements.txt"
        storedPreferencesFilepath = storedDataFilepath + "/Preferences.txt"
        
        //Get the information stored in file at the storedProgramsFilepath. If its not empty (or non existant), set the data array to the reterived values and reload the tableview
        let shows = NSKeyedUnarchiver.unarchiveObjectWithFile(storedProgramsFilepath)
        if shows != nil {
            MasterScheduleObject.dataArray = shows as! [Show]
            MasterScheduleObject.tableView.reloadData()
        }
        
        //Get the information stored in file at the storedAnnouncementsFilepath. If its not empty (or non existant), set the global annoucements data array to the reterived values and reload the tableview
        let announcements = NSKeyedUnarchiver.unarchiveObjectWithFile(storedAnnouncementsFilepath)
        if announcements != nil {
            GlobalAnnouncementsObject.dataArray = announcements as! [String]
            GlobalAnnouncementsObject.tableView.reloadData()
        }
        
        //Get the information stored in file at the storedPreferencesFilePath. If it's not empty (or non existant), call Preferences' setValuesWith function and pass it the reterived array. Else, create a new array containing the default values and pass setValuesWith that new array
        let preferences = NSKeyedUnarchiver.unarchiveObjectWithFile(storedPreferencesFilepath)
        if preferences != nil {
            PreferencesObject.setValuesWith(preferences as! [AnyObject])
        }
        else{
            PreferencesObject.setValuesWith([Automator(),false,240,240,true])
        }
    
        
        PreferencesObject.spawnPreferencesWindow()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func application(sender: NSApplication, openFile filename: String) -> Bool {
        var result = false;
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = "All unsaved scheduler data will be lost"
        myPopup.informativeText = "Are you sure you want to continue?"
        myPopup.alertStyle = NSAlertStyle.CriticalAlertStyle
        myPopup.addButtonWithTitle("OK")
        myPopup.addButtonWithTitle("Cancel")
        let res = myPopup.runModal()
        if res == NSAlertFirstButtonReturn {
            MasterScheduleObject.dataArray = NSKeyedUnarchiver.unarchiveObjectWithFile(filename) as! [Show]
            result = NSKeyedArchiver.archiveRootObject(MasterScheduleObject.dataArray, toFile: storedProgramsFilepath)
            MasterScheduleObject.tableView.reloadData()
        }
        return result
    }
}

