//
//  Song.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/24/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

@objc class Song: NSObject {
    
    var ID: Int = 0
    var index: Int = 0
    var name: String = ""
    var persistentID: String = ""
    var databaseID: Int = 0
    var time: String = ""
    var duration: Double = 0.0
    var artist: String = ""
    var albumArtist: String = ""
    var composer: String = ""
    var album: String = ""
    var genre: String = ""
    var bitRate: Int = 0
    var sampleRate: Int = 0
    var trackCount: Int = 0
    var trackNumber: Int = 0
    var discCount: Int = 0
    var discNumber: Int = 0
    var size: Int = 0
    var volumeAdjustment: Int = 0
    var year: Int = 0
    var comment: String = ""
    var eq: String = ""
    var kind: String = ""
    var mediaKind: String = ""
    var enabled: Bool = false
    var start: Double = 0.0
    var end: Double = 0.0
    var playCount: Int = 0
    var compilation: Bool = false
    var rating: Int = 0
    var bpm: Int = 0
    var grouping: String = ""
    var lyrics: String = ""
    var category: String = ""
    var songDescription: String = ""
    var sortName: String = ""
    var sortAlbum: String = ""
    var sortArtist: String = ""
    var sortComposer: String = ""
    var sortAlbumArtist: String = ""
    var loved: Bool = false
    var albumLoved: Bool = false

    
    //Function could potencialy be sped up by using a switch statment rather than a chain of if else  
    func initWithString(aString: String) -> Song{
        let mySet = NSCharacterSet.init(charactersInString: "{,}")
        var myPlaylistArray = aString.componentsSeparatedByCharactersInSet(mySet)
        myPlaylistArray.removeFirst()
        myPlaylistArray.removeLast()
        
        var index = 0
        var broken = false
        //This while loop reconstructs strings broken up because they contained a , We do this so we can properly set the values property
        while index < myPlaylistArray.count {
            if matchesForRegexInText(" \'[a-zA-Z\\s]{4}\':", text: myPlaylistArray[index]) == true {
                broken = false
            }
            if broken == true {
                myPlaylistArray[index-1] = myPlaylistArray[index-1] + "," + myPlaylistArray[index]
                myPlaylistArray.removeAtIndex(index)

            }
            if matchesForRegexInText(" \'[a-zA-Z\\s]{4}\':", text: myPlaylistArray[index]) == false {
                broken = true
                index = index - 1
            }
            index = index + 1
        }
        
        for info in myPlaylistArray {
            var infoParts = info.componentsSeparatedByString(":")
            //Replaces lost : chars for all paramaters which could have extra : chars. (So user defined params)
            if infoParts[0].containsString("pnam") || infoParts[0].containsString("pArt") || infoParts[0].containsString("pAlA") || infoParts[0].containsString("pCmp") || infoParts[0].containsString("pAlb") || infoParts[0].containsString("pGen") || infoParts[0].containsString("pCmt") || infoParts[0].containsString("pAnt") || infoParts[0].containsString("pLyr") || infoParts[0].containsString("pCat") || infoParts[0].containsString("pDes") || infoParts[0].containsString("pSNm") || infoParts[0].containsString("pSAl") || infoParts[0].containsString("pSAr") || infoParts[0].containsString("pSCm") || infoParts[0].containsString("pSAA") {
                while infoParts.count > 2 {
                    let temp = infoParts.popLast()
                    infoParts.append(infoParts.popLast()! + ":" + temp!)
                }
            }
            
            if infoParts[0].containsString("ID") {
                ID = Int(infoParts[1])!
            }
            else if infoParts[0].containsString("pidx") {
                index = Int(infoParts[1])!
            }
            else if infoParts[0].containsString("pnam") {
                var temp = infoParts[1].componentsSeparatedByString("\"")
                temp.removeLast()
                name = temp.last!
            }
            else if infoParts[0].containsString("pPIS") {
                var temp = infoParts[1].componentsSeparatedByString("\"")
                temp.removeLast()
                persistentID = temp.last!
            }
            else if infoParts[0].containsString("pDID") {
                databaseID = Int(infoParts[1])!
            }
            else if infoParts[0].containsString("pTim") {
                var temp = info.componentsSeparatedByString("\"")
                temp.removeLast()
                time = temp.last!
            }
            else if infoParts[0].containsString("pDur") {
                duration = Double(infoParts[1])!
            }
            else if infoParts[0].containsString("pArt") {
                var temp = info.componentsSeparatedByString("\"")
                temp.removeLast()
                artist = temp.last!
            }
            else if infoParts[0].containsString("pAlA") {
                var temp = info.componentsSeparatedByString("\"")
                temp.removeLast()
                albumArtist = temp.last!
            }
            else if infoParts[0].containsString("pCmp") {
                var temp = info.componentsSeparatedByString("\"")
                temp.removeLast()
                composer = temp.last!
            }
            else if infoParts[0].containsString("pAlb") {
                var temp = info.componentsSeparatedByString("\"")
                temp.removeLast()
                album = temp.last!
            }
            else if infoParts[0].containsString("pGen") {
                var temp = info.componentsSeparatedByString("\"")
                temp.removeLast()
                genre = temp.last!
            }
            else if infoParts[0].containsString("pBRt") {
                bitRate = Int(infoParts[1])!
            }
            else if infoParts[0].containsString("pSRT") {
                sampleRate = Int(infoParts[1])!
            }
            else if infoParts[0].containsString("pTrC") {
                trackCount = Int(infoParts[1])!
            }
            else if infoParts[0].containsString("pTrN") {
                trackNumber = Int(infoParts[1])!
            }
            else if infoParts[0].containsString("pDsC") {
                discCount = Int(infoParts[1])!
            }
            else if infoParts[0].containsString("pDsN") {
                discNumber = Int(infoParts[1])!
            }
            else if infoParts[0].containsString("pSiz") {
                let formatter = NSNumberFormatter()
                formatter.numberStyle = NSNumberFormatterStyle.ScientificStyle
                size = (formatter.numberFromString(infoParts[1])?.integerValue)!
            }
            else if infoParts[0].containsString("pAdj") {
                volumeAdjustment = Int(infoParts[1])!
            }
            else if infoParts[0].containsString("pYr") {
                year = Int(infoParts[1])!
            }
            else if infoParts[0].containsString("pCmt") {
                var temp = info.componentsSeparatedByString("\"")
                temp.removeLast()
                comment = temp.last!
            }
            else if infoParts[0].containsString("pEQp") {
                var temp = info.componentsSeparatedByString("\"")
                temp.removeLast()
                eq = temp.last!
            }
            else if infoParts[0].containsString("pKnd") {
                var temp = info.componentsSeparatedByString("\"")
                temp.removeLast()
                kind = temp.last!
            }
            else if infoParts[0].containsString("pMdk") {
                //No this is not complete. I just dont need anything other than music tracks
                if infoParts[1].containsString("kMdS") {
                    mediaKind = "music"
                }
                else {
                    mediaKind = "none"
                }
            }
            else if infoParts[0].containsString("enbl") {
                var temp = infoParts[1].componentsSeparatedByString("\"")
                temp.removeLast()
                enabled = temp.last!.toBool()
            }
            else if infoParts[0].containsString("pStr") {
                start = Double(infoParts[1])!
            }
            else if infoParts[0].containsString("pStp") {
                end = Double(infoParts[1])!
            }
            else if infoParts[0].containsString("pPLC") {
                playCount = Int(infoParts[1])!
            }
            else if infoParts[0].containsString("pAnt") {
                var temp = infoParts[1].componentsSeparatedByString("\"")
                temp.removeLast()
                compilation = temp.last!.toBool()
            }
            else if infoParts[0].containsString("pRte") {
                rating = Int(infoParts[1])!
            }
            else if infoParts[0].containsString("pBPM") {
                bpm = Int(infoParts[1])!
            }
            else if infoParts[0].containsString("pGrp") {
                var temp = info.componentsSeparatedByString("\"")
                temp.removeLast()
                grouping = temp.last!
            }
            else if infoParts[0].containsString("pLyr") {
                var temp = info.componentsSeparatedByString("\"")
                temp.removeLast()
                lyrics = temp.last!
            }
            else if infoParts[0].containsString("pCat") {
                var temp = info.componentsSeparatedByString("\"")
                temp.removeLast()
                category = temp.last!
            }
            else if infoParts[0].containsString("pDes") {
                var temp = info.componentsSeparatedByString("\"")
                temp.removeLast()
                songDescription = temp.last!
            }
            else if infoParts[0].containsString("pSNm") {
                var temp = info.componentsSeparatedByString("\"")
                temp.removeLast()
                sortName = temp.last!
            }
            else if infoParts[0].containsString("pSAl") {
                var temp = info.componentsSeparatedByString("\"")
                temp.removeLast()
                sortAlbum = temp.last!
            }
            else if infoParts[0].containsString("pSAr") {
                var temp = info.componentsSeparatedByString("\"")
                temp.removeLast()
                sortArtist = temp.last!
            }
            else if infoParts[0].containsString("pSCm") {
                var temp = info.componentsSeparatedByString("\"")
                temp.removeLast()
                sortComposer = temp.last!
            }
            else if infoParts[0].containsString("pSAA") {
                var temp = info.componentsSeparatedByString("\"")
                temp.removeLast()
                sortAlbumArtist = temp.last!
            }
            else if infoParts[0].containsString("pLov") {
                var temp = infoParts[1].componentsSeparatedByString("\"")
                temp.removeLast()
                loved = temp.last!.toBool()
            }
            else if infoParts[0].containsString("pALv") {
                var temp = infoParts[1].componentsSeparatedByString("\"")
                temp.removeLast()
                albumLoved = temp.last!.toBool()
            }
        }
        
        return self
    }
    
