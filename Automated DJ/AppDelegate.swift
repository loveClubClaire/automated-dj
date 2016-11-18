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
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    let myApplication = NSApplication.shared()
    
    var storedProgramsFilepath = ""
    var storedAnnouncementsFilepath = ""
    var storedPreferencesFilepath = ""
    
    var cachedFilled = false
    var cachedTier1Playlist = NSMutableArray()
    var cachedTier2Playlist = NSMutableArray()
    var cachedTier3Playlist = NSMutableArray()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //Required for the scripting bridge to function
        Bundle.main.loadAppleScriptObjectiveCScripts()
        
        //Check to see if tiered playlists have been created and if not, create them
        let areTieredPlaylistsCreated = ErrorChecker.doTieredPlaylistsExist()
        if areTieredPlaylistsCreated.tier1Exist == false {ApplescriptBridge().createPlaylistWithName(aName: "Tier 1")}
        if areTieredPlaylistsCreated.tier2Exist == false {ApplescriptBridge().createPlaylistWithName(aName: "Tier 2")}
        if areTieredPlaylistsCreated.tier3Exist == false {ApplescriptBridge().createPlaylistWithName(aName: "Tier 3")}

        //Inatalizes things in the masterScheduleObject related to its UI. Check this function for more information.
        MasterScheduleObject.viewDidLoad()
        
        //Intalized the ruleScrollView object. Check this function for more information
        RuleScrollViewObject.initalize()
        
        //Intalized the Preferences Object. Check this function for more information
        PreferencesObject.initialize()
        
        //Hides the gloablAnnouncementsToolbar and places its buttons on the same level as the quit button and title
        GlobalAnnouncementsObject.globalAnnouncementsWindow.titleVisibility = NSWindowTitleVisibility.hidden

        //Populate the Show Window drop down menus with the days of the week
        let daysOfTheWeek = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
        ShowWindowObject.startDay.addItems(withTitles: daysOfTheWeek)
        ShowWindowObject.endDay.addItems(withTitles: daysOfTheWeek)

        //Configure the number formatter for the automator window so we can have trailing zeros and doubles which are not too large
        (AutomatorWindowObject.timeTextField.formatter as! NumberFormatter).minimumFractionDigits = 2
        (AutomatorWindowObject.timeTextField.formatter as! NumberFormatter).maximumFractionDigits = 2
        
        //Get the filepaths of our applications stored data.
        //We grab the URL for the application support folder and append the application name to the end of it, giving us the filepath where all data is stored. If the app has been run before, we should have a valid URL, if not, we create the directory so that the URL is valid. We then create constants with individual file names appended to the stored data directory. If a file does not exist, it will be created using that filepath.
        let applicationSupportFilepath = try! FileManager().url(for: FileManager.SearchPathDirectory.applicationSupportDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        let storedDataFilepath = applicationSupportFilepath.path + "/Automated DJ"
        if(FileManager().fileExists(atPath: storedDataFilepath) == false){
            try! FileManager().createDirectory(atPath: storedDataFilepath, withIntermediateDirectories:false, attributes: nil)
        }
        storedProgramsFilepath = storedDataFilepath + "/MasterSchedule.txt"
        storedAnnouncementsFilepath = storedDataFilepath + "/GlobalAnnouncements.txt"
        storedPreferencesFilepath = storedDataFilepath + "/Preferences.txt"
        
        //Get the information stored in file at the storedProgramsFilepath. If its not empty (or non existant), set the data array to the reterived values and reload the tableview
        let shows = NSKeyedUnarchiver.unarchiveObject(withFile: storedProgramsFilepath)
        if shows != nil {
            MasterScheduleObject.dataArray = shows as! [Show]
            MasterScheduleObject.tableView.reloadData()
        }
        
        //Get the information stored in file at the storedAnnouncementsFilepath. If its not empty (or non existant), set the global annoucements data array to the reterived values and reload the tableview
        let announcements = NSKeyedUnarchiver.unarchiveObject(withFile: storedAnnouncementsFilepath)
        if announcements != nil {
            GlobalAnnouncementsObject.dataArray = announcements as! [String]
            GlobalAnnouncementsObject.tableView.reloadData()
        }
        
        //Get the information stored in file at the storedPreferencesFilePath. If it's not empty (or non existant), call Preferences' setValuesWith function and pass it the reterived array. Else, create a new array containing the default values and pass setValuesWith that new array
        let preferences = NSKeyedUnarchiver.unarchiveObject(withFile: storedPreferencesFilepath)
        if preferences != nil {
            PreferencesObject.setValuesWith(preferences as! [AnyObject])
        }
        else{
            //Get the filepath to he desktop so the default log filepath can be set to the desktop
            let fileManager = FileManager()
            let desktopFilepathURL = try? fileManager.url(for: FileManager.SearchPathDirectory.desktopDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create:false)
            PreferencesObject.setValuesWith([Automator.init(aTotalTime: 2.0, aTierOnePrecent: 15, aTierTwoPrecent: 25, aTierThreePrecent: 60),false as AnyObject,240 as AnyObject,50 as AnyObject,true as AnyObject,false as AnyObject,(desktopFilepathURL?.path)! as AnyObject])
        }
        //Inatalize the timer
        AutomatorControllerObject.spawnMasterTimer()
        
        //Inatalize the menu bar. Then create NSMenuItems and add them to the menu bar. Then set the menu bar to be our applications menu bar. NSMenuItems which are not separators are given a name an a selector which corresponds to a function related to the name.
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Show Schedule", action: #selector(showSchedule), keyEquivalent: "S"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Show Announcements", action: #selector(showAnnouncements), keyEquivalent: "A"))
        menu.addItem(NSMenuItem(title: "Edit Announcements", action: #selector(editAnnouncements), keyEquivalent: "E"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Activate MiniPlayer Cover", action: #selector(activateMiniPlayerCover), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Hide MiniPlayer Cover", action: #selector(showMiniPlayerCover), keyEquivalent: ""))
            menu.item(at: 6)?.isHidden = true
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Preferences", action: #selector(showPreferences), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(terminate), keyEquivalent: "q"))
        statusItem.menu = menu
        statusItem.button?.image = NSImage.init(named:"On Air.png")
        
        //Populate the tiered playlists caches. Can take an extended period of time so an async task is spawned
        DispatchQueue.global().async {
            let applescriptBridge = ApplescriptBridge()
            autoreleasepool{
                self.cachedTier1Playlist = applescriptBridge.getSongsInPlaylist(aPlaylist: "Tier 1")
                self.cachedTier2Playlist = applescriptBridge.getSongsInPlaylist(aPlaylist: "Tier 2")
                self.cachedTier3Playlist = applescriptBridge.getSongsInPlaylist(aPlaylist: "Tier 3")
            }
            self.cachedFilled = true
            NSLog("Cache filled")
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        var result = false;
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = "All unsaved scheduler data will be lost"
        myPopup.informativeText = "Are you sure you want to continue?"
        myPopup.alertStyle = NSAlertStyle.critical
        myPopup.addButton(withTitle: "OK")
        myPopup.addButton(withTitle: "Cancel")
        let res = myPopup.runModal()
        if res == NSAlertFirstButtonReturn {
            MasterScheduleObject.dataArray = NSKeyedUnarchiver.unarchiveObject(withFile: filename) as! [Show]
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
            let newTier1Set = Set(applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "Tier 1"))
            let newTier2Set = Set(applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "Tier 2"))
            let newTier3Set = Set(applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "Tier 3"))
            //Get all persistant ID's to be added to the tiered playlists
            let tier1Add = newTier1Set.subtracting(cachedTier1Set)
            let tier2Add = newTier2Set.subtracting(cachedTier2Set)
            let tier3Add = newTier3Set.subtracting(cachedTier3Set)
            //Get all persistant ID's to be removed from the tiered playlists
            let tier1Remove = cachedTier1Set.subtracting(newTier1Set)
            let tier2Remove = cachedTier2Set.subtracting(newTier2Set)
            let tier3Remove = cachedTier3Set.subtracting(newTier3Set)
            //Remove necessary songs from the cached playlists
            var toRemove = [Song]()
            for song in cachedTier1Playlist{
                if tier1Remove.contains((song as! Song).persistentID) {
                    toRemove.append(song as! Song)
                }
            }
            cachedTier1Playlist.removeObjects(in: toRemove); toRemove = []
            for song in cachedTier2Playlist{
                if tier2Remove.contains((song as! Song).persistentID) {
                    toRemove.append(song as! Song)
                }
            }
            cachedTier2Playlist.removeObjects(in: toRemove); toRemove = []
            for song in cachedTier3Playlist{
                if tier3Remove.contains((song as! Song).persistentID) {
                    toRemove.append(song as! Song)
                }
            }
            cachedTier3Playlist.removeObjects(in: toRemove)
            //Add necessary songs to the cached playlists
            for songID in tier1Add {
                cachedTier1Playlist.add(applescriptBridge.getSong(anID: songID as NSString))
            }
            for songID in tier2Add {
                cachedTier2Playlist.add(applescriptBridge.getSong(anID: songID as NSString))
            }
            for songID in tier3Add {
                cachedTier3Playlist.add(applescriptBridge.getSong(anID: songID as NSString))
            }
            //return true indicating that refreshing the cache was a sucessful
            return true
        }
    }
    
    //Selector functions. The call to myApplication brings the system focus to the application when a window is called from the menu. This needs to be done because clicking on the app in the systemStatusBar doesn't bring focus to the application
    func showSchedule(){
        if AdminAccessObject.isAuthorized() == true {
            myApplication.activate(ignoringOtherApps: true)
            MasterScheduleObject.spawnMasterScheduleWindow()
        }
    }
    func showAnnouncements(){
        myApplication.activate(ignoringOtherApps: true)
        GlobalAnnouncementsObject.spawnImmutableGlobalAnnouncements()
    }
    func editAnnouncements(){
        if AdminAccessObject.isAuthorized() == true {
            myApplication.activate(ignoringOtherApps: true)
            GlobalAnnouncementsObject.spawnMutableGlobalAnnouncements()
        }
    }
    func activateMiniPlayerCover(){
        myApplication.activate(ignoringOtherApps: true)
        MiniPlayerCoverObject.spawnMiniPlayerCover()
        (MiniPlayerCoverObject.MiniPlayerCoverPanel.contentView as! MiniPlayerCoverView).addTrackingArea()
        statusItem.menu?.item(at: 5)?.title = "Deactivate MiniPlayer Cover"
        statusItem.menu?.item(at: 5)?.action = #selector(deactivateMiniPlayerCover)
        statusItem.menu?.item(at: 6)?.isHidden = false
    }
    func deactivateMiniPlayerCover(){
        MiniPlayerCoverObject.MiniPlayerCoverPanel.close()
        statusItem.menu?.item(at: 5)?.title = "Activate MiniPlayer Cover"
        statusItem.menu?.item(at: 5)?.action = #selector(activateMiniPlayerCover)
        statusItem.menu?.item(at: 6)?.isHidden = true
        
    }
    func showMiniPlayerCover(){
        if MiniPlayerCoverObject.isHidden() == false {
            MiniPlayerCoverObject.hideMiniPlayerCover()
            statusItem.menu?.item(at: 6)?.title = "Show MiniPlayer Cover"
        }
        else{
            myApplication.activate(ignoringOtherApps: true)
            MiniPlayerCoverObject.showMiniPlayerCover()
            statusItem.menu?.item(at: 6)?.title = "Hide MiniPlayer Cover"
        }
    }
    func showPreferences(){
        if AdminAccessObject.isAuthorized() == true {
            myApplication.activate(ignoringOtherApps: true)
            PreferencesObject.spawnPreferencesWindow()
        }
    }
    func terminate(){
        if AdminAccessObject.isAuthorized() == true {
            NSApplication.shared().terminate(self)
        }
    }

}

