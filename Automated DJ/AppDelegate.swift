//
//  AppDelegate.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/11/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Cocoa
import AppleScriptObjC

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var ShowWindowObject: ShowWindow!
    @IBOutlet weak var MasterScheduleObject: MasterSchedule!
    @IBOutlet weak var GlobalAnnouncementsObject: GloablAnnouncements!
    @IBOutlet weak var PreferencesObject: Preferences!
    @IBOutlet weak var RuleScrollViewObject: RuleScrollView!
    @IBOutlet weak var AdminAccessObject: AdminAccess!
    @IBOutlet weak var AutomatorWindowObject: AutomatorWindow!
    @IBOutlet weak var AutomatorControllerObject: AutomatorController!
    @IBOutlet weak var MiniPlayerCoverObject: MiniPlayerCover!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)
    let myApplication = NSApplication.sharedApplication()
    
    var storedProgramsFilepath = ""
    var storedAnnouncementsFilepath = ""
    var storedPreferencesFilepath = ""
    
    var cachedFilled = false
    var cachedTier1Playlist = NSMutableArray()
    var cachedTier2Playlist = NSMutableArray()
    var cachedTier3Playlist = NSMutableArray()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        //Required for the scripting bridge to function
        NSBundle.mainBundle().loadAppleScriptObjectiveCScripts()
        
        //Check to see if tiered playlists have been created and if not, create them 
        let areTieredPlaylistsCreated = ErrorChecker.doTieredPlaylistsExist()
        if areTieredPlaylistsCreated.tier1Exist == false {ApplescriptBridge().createPlaylistWithName("Tier 1")}
        if areTieredPlaylistsCreated.tier2Exist == false {ApplescriptBridge().createPlaylistWithName("Tier 2")}
        if areTieredPlaylistsCreated.tier3Exist == false {ApplescriptBridge().createPlaylistWithName("Tier 3")}
        
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

        //Configure the number formatter for the automator window so we can have trailing zeros and doubles which are not too large
        (AutomatorWindowObject.timeTextField.formatter as! NSNumberFormatter).minimumFractionDigits = 2
        (AutomatorWindowObject.timeTextField.formatter as! NSNumberFormatter).maximumFractionDigits = 2
        
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
            //Get the filepath to he desktop so the default log filepath can be set to the desktop
            let fileManager = NSFileManager()
            let desktopFilepathURL = try? fileManager.URLForDirectory(NSSearchPathDirectory.DesktopDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create:false)
            PreferencesObject.setValuesWith([Automator.init(aTotalTime: 2.0, aTierOnePrecent: 15, aTierTwoPrecent: 25, aTierThreePrecent: 60),false,240,50,true,false,(desktopFilepathURL?.path)!])
        }
        //Inatalize the timer
        AutomatorControllerObject.spawnMasterTimer()
        
        //Inatalize the menu bar. Then create NSMenuItems and add them to the menu bar. Then set the menu bar to be our applications menu bar. NSMenuItems which are not separators are given a name an a selector which corresponds to a function related to the name.
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Show Schedule", action: #selector(showSchedule), keyEquivalent: "S"))
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Show Announcements", action: #selector(showAnnouncements), keyEquivalent: "A"))
        menu.addItem(NSMenuItem(title: "Edit Announcements", action: #selector(editAnnouncements), keyEquivalent: "E"))
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Activate MiniPlayer Cover", action: #selector(activateMiniPlayerCover), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Hide MiniPlayer Cover", action: #selector(showMiniPlayerCover), keyEquivalent: ""))
            menu.itemAtIndex(6)?.hidden = true
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Preferences", action: #selector(showPreferences), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(terminate), keyEquivalent: "q"))
        statusItem.menu = menu
        statusItem.button?.image = NSImage.init(named:"On Air.png")
        
        //Populate the tiered playlists caches. Can take an extended period of time so an async task is spawned
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let applescriptBridge = ApplescriptBridge()
            autoreleasepool{
                self.cachedTier1Playlist = applescriptBridge.getSongsInPlaylist("Tier 1")
                self.cachedTier2Playlist = applescriptBridge.getSongsInPlaylist("Tier 2")
                self.cachedTier3Playlist = applescriptBridge.getSongsInPlaylist("Tier 3")
            }
            self.cachedFilled = true
        }
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
    
    func updateCachedPlaylists() -> Bool {
        //If the cache has not yet been filled, then it can not be updated and this function returns false
        if cachedFilled == false {
            return false
        }
        else{
            //Get sets of persistantID's of the three cached tiered playlists and the current tiered playlists in iTunes
            let applescriptBridge = ApplescriptBridge()
            let cachedTier1Set = Song.idSetFrom(cachedTier1Playlist as NSArray as! [Song])
            let cachedTier2Set = Song.idSetFrom(cachedTier2Playlist as NSArray as! [Song])
            let cachedTier3Set = Song.idSetFrom(cachedTier3Playlist as NSArray as! [Song])
            let newTier1Set = Set(applescriptBridge.getPersistentIDsOfSongsInPlaylist("Tier 1"))
            let newTier2Set = Set(applescriptBridge.getPersistentIDsOfSongsInPlaylist("Tier 2"))
            let newTier3Set = Set(applescriptBridge.getPersistentIDsOfSongsInPlaylist("Tier 3"))
            //Get all persistant ID's to be added to the tiered playlists
            let tier1Add = newTier1Set.subtract(cachedTier1Set)
            let tier2Add = newTier2Set.subtract(cachedTier2Set)
            let tier3Add = newTier3Set.subtract(cachedTier3Set)
            //Get all persistant ID's to be removed from the tiered playlists
            let tier1Remove = cachedTier1Set.subtract(newTier1Set)
            let tier2Remove = cachedTier2Set.subtract(newTier2Set)
            let tier3Remove = cachedTier3Set.subtract(newTier3Set)
            //Remove necessary songs from the cached playlists
            var toRemove = [Song]()
            for song in cachedTier1Playlist{
                if tier1Remove.contains((song as! Song).persistentID) {
                    toRemove.append(song as! Song)
                }
            }
            cachedTier1Playlist.removeObjectsInArray(toRemove); toRemove = []
            for song in cachedTier2Playlist{
                if tier2Remove.contains((song as! Song).persistentID) {
                    toRemove.append(song as! Song)
                }
            }
            cachedTier2Playlist.removeObjectsInArray(toRemove); toRemove = []
            for song in cachedTier3Playlist{
                if tier3Remove.contains((song as! Song).persistentID) {
                    toRemove.append(song as! Song)
                }
            }
            cachedTier3Playlist.removeObjectsInArray(toRemove)
            //Add necessary songs to the cached playlists
            for songID in tier1Add {
                cachedTier1Playlist.addObject(applescriptBridge.getSong(songID))
            }
            for songID in tier2Add {
                cachedTier2Playlist.addObject(applescriptBridge.getSong(songID))
            }
            for songID in tier3Add {
                cachedTier3Playlist.addObject(applescriptBridge.getSong(songID))
            }
            //return true indicating that refreshing the cache was a sucessful
            return true
        }
    }
    
    //Selector functions. The call to myApplication brings the system focus to the application when a window is called from the menu. This needs to be done because clicking on the app in the systemStatusBar doesn't bring focus to the application
    func showSchedule(){
        if AdminAccessObject.isAuthorized() == true {
            myApplication.activateIgnoringOtherApps(true)
            MasterScheduleObject.spawnMasterScheduleWindow()
        }
    }
    func showAnnouncements(){
        myApplication.activateIgnoringOtherApps(true)
        GlobalAnnouncementsObject.spawnImmutableGlobalAnnouncements()
    }
    func editAnnouncements(){
        if AdminAccessObject.isAuthorized() == true {
            myApplication.activateIgnoringOtherApps(true)
            GlobalAnnouncementsObject.spawnMutableGlobalAnnouncements()
        }
    }
    func activateMiniPlayerCover(){
        myApplication.activateIgnoringOtherApps(true)
        MiniPlayerCoverObject.spawnMiniPlayerCover()
        (MiniPlayerCoverObject.MiniPlayerCoverPanel.contentView as! MiniPlayerCoverView).addTrackingArea()
        statusItem.menu?.itemAtIndex(5)?.title = "Deactivate MiniPlayer Cover"
        statusItem.menu?.itemAtIndex(5)?.action = #selector(deactivateMiniPlayerCover)
        statusItem.menu?.itemAtIndex(6)?.hidden = false
    }
    func deactivateMiniPlayerCover(){
        MiniPlayerCoverObject.MiniPlayerCoverPanel.close()
        statusItem.menu?.itemAtIndex(5)?.title = "Activate MiniPlayer Cover"
        statusItem.menu?.itemAtIndex(5)?.action = #selector(activateMiniPlayerCover)
        statusItem.menu?.itemAtIndex(6)?.hidden = true
        
    }
    func showMiniPlayerCover(){
        if MiniPlayerCoverObject.isHidden() == false {
            MiniPlayerCoverObject.hideMiniPlayerCover()
            statusItem.menu?.itemAtIndex(6)?.title = "Show MiniPlayer Cover"
        }
        else{
            myApplication.activateIgnoringOtherApps(true)
            MiniPlayerCoverObject.showMiniPlayerCover()
            statusItem.menu?.itemAtIndex(6)?.title = "Hide MiniPlayer Cover"
        }
    }
    func showPreferences(){
        if AdminAccessObject.isAuthorized() == true {
            myApplication.activateIgnoringOtherApps(true)
            PreferencesObject.spawnPreferencesWindow()
        }
    }
    func terminate(){
        if AdminAccessObject.isAuthorized() == true {
            NSApplication.sharedApplication().terminate(self)
        }
    }

}