    //Converts the keys found in the NSRuleEditor to their proper key values. NSRuleEditor stores incorrect keys because those keys are displayed to the user, so they include things like spaces.
    override func valueForKey(key: String) -> AnyObject? {
        var newKey = ""
        
        switch key {
        case "Album":
            newKey = "album"
        case "Album Artist":
            newKey = "albumArtist"
        case "Artist":
            newKey = "artist"
        case "Category":
            newKey = "category"
        case "Comments":
            newKey = "comment"
        case "Composer":
            newKey = "composer"
        case "Description":
            newKey = "description"
        case "Genre":
            newKey = "genre"
        case "Grouping":
            newKey = "grouping"
        case "Kind":
            newKey = "kind"
        case "Name":
            newKey = "name"
        case "Sort Album":
            newKey = "sortAlbum"
        case "Sort Album Artist":
            newKey = "sortAlbumArtist"
        case "Sort Artist":
            newKey = "sortArtist"
        case "Sort Composer":
            newKey = "sortComposer"
        case "Sort Name":
            newKey = "sortName"
        case "Plays":
            newKey = "playCount"
        case "Time":
            newKey = "time"
        case "Year":
            newKey = "year"
        default:
            newKey = key
        }
        
        return super.valueForKey(newKey)
    }
    
    //Receives a string and a regular expression. If the regular expression is contained in the string at least once, return true. Otherwise return false.
    func matchesForRegexInText(regex: String!, text: String!) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            let results = regex.matchesInString(text, options: [], range: NSMakeRange(0, nsString.length))
            let resultsArray = results.map { nsString.substringWithRange($0.range)}
            if resultsArray.count > 0 {return true}
            else{return false}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return false
        }
    }
    
    override var description: String {
        return name + " by " + artist + " on " + album
    }
}