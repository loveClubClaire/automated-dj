//
//  PlaylistGenerationTests.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 11/22/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import XCTest
@testable import Automated_DJ

class PlaylistGenerationTests: XCTestCase {

    override func setUp() {
        super.setUp()
        let applescriptBridge = ApplescriptBridge()
        let playlists = applescriptBridge.getPlaylists()
        let stringPlaylists = Playlist.getPlaylistNames(true, aPlaylistArray: playlists)
        XCTAssertTrue(stringPlaylists.contains("Tier 1"))
        XCTAssertTrue(stringPlaylists.contains("Tier 2"))
        XCTAssertTrue(stringPlaylists.contains("Tier 3"))
        XCTAssertTrue(stringPlaylists.contains("Pool Playlist"))
        XCTAssertTrue(stringPlaylists.contains("4th Playlist"))

        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        //Make sure we are using our sastifictery tolerance
        appDelegate.PreferencesObject.tollerence = 45
        
        var cacheFilled = false
        while(cacheFilled == false){
            Thread.sleep(forTimeInterval: 1)
            cacheFilled = appDelegate.cachedFilled
        }
        //Set up automator objects
        let defaultAutomator = Automator.init(aTotalTime: 4, aTierOnePrecent: 15, aTierTwoPrecent: 25, aTierThreePrecent: 60)
        let seedAutomator = Automator.init(aTotalTime: 4, aTierOnePrecent: 15, aTierTwoPrecent: 25, aTierThreePrecent: 60, aSeedPlaylist: "Pool Playlist", aBumpersPlaylist: nil, aBumpersPerBlock: nil, aSongBetweenBlocks: nil, aRules: nil)
        let bumpersAutomator = Automator.init(aTotalTime: 4, aTierOnePrecent: 15, aTierTwoPrecent: 25, aTierThreePrecent: 60, aSeedPlaylist: nil, aBumpersPlaylist: "4th Playlist", aBumpersPerBlock: 1, aSongBetweenBlocks: 10, aRules: nil)
        let rulesAutomator = Automator.init(aTotalTime: 4, aTierOnePrecent: 15, aTierTwoPrecent: 25, aTierThreePrecent: 60, aSeedPlaylist: nil, aBumpersPlaylist: nil, aBumpersPerBlock: nil, aSongBetweenBlocks: nil, aRules: NSPredicate(format: "Artist = 'The Beatles' "))
        let masterAutomator = Automator.init(aTotalTime: 4, aTierOnePrecent: 15, aTierTwoPrecent: 25, aTierThreePrecent: 60, aSeedPlaylist: "Pool Playlist", aBumpersPlaylist: "4th Playlist", aBumpersPerBlock: 1, aSongBetweenBlocks: 10, aRules: NSPredicate(format: "Artist != 'The Beatles' "))
        
        //Generate playlists
        appDelegate.AutomatorControllerObject.generatePlaylist("My System Test 1", anAutomator: defaultAutomator)
        Thread.sleep(forTimeInterval: 3)
        appDelegate.AutomatorControllerObject.generatePlaylist("My System Test 2", anAutomator: seedAutomator)
        Thread.sleep(forTimeInterval: 3)
        appDelegate.AutomatorControllerObject.generatePlaylist("My System Test 3", anAutomator: bumpersAutomator)
        Thread.sleep(forTimeInterval: 3)
        appDelegate.AutomatorControllerObject.generatePlaylist("My System Test 4", anAutomator: rulesAutomator)
        Thread.sleep(forTimeInterval: 3)
        appDelegate.AutomatorControllerObject.generatePlaylist("My System Test 5", anAutomator: masterAutomator)
        Thread.sleep(forTimeInterval: 3)
    }
    
    func testPlaylistLengths(){
        let applescriptBridge = ApplescriptBridge()
        //Test Playlist length for playlist 1
        var rawSongs = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "My System Test 1")
        var songs = [Song]()
        for rawSong in rawSongs {
            songs.append(applescriptBridge.getSong(anID: rawSong as NSString))
        }
        var length = Playlist.getNewPlaylistDuration(songs)
        XCTAssertTrue(length >= 14400 && length <= 14445,String(length))
        //Test Playlist length for playlist 2
        rawSongs = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "My System Test 2")
        songs = [Song]()
        for rawSong in rawSongs {
            songs.append(applescriptBridge.getSong(anID: rawSong as NSString))
        }
        length = Playlist.getNewPlaylistDuration(songs)
        XCTAssertTrue(length >= 14400 && length <= 14445,String(length))
        //Test Playlist length for playlist 3
        rawSongs = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "My System Test 3")
        songs = [Song]()
        for rawSong in rawSongs {
            songs.append(applescriptBridge.getSong(anID: rawSong as NSString))
        }
        length = Playlist.getNewPlaylistDuration(songs)
        XCTAssertTrue(length >= 14400 && length <= 14445,String(length))
        //Test Playlist length for playlist 4
        rawSongs = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "My System Test 4")
        songs = [Song]()
        for rawSong in rawSongs {
            songs.append(applescriptBridge.getSong(anID: rawSong as NSString))
        }
        length = Playlist.getNewPlaylistDuration(songs)
        XCTAssertTrue(length >= 14400 && length <= 14445,String(length))
        //Test Playlist length for playlist 5
        rawSongs = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "My System Test 5")
        songs = [Song]()
        for rawSong in rawSongs {
            songs.append(applescriptBridge.getSong(anID: rawSong as NSString))
        }
        length = Playlist.getNewPlaylistDuration(songs)
        XCTAssertTrue(length >= 14400 && length <= 14445,String(length))
    }
    
    func testSeedPlaylist(){
        let applescriptBridge = ApplescriptBridge()
        //Test seed playlist for seed automator
        let rawSongs = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "My System Test 2")
        var songs = [Song]()
        for rawSong in rawSongs {
            songs.append(applescriptBridge.getSong(anID: rawSong as NSString))
        }
        let otherRawSongs = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "Pool Playlist")
        var seedSongs = [Song]()
        for rawSong in otherRawSongs {
            seedSongs.append(applescriptBridge.getSong(anID: rawSong as NSString))
        }
        var i = 0;
        for aSong in seedSongs {
            XCTAssertTrue(aSong.name == songs[i].name)
            XCTAssertTrue(aSong.artist == songs[i].artist)
            XCTAssertTrue(aSong.album == songs[i].album)
            i = i + 1;
        }
        
        //Test seed playlist for master automator
        let rawSongs2 = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "My System Test 5")
        var songs2 = [Song]()
        for rawSong in rawSongs2 {
            songs2.append(applescriptBridge.getSong(anID: rawSong as NSString))
        }
        let otherRawSongs2 = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "Pool Playlist")
        var seedSongs2 = [Song]()
        for rawSong in otherRawSongs2 {
            seedSongs2.append(applescriptBridge.getSong(anID: rawSong as NSString))
        }
        var j = 0;
        for aSong in seedSongs {
            XCTAssertTrue(aSong.name == songs[j].name)
            XCTAssertTrue(aSong.artist == songs[j].artist)
            XCTAssertTrue(aSong.album == songs[j].album)
            j = j + 1;
        }

    }
    
    func testBumpersPlaylist(){
        let applescriptBridge = ApplescriptBridge()
        //Test bumpers playlist for bumpers automator
        let rawSongs = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "My System Test 3")
        var songs = [Song]()
        for rawSong in rawSongs {
            songs.append(applescriptBridge.getSong(anID: rawSong as NSString))
        }
        let otherRawSongs = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "4th Playlist")
        var bumperSongs = [Song]()
        for rawSong in otherRawSongs {
            bumperSongs.append(applescriptBridge.getSong(anID: rawSong as NSString))
        }
        var i = 0;
        var j = 0;
        for aSong in songs {
            if(((i + 1) % 11) == 0){
                XCTAssertTrue(aSong.name == bumperSongs[j].name, aSong.name + "  " + bumperSongs[j].name)
                XCTAssertTrue(aSong.artist == bumperSongs[j].artist)
                XCTAssertTrue(aSong.album == bumperSongs[j].album)
                j = j + 1;
            }
            i = i + 1;
        }

        //Test master playlist for master automator
        let rawSongs2 = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "My System Test 5")
        var songs2 = [Song]()
        for rawSong in rawSongs2 {
            songs2.append(applescriptBridge.getSong(anID: rawSong as NSString))
        }
        let otherRawSongs2 = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "4th Playlist")
        var bumperSongs2 = [Song]()
        for rawSong in otherRawSongs2 {
            bumperSongs2.append(applescriptBridge.getSong(anID: rawSong as NSString))
        }
        var k = 0
        while k < 15 {
            songs2.removeFirst()
            k = k + 1;
        }
        var ii = 0;
        var jj = 0;
        for aSong in songs2 {
            if(((ii + 1) % 11) == 0){
                XCTAssertTrue(aSong.name == bumperSongs[jj].name, aSong.name + "  " + bumperSongs[jj].name)
                XCTAssertTrue(aSong.artist == bumperSongs[jj].artist)
                XCTAssertTrue(aSong.album == bumperSongs[jj].album)
                jj = jj + 1;
            }
            ii = ii + 1;
        }

    }
    
    func testRules(){
        let applescriptBridge = ApplescriptBridge()
        //Test rules playlist for rules automator
        var rawSongs = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "My System Test 4")
        var songs = [Song]()
        for rawSong in rawSongs {
            songs.append(applescriptBridge.getSong(anID: rawSong as NSString))
        }
        for song in songs{
            XCTAssertTrue(song.artist == "The Beatles")
        }
        //Test master playlist for master automator
        rawSongs = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "My System Test 5")
        songs = [Song]()
        for rawSong in rawSongs {
            songs.append(applescriptBridge.getSong(anID: rawSong as NSString))
        }
        for song in songs{
            XCTAssertTrue(song.artist != "The Beatles")
        }

    }
    
    func testErrorChecking(){
        //Do Tiered Playlists Exist?
        let tieredPlaylistsResult = ErrorChecker.doTieredPlaylistsExist()
        XCTAssertTrue(tieredPlaylistsResult.tier1Exist); XCTAssertTrue(tieredPlaylistsResult.tier2Exist); XCTAssertTrue(tieredPlaylistsResult.tier3Exist);
        //Do Precentages sum to 100?
        //By default the show is not valid. Create an automator where tiered precentages add up to 100. Automator status relates to windows and if their values have been modifed. For this test, we set the values of the tired precentages to false, making the function check the given automator and not the automator contained in the show obejct. Because it's not going to check inside the show object at all, we just create a show object with junk data and put it into an array to satisfy the functions pramaters. (Array can't be empty because it's itterated over)
        var isValidShow = false
        let defaultAutomator = Automator.init(aTotalTime: 4, aTierOnePrecent: 15, aTierTwoPrecent: 25, aTierThreePrecent: 60)
        let automatorStatus = AutomatorStatus.init()
        automatorStatus.tierOnePrecent = false; automatorStatus.tierTwoPrecent = false; automatorStatus.tierThreePrecent = false;
        var shows = [Show](); let show = Show.init(aName: "Test Show", aStartDate: Date.init(), anEndDate: Date.init()); shows.append(show)
        ErrorChecker.simpleAutomatorValidityCheck(anAutomator: defaultAutomator, anAutomatorStatus: automatorStatus, selectedShows: shows, isValid: {value in isValidShow = value})
        //Show should pass
        XCTAssertTrue(isValidShow)
        //Change the value of one of the tiers, they no longer add up to 100, and the test should fail
        defaultAutomator.tierOnePrecent = 30
        ErrorChecker.simpleAutomatorValidityCheck(anAutomator: defaultAutomator, anAutomatorStatus: automatorStatus, selectedShows: shows, isValid: {value in isValidShow = value})
        XCTAssertFalse(isValidShow)
        //Check full automator valitity
         let masterAutomator = Automator.init(aTotalTime: 4, aTierOnePrecent: 15, aTierTwoPrecent: 25, aTierThreePrecent: 60, aSeedPlaylist: "Pool Playlist", aBumpersPlaylist: "4th Playlist", aBumpersPerBlock: 1, aSongBetweenBlocks: 10, aRules: NSPredicate(format: "Artist != 'The Beatles' "))
        automatorStatus.rules = false
        let errorCheckerGroup = DispatchGroup()
        errorCheckerGroup.enter()
        ErrorChecker.checkAutomatorValidity(isValid: {value in isValidShow = value}, anAutomator: masterAutomator, anAutomatorStatus: automatorStatus, selectedShows: shows, dispatchGroup: errorCheckerGroup)
        errorCheckerGroup.notify(queue: DispatchQueue.main) {
            XCTAssertTrue(isValidShow)
        }
    }
    
    func Precentages(){
        let applescriptBridge = ApplescriptBridge()
        var rawSongs = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "Tier 1")
        var tier1 = [String]()
        for rawSong in rawSongs {
            tier1.append((applescriptBridge.getSong(anID: rawSong as NSString)).description)
        }
        rawSongs = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "Tier 2")
        var tier2 = [String]()
        for rawSong in rawSongs {
            tier2.append((applescriptBridge.getSong(anID: rawSong as NSString)).description)
        }
        rawSongs = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "Tier 3")
        var tier3 = [String]()
        for rawSong in rawSongs {
             tier3.append((applescriptBridge.getSong(anID: rawSong as NSString)).description)
        }
        //Get precentages for playlist 1
        rawSongs = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "My System Test 1")
        var songs = [Song]()
        for rawSong in rawSongs {
            songs.append(applescriptBridge.getSong(anID: rawSong as NSString))
        }
        var tier1Precent = 0.0
        var tier2Precent = 0.0
        var tier3Precent = 0.0
        for song in songs {
            if tier1.contains(song.description) {
                tier1Precent = tier1Precent + 1.0
            }
            else if tier2.contains(song.description) {
                tier2Precent = tier2Precent + 1.0
            }
            else if tier3.contains(song.description) {
                tier3Precent = tier3Precent + 1.0
            }
        }
        tier1Precent = Double(Double(tier1Precent).divided(by: Double(songs.count))).multiplied(by: 100.0)
        tier2Precent = Double(Double(tier2Precent).divided(by: Double(songs.count))).multiplied(by: 100.0)
        tier3Precent = Double(Double(tier3Precent).divided(by: Double(songs.count))).multiplied(by: 100.0)
        print(String(tier1Precent)+" "+String(tier2Precent)+" "+String(tier3Precent))
        XCTAssertTrue((tier1Precent + tier2Precent + tier3Precent) == 100,(String(tier1Precent)+" "+String(tier2Precent)+" "+String(tier3Precent)))
        
        //Get precentages for playlist 2
        rawSongs = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "My System Test 2")
        songs = [Song]()
        for rawSong in rawSongs {
            songs.append(applescriptBridge.getSong(anID: rawSong as NSString))
        }
        var tier1Precent2 = 0.0
        var tier2Precent2 = 0.0
        var tier3Precent2 = 0.0
        for song in songs {
            if tier1.contains(song.description) {
                tier1Precent2 = tier1Precent2 + 1.0
            }
            else if tier2.contains(song.description) {
                tier2Precent2 = tier2Precent2 + 1.0
            }
            else if tier3.contains(song.description) {
                tier3Precent2 = tier3Precent2 + 1.0
            }
        }
        tier1Precent2 = Double(Double(tier1Precent2).divided(by: Double(songs.count))).multiplied(by: 100.0)
        tier2Precent2 = Double(Double(tier2Precent2).divided(by: Double(songs.count))).multiplied(by: 100.0)
        tier3Precent2 = Double(Double(tier3Precent2).divided(by: Double(songs.count))).multiplied(by: 100.0)
        XCTAssertTrue((tier1Precent2 + tier2Precent2 + tier3Precent2) == 100,(String(tier1Precent2)+" "+String(tier2Precent2)+" "+String(tier3Precent2)))
        
        //Get precentages for playlist 3
        rawSongs = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "My System Test 3")
        songs = [Song]()
        for rawSong in rawSongs {
            songs.append(applescriptBridge.getSong(anID: rawSong as NSString))
        }
        var tier1Precent3 = 0.0
        var tier2Precent3 = 0.0
        var tier3Precent3 = 0.0
        for song in songs {
            if tier1.contains(song.description) {
                tier1Precent3 = tier1Precent3 + 1.0
            }
            else if tier2.contains(song.description) {
                tier2Precent3 = tier2Precent3 + 1.0
            }
            else if tier3.contains(song.description) {
                tier3Precent3 = tier3Precent3 + 1.0
            }
        }
        tier1Precent3 = Double(Double(tier1Precent3).divided(by: Double(songs.count))).multiplied(by: 100.0)
        tier2Precent3 = Double(Double(tier2Precent3).divided(by: Double(songs.count))).multiplied(by: 100.0)
        tier3Precent3 = Double(Double(tier3Precent3).divided(by: Double(songs.count))).multiplied(by: 100.0)
        XCTAssertTrue((tier1Precent3 + tier2Precent3 + tier3Precent3) == 100,(String(tier1Precent3)+" "+String(tier2Precent3)+" "+String(tier3Precent3)))
        
        //Get precentages for playlist 4
        rawSongs = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "My System Test 4")
        songs = [Song]()
        for rawSong in rawSongs {
            songs.append(applescriptBridge.getSong(anID: rawSong as NSString))
        }
        var tier1Precent4 = 0.0
        var tier2Precent4 = 0.0
        var tier3Precent4 = 0.0
        for song in songs {
            if tier1.contains(song.description) {
                tier1Precent4 = tier1Precent4 + 1.0
            }
            else if tier2.contains(song.description) {
                tier2Precent4 = tier2Precent4 + 1.0
            }
            else if tier3.contains(song.description) {
                tier3Precent4 = tier3Precent4 + 1.0
            }
        }
        tier1Precent4 = Double(Double(tier1Precent4).divided(by: Double(songs.count))).multiplied(by: 100.0)
        tier2Precent4 = Double(Double(tier2Precent4).divided(by: Double(songs.count))).multiplied(by: 100.0)
        tier3Precent4 = Double(Double(tier3Precent4).divided(by: Double(songs.count))).multiplied(by: 100.0)
        XCTAssertTrue((tier1Precent4 + tier2Precent4 + tier3Precent4) == 100,(String(tier1Precent4)+" "+String(tier2Precent4)+" "+String(tier3Precent4)))
        
        //Get precentages for playlist 5
        rawSongs = applescriptBridge.getPersistentIDsOfSongsInPlaylist(aPlaylist: "My System Test 5")
        songs = [Song]()
        for rawSong in rawSongs {
            songs.append(applescriptBridge.getSong(anID: rawSong as NSString))
        }
        var tier1Precent5 = 0.0
        var tier2Precent5 = 0.0
        var tier3Precent5 = 0.0
        for song in songs {
            if tier1.contains(song.description) {
                tier1Precent5 = tier1Precent5 + 1.0
            }
            else if tier2.contains(song.description) {
                tier2Precent5 = tier2Precent5 + 1.0
            }
            else if tier3.contains(song.description) {
                tier3Precent5 = tier3Precent5 + 1.0
            }
        }
        tier1Precent5 = Double(Double(tier1Precent5).divided(by: Double(songs.count))).multiplied(by: 100.0)
        tier2Precent5 = Double(Double(tier2Precent5).divided(by: Double(songs.count))).multiplied(by: 100.0)
        tier3Precent5 = Double(Double(tier3Precent5).divided(by: Double(songs.count))).multiplied(by: 100.0)
        XCTAssertTrue((tier1Precent5 + tier2Precent5 + tier3Precent5) == 100,(String(tier1Precent5)+" "+String(tier2Precent5)+" "+String(tier3Precent5)))

        let tier1Real = (tier1Precent + tier1Precent2 + tier1Precent3 + tier1Precent4 + tier1Precent5) / 5
        let tier2Real = (tier2Precent + tier2Precent2 + tier2Precent3 + tier2Precent4 + tier2Precent5) / 5
        let tier3Real = (tier3Precent + tier3Precent2 + tier3Precent3 + tier3Precent4 + tier3Precent5) / 5
        
        XCTAssertTrue((tier1Real >= 10) && (tier1Real <= 20),String(tier1Real))
        XCTAssertTrue((tier2Real >= 20) && (tier2Real <= 30),String(tier2Real))
        XCTAssertTrue((tier3Real >= 55) && (tier3Real <= 65),String(tier3Real))
    }
    
    override func tearDown() {
        super.tearDown()
        let applescriptBridge = ApplescriptBridge()
        applescriptBridge.deletePlaylistWithName(aName: "My System Test 1")
        applescriptBridge.deletePlaylistWithName(aName: "My System Test 2")
        applescriptBridge.deletePlaylistWithName(aName: "My System Test 3")
        applescriptBridge.deletePlaylistWithName(aName: "My System Test 4")
        applescriptBridge.deletePlaylistWithName(aName: "My System Test 5")
        Thread.sleep(forTimeInterval: 1)
    }


    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
