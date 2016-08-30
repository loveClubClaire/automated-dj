//
//  AutomatorController.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 6/5/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class AutomatorController: NSObject {
    @IBOutlet weak var MasterScheduleObject: MasterSchedule!
    @IBOutlet weak var PreferencesObject: Preferences!
    @IBOutlet weak var GlobalAnnouncementsObject: GloablAnnouncements!
    @IBOutlet weak var AppDelegateObject: AppDelegate!

    func spawnMasterTimer(){
        NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(masterTimerFunction), userInfo: nil, repeats: true)
    }
    
    func masterTimerFunction(){
        let applescriptBridge = ApplescriptBridge()
        //Create a date object 3 minutes in the future (NOTE: Because of how the timer is configured - to fire every minute - this we will give us a max of three minutes before a show and a minimum of two)
        let futureTime = NSDate.init().dateByAddingTimeInterval(180)
        //Create date formatter, which represents a date as a weekday and the hour and minute. And two more for minute and second respectivally.
        let dateFormatterShowTime = NSDateFormatter()
        dateFormatterShowTime.dateFormat = "EEEE 'at' HH:mm"
        let minuteFormatter = NSDateFormatter()
        minuteFormatter.dateFormat = "mm"
        let secondFormatter = NSDateFormatter()
        secondFormatter.dateFormat = "ss"
        
        //Iterate though all shows and if the start time of a show matches the future time... (Do things)
        for aShow in MasterScheduleObject.dataArray {
            if dateFormatterShowTime.stringFromDate(aShow.startDate!) == dateFormatterShowTime.stringFromDate(futureTime){
                //Determine the name of our generated playlist. This is done to prevent name overlap. We also delete any automated DJ playlist which is not currently playing so that we do not have duplicates of the same playlist.
                var generatedPlaylistName = "Automated DJ"
                //get currently playing playlist
                let currentPlaylist = applescriptBridge.getCurrentPlaylist()
                if currentPlaylist != "Automated DJ" && currentPlaylist != "Automated DJ2" {
                    applescriptBridge.deletePlaylistWithName("Automated DJ")
                    applescriptBridge.deletePlaylistWithName("Automated DJ2")
                }
                else if currentPlaylist == "Automated DJ2" {
                    applescriptBridge.deletePlaylistWithName("Automated DJ")
                }
                else if currentPlaylist == "Automated DJ" {
                    applescriptBridge.deletePlaylistWithName("Automated DJ2")
                    generatedPlaylistName = "Automated DJ2"
                }
                //Get the number of seconds into the hour that the show starts and of the current time. Get the difference of those two numbers and we have the number of seconds until the show begins, which we use as our delay time. If the show starts in the next hour relative to the hour of the current time, then the resulting difference is a negative number. Adding 3600 to that negative number gets us the positive number of seconds until the show begins.
                let showStartTimeSeconds = (Int(minuteFormatter.stringFromDate(aShow.startDate!))! * 60)
                let currentTimeSeconds = (Int(minuteFormatter.stringFromDate(NSDate.init()))! * 60) + (Int(secondFormatter.stringFromDate(NSDate.init())))!
                var delay = showStartTimeSeconds - currentTimeSeconds
                if delay < 0 {delay = delay + 3600}
                //If the show is not automated then only the global announcements window needs to be spawned
                if aShow.automator == nil {
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(delay + PreferencesObject.globalAnnouncementsDelay) * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                        self.GlobalAnnouncementsObject.spawnImmutableGlobalAnnouncements()
                    }
                }
                //If the show is automated, a playlist must be generated and played
                else{
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(delay) * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                       self.playGeneratedPlaylist(generatedPlaylistName)
                    }
                    generatePlaylist(generatedPlaylistName, anAutomator: aShow.automator!)
                }
                break;
            }
        }
    }
    
    func generatePlaylist(playlistName: String, anAutomator: Automator){
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
        //Initalize logging variables
        let startTime = NSDate.init(); var tier1log = 0; var tier2log = 0; var tier3log = 0;
        //NOTE: Automator.totalTime is an hour value! Its a double representing hours. So it needs to be converted to seconds if you want seconds
        let applescriptBridge = ApplescriptBridge()
        let generatedPlaylist: NSMutableArray = NSMutableArray()
        //Get tiered playlists
        self.AppDelegateObject.updateCachedPlaylists()
        let tier1 = NSMutableArray(); tier1.addObjectsFromArray(self.AppDelegateObject.cachedTier1Playlist as [AnyObject])
        let tier2 = NSMutableArray(); tier2.addObjectsFromArray(self.AppDelegateObject.cachedTier2Playlist as [AnyObject])
        let tier3 = NSMutableArray(); tier3.addObjectsFromArray(self.AppDelegateObject.cachedTier3Playlist as [AnyObject])
        //Apply rules to tiered playlists if rules exist
        if anAutomator.rules != nil {
            tier1.filterUsingPredicate(anAutomator.rules!)
            tier2.filterUsingPredicate(anAutomator.rules!)
            tier3.filterUsingPredicate(anAutomator.rules!)
        }
        //get seed playlist if it exists and add seed playlist to generated playlist
        //TODO test if this handles a non existant but non null playlist
        if anAutomator.seedPlayist != nil{
            generatedPlaylist.addObjectsFromArray(applescriptBridge.getSongsInPlaylist(anAutomator.seedPlayist!) as [AnyObject])
            //Remove excess if seed playlist is longer than playlist length
            //While actual time is greater than expected time + tolerance
            while Playlist.getNewPlaylistDuration(generatedPlaylist as Array as! [Song]) > ((anAutomator.totalTime * 3600) + Double(self.PreferencesObject.tollerence)) {
                generatedPlaylist.removeLastObject()
            }
        }
        //main algorithm
        //inatalize variables used for inserting bumpers
        var songBlockCount = 0
        var bumperBlockCount = 0
        var bumperCounter = 0
        var songsBetweenBlocks = 0
        var bumpers = NSMutableArray()
        if anAutomator.bumpersPlaylist != nil{
            bumpers = applescriptBridge.getSongsInPlaylist(anAutomator.bumpersPlaylist!)
            songsBetweenBlocks = anAutomator.songsBetweenBlocks!
        }
        //while the generated playlist length is less than the total time as required by the automator...
        while Playlist.getNewPlaylistDuration(generatedPlaylist as Array as! [Song]) < (anAutomator.totalTime * 3600) {
            //Check to see if its time to add bumpers. Automator contians how many songs there must be in between blocks. When that number is met (and a bumper playlist actually exists), then we add bumpers.
            //bumperBlockCount keeps track of how large our current block is, bumperCounter keeps track of where we are in the bumper playlist. This number rolls over so that once we reach the end of the bumper playlist, we go back to the begining rather than just ending or something. And songBlockCount keeps track of the number of songs added since we last added a bumper
            if songBlockCount == songsBetweenBlocks && anAutomator.bumpersPlaylist != nil {
                while bumperBlockCount < anAutomator.bumpersPerBlock {
                    generatedPlaylist.addObject(bumpers.objectAtIndex(bumperCounter))
                    bumperBlockCount = bumperBlockCount + 1; bumperCounter = bumperCounter + 1
                    if bumperCounter >= bumpers.count {
                        bumperCounter = 0
                    }
                }
                //Because we just blindly add bumpers into the generatedPlaylist, this prevents that process from placing us over the expected time (which is the total time + the tollerence)
                while Playlist.getNewPlaylistDuration(generatedPlaylist as Array as! [Song]) > ((anAutomator.totalTime * 3600) + Double(self.PreferencesObject.tollerence)) {
                    generatedPlaylist.removeLastObject()
                }
                bumperBlockCount = 0
                songBlockCount = 0
            }
            //Actual main algorithm. Song adding yay.
            else{
                var tieredPlaylist = NSMutableArray()
                //Generate a random number between 0 to 99.
                let randomNumber = arc4random_uniform(100)
                if randomNumber >= 0 && randomNumber < UInt32(anAutomator.tierOnePrecent) {
                    tieredPlaylist = tier1
                    tier1log = tier1log + 1
                }
                else if randomNumber >= UInt32(anAutomator.tierOnePrecent) && randomNumber < UInt32(anAutomator.tierOnePrecent + anAutomator.tierTwoPrecent){
                    tieredPlaylist = tier2
                    tier2log = tier2log + 1
                }
                else{
                    tieredPlaylist = tier3
                    tier3log = tier3log + 1
                }
                
                while tieredPlaylist.count > 0 {
                    let songPosition = Int(arc4random_uniform(UInt32(tieredPlaylist.count)))
                    let randomSong = tieredPlaylist.objectAtIndex(songPosition) as! Song; tieredPlaylist.removeObjectAtIndex(songPosition)
                    if (Playlist.getNewPlaylistDuration(generatedPlaylist as Array as! [Song]) + randomSong.duration) < ((anAutomator.totalTime * 3600) + Double(self.PreferencesObject.tollerence)) {
                            generatedPlaylist.addObject(randomSong)
                            songBlockCount = songBlockCount + 1
                            break;
                    }
                }
            }
            //If we have exhuasted all tracks from all tiered playlists, then nothing more can be added to the playlist, regardless of if it long enough. Break so we dont infinatly loop.
            if tier1.count == 0 && tier2.count == 0 && tier3.count == 0 {
                let log = LogGenerator.init()
                log.writeToLog("Tiered Playlists Exhausted")
                break;
            }
        }
        //Once we generated our playlist, create the playlist in iTunes and add all the songs to the iTunes playlist.
        applescriptBridge.createPlaylistWithName(playlistName)
        applescriptBridge.addSongsToPlaylist(playlistName, songArray: generatedPlaylist as [AnyObject])
        //Logging
        let log = LogGenerator.init()
        log.writeToLog("Playlist generation time (in seconds): " + String(startTime.timeIntervalSinceNow * -1.0))
        let allSongs = tier1log + tier2log + tier3log
        let tier1Precent = (Double(tier1log) / Double(allSongs)) * 100.0
        let tier2Precent = (Double(tier2log) / Double(allSongs)) * 100.0
        let tier3Precent = (Double(tier3log) / Double(allSongs)) * 100.0
            log.writeToLog("Precentages of tiered playlists: Tier 1: " + String(format: "%.3f",tier1Precent) + "% Tier 2: " + String(format: "%.3f",tier2Precent) + "% Tier 3: " + String(format: "%.3f",tier3Precent) + "%")
        log.writeToLog("Generated playlist length (in hours): " + String(format: "%.3f",Playlist.getNewPlaylistDuration(generatedPlaylist as Array as! [Song]) / 3600.0))
        log.writeToLog("Current tolerance: " + String(self.PreferencesObject.tollerence) + " seconds")
        }
    }
    
    func playGeneratedPlaylist(playlistName: String){
        let applescriptBridge = ApplescriptBridge()
        //Disable shuffle && looping
        applescriptBridge.disableShuffle()
        applescriptBridge.disableRepeat()
        //delay until current song concludes
        //TODO test how good the delay is. Subtracting half a second from the dealy is a holdover from the 1.0 release. Make sure its still necessary
        var rawDelayTime = applescriptBridge.timeLeftInCurrentSong()
        var delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64( (rawDelayTime - 0.5) * Double(NSEC_PER_SEC)))
        //If iTunes is not playing, then set the delay to 0. (This needs to be done because if a song is paused midway, then timeLeftInCurrentSong will return a greater than zero value, because thats how much time is left in the song! THe only issue is that the song isnt playing. So unchecked, we would wait in silence)
        if applescriptBridge.isiTunesPlaying() == false {
            delayTime = 0
            rawDelayTime = 0
        }
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            applescriptBridge.playPlaylist(playlistName)
            let log = LogGenerator()
            log.writeToLog("Start time of playlist: " + NSDate.init().description)
            log.writeToLog("------------------------------------------------")
        }
        //trim excess fat from generated playlist if possible.
        //if the raw delay time is greater than the last song of the playlist, then subtract the length of that song from the raw delay time and remove that song from the playlist. We then check again to see if the newly updated raw delay time is greater than the (new) last song of the playlist. If so, repeat until no longer the case
        while rawDelayTime > applescriptBridge.getLastSongInPlaylist(playlistName).duration {
            rawDelayTime = rawDelayTime - applescriptBridge.getLastSongInPlaylist(playlistName).duration
            applescriptBridge.removeLastSongInPlaylist(playlistName)
        }
    }
    
}