//
//  Automator.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/11/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation

class Automator: NSObject {
    //In Hours
    var totalTime: Double
    var tierOnePrecent: Int
    var tierTwoPrecent: Int
    var tierThreePrecent: Int
    var seedPlayist: String?
    var bumpersPlaylist: String?
    var bumpersPerBlock: Int?
    var songsBetweenBlocks: Int?
    var rules: NSPredicate?
    

    init(aTotalTime: Double, aTierOnePrecent: Int, aTierTwoPrecent: Int, aTierThreePrecent: Int) {
        totalTime = aTotalTime
        tierOnePrecent = aTierOnePrecent
        tierTwoPrecent = aTierTwoPrecent
        tierThreePrecent = aTierThreePrecent
        seedPlayist = nil
        bumpersPlaylist = nil
        bumpersPerBlock = nil
        songsBetweenBlocks = nil
        rules = nil

    }
    
    init(aTotalTime: Double, aTierOnePrecent: Int, aTierTwoPrecent: Int, aTierThreePrecent: Int, aSeedPlaylist: String?, aBumpersPlaylist: String?, aBumpersPerBlock: Int?, aSongBetweenBlocks: Int?, aRules: NSPredicate?){
        totalTime = aTotalTime
        tierOnePrecent = aTierOnePrecent
        tierTwoPrecent = aTierTwoPrecent
        tierThreePrecent = aTierThreePrecent
        seedPlayist = aSeedPlaylist
        bumpersPlaylist = aBumpersPlaylist
        bumpersPerBlock = aBumpersPerBlock
        songsBetweenBlocks = aSongBetweenBlocks
        rules = aRules
    }
    
    //Decode each individual object and then create a new object instance
    required convenience init?(coder decoder: NSCoder) {
        guard let totalTime = decoder.decodeObjectForKey("totalTime") as? Double,
            let tierOnePrecent = decoder.decodeObjectForKey("tierOnePrecent") as? Int,
            let tierTwoPrecent = decoder.decodeObjectForKey("tierTwoPrecent") as? Int,
            let tierThreePrecent = decoder.decodeObjectForKey("tierThreePrecent") as? Int,
            let seedPlayist = decoder.decodeObjectForKey("seedPlayist") as? String?,
            let bumpersPlaylist = decoder.decodeObjectForKey("bumpersPlaylist") as? String?,
            let bumpersPerBlock = decoder.decodeObjectForKey("bumpersPerBlock") as? Int?,
            let songsBetweenBlocks = decoder.decodeObjectForKey("songsBetweenBlocks") as? Int?,
            let rules = decoder.decodeObjectForKey("rules") as? NSPredicate?
            else { return nil }
        
        self.init(aTotalTime: totalTime, aTierOnePrecent: tierOnePrecent, aTierTwoPrecent: tierTwoPrecent, aTierThreePrecent: tierThreePrecent, aSeedPlaylist: seedPlayist, aBumpersPlaylist: bumpersPlaylist, aBumpersPerBlock: bumpersPerBlock, aSongBetweenBlocks: songsBetweenBlocks, aRules: rules)
    }
    //Encoding fucntion for saving. Encode each object with a key for retervial
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(totalTime, forKey: "totalTime")
        coder.encodeObject(tierOnePrecent, forKey: "tierOnePrecent")
        coder.encodeObject(tierTwoPrecent, forKey: "tierTwoPrecent")
        coder.encodeObject(tierThreePrecent, forKey: "tierThreePrecent")
        coder.encodeObject(seedPlayist, forKey: "seedPlayist")
        coder.encodeObject(bumpersPlaylist, forKey: "bumpersPlaylist")
        coder.encodeObject(bumpersPerBlock, forKey: "bumpersPerBlock")
        coder.encodeObject(songsBetweenBlocks, forKey: "songsBetweenBlocks")
        coder.encodeObject(rules, forKey: "rules")
    }
        
    func compare(anAutomator: Automator?) -> NSComparisonResult {
        if anAutomator == nil {
            return NSComparisonResult.OrderedDescending
        }
        else{
            return NSComparisonResult.OrderedSame
        }
}
    
}