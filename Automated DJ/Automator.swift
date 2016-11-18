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
        guard let totalTime = decoder.decodeObject(forKey: "totalTime") as? Double,
            let tierOnePrecent = decoder.decodeObject(forKey: "tierOnePrecent") as? Int,
            let tierTwoPrecent = decoder.decodeObject(forKey: "tierTwoPrecent") as? Int,
            let tierThreePrecent = decoder.decodeObject(forKey: "tierThreePrecent") as? Int,
            let seedPlayist = decoder.decodeObject(forKey: "seedPlayist") as? String?,
            let bumpersPlaylist = decoder.decodeObject(forKey: "bumpersPlaylist") as? String?,
            let bumpersPerBlock = decoder.decodeObject(forKey: "bumpersPerBlock") as? Int?,
            let songsBetweenBlocks = decoder.decodeObject(forKey: "songsBetweenBlocks") as? Int?,
            let rules = decoder.decodeObject(forKey: "rules") as? NSPredicate?
            else { return nil }
        
        self.init(aTotalTime: totalTime, aTierOnePrecent: tierOnePrecent, aTierTwoPrecent: tierTwoPrecent, aTierThreePrecent: tierThreePrecent, aSeedPlaylist: seedPlayist, aBumpersPlaylist: bumpersPlaylist, aBumpersPerBlock: bumpersPerBlock, aSongBetweenBlocks: songsBetweenBlocks, aRules: rules)
    }
    //Encoding fucntion for saving. Encode each object with a key for retervial
    func encodeWithCoder(_ coder: NSCoder) {
        coder.encode(totalTime, forKey: "totalTime")
        coder.encode(tierOnePrecent, forKey: "tierOnePrecent")
        coder.encode(tierTwoPrecent, forKey: "tierTwoPrecent")
        coder.encode(tierThreePrecent, forKey: "tierThreePrecent")
        coder.encode(seedPlayist, forKey: "seedPlayist")
        coder.encode(bumpersPlaylist, forKey: "bumpersPlaylist")
        coder.encode(bumpersPerBlock, forKey: "bumpersPerBlock")
        coder.encode(songsBetweenBlocks, forKey: "songsBetweenBlocks")
        coder.encode(rules, forKey: "rules")
    }
        
    func compare(_ anAutomator: Automator?) -> ComparisonResult {
        if anAutomator == nil {
            return ComparisonResult.orderedDescending
        }
        else{
            return ComparisonResult.orderedSame
        }
}
    
}
