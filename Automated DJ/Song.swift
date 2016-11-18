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
    func initWithString(_ aString: String) -> Song{
        let mySet = CharacterSet.init(charactersIn: "{,}")
        var myPlaylistArray = aString.components(separatedBy: mySet)
        myPlaylistArray.removeFirst()
        myPlaylistArray.removeLast()
        
        var index = 0
        var broken = false
        //This while loop reconstructs strings broken up because they contained a , We do this so we can properly set the values property
        //Yes, to support { and } chars in user defined properties, this code would need to be rewritten. This is the location of your bug :p
        while index < myPlaylistArray.count {
            if matchesForRegexInText(" \'[a-zA-Z\\s]{4}\':", text: myPlaylistArray[index]) == true {
                broken = false
            }
            if broken == true {
                myPlaylistArray[index-1] = myPlaylistArray[index-1] + "," + myPlaylistArray[index]
                myPlaylistArray.remove(at: index)

            }
            if matchesForRegexInText(" \'[a-zA-Z\\s]{4}\':", text: myPlaylistArray[index]) == false {
                broken = true
                index = index - 1
            }
            index = index + 1
        }
        
        for info in myPlaylistArray {
            var infoParts = info.components(separatedBy: ":")
            //Replaces lost : chars for all paramaters which could have extra : chars. (So user defined params)
            if infoParts[0].contains("pnam") || infoParts[0].contains("pArt") || infoParts[0].contains("pAlA") || infoParts[0].contains("pCmp") || infoParts[0].contains("pAlb") || infoParts[0].contains("pGen") || infoParts[0].contains("pCmt") || infoParts[0].contains("pAnt") || infoParts[0].contains("pLyr") || infoParts[0].contains("pCat") || infoParts[0].contains("pDes") || infoParts[0].contains("pSNm") || infoParts[0].contains("pSAl") || infoParts[0].contains("pSAr") || infoParts[0].contains("pSCm") || infoParts[0].contains("pSAA") {
                while infoParts.count > 2 {
                    let temp = infoParts.popLast()
                    infoParts.append(infoParts.popLast()! + ":" + temp!)
                }
            }

            switch infoParts[0] {
            case let x where x.contains("ID"):
                ID = Int(infoParts[1])!
            case let x where x.contains("pidx"):
                index = Int(infoParts[1])!
            case let x where x.contains("pnam"):
                var temp = infoParts[1].components(separatedBy: "\"")
                temp.removeLast()
                name = temp.last!
            case let x where x.contains("pPIS"):
                var temp = infoParts[1].components(separatedBy: "\"")
                temp.removeLast()
                persistentID = temp.last!
            case let x where x.contains("pDID"):
                databaseID = Int(infoParts[1])!
            case let x where x.contains("pTim"):
                var temp = info.components(separatedBy: "\"")
                temp.removeLast()
                time = temp.last!
            case let x where x.contains("pDur"):
                duration = Double(infoParts[1])!
            case let x where x.contains("pArt"):
                var temp = info.components(separatedBy: "\"")
                temp.removeLast()
                artist = temp.last!
            case let x where x.contains("pAlA"):
                var temp = info.components(separatedBy: "\"")
                temp.removeLast()
                albumArtist = temp.last!
            case let x where x.contains("pCmp"):
                var temp = info.components(separatedBy: "\"")
                temp.removeLast()
                composer = temp.last!
            case let x where x.contains("pAlb"):
                var temp = info.components(separatedBy: "\"")
                temp.removeLast()
                album = temp.last!
            case let x where x.contains("pGen"):
                var temp = info.components(separatedBy: "\"")
                temp.removeLast()
                genre = temp.last!
            case let x where x.contains("pBRt"):
                bitRate = Int(infoParts[1])!
            case let x where x.contains("pSRT"):
                sampleRate = Int(infoParts[1])!
            case let x where x.contains("pTrC"):
                trackCount = Int(infoParts[1])!
            case let x where x.contains("pTrN"):
                trackNumber = Int(infoParts[1])!
            case let x where x.contains("pDsC"):
                discCount = Int(infoParts[1])!
            case let x where x.contains("pDsN"):
                discNumber = Int(infoParts[1])!
            case let x where x.contains("pSiz"):
                let formatter = NumberFormatter()
                formatter.numberStyle = NumberFormatter.Style.scientific
                size = (formatter.number(from: infoParts[1])?.intValue)!
            case let x where x.contains("pAdj"):
                volumeAdjustment = Int(infoParts[1])!
            case let x where x.contains("pYr"):
                year = Int(infoParts[1])!
            case let x where x.contains("pCmt"):
                var temp = info.components(separatedBy: "\"")
                temp.removeLast()
                comment = temp.last!
            case let x where x.contains("pEQp"):
                var temp = info.components(separatedBy: "\"")
                temp.removeLast()
                eq = temp.last!
            case let x where x.contains("pKnd"):
                var temp = info.components(separatedBy: "\"")
                temp.removeLast()
                kind = temp.last!
            case let x where x.contains("pMdk"):
                //No this is not complete. I just dont need anything other than music tracks
                if infoParts[1].contains("kMdS") {
                    mediaKind = "music"
                }
                else {
                    mediaKind = "none"
                }
            case let x where x.contains("enbl"):
                var temp = infoParts[1].components(separatedBy: "\"")
                temp.removeLast()
                enabled = temp.last!.toBool()
            case let x where x.contains("pStr"):
                start = Double(infoParts[1])!
            case let x where x.contains("pStp"):
                end = Double(infoParts[1])!
            case let x where x.contains("pPLC"):
                playCount = Int(infoParts[1])!
            case let x where x.contains("pAnt"):
                var temp = infoParts[1].components(separatedBy: "\"")
                temp.removeLast()
                compilation = temp.last!.toBool()
            case let x where x.contains("pRte"):
                rating = Int(infoParts[1])!
            case let x where x.contains("pBPM"):
                bpm = Int(infoParts[1])!
            case let x where x.contains("pGrp"):
                var temp = info.components(separatedBy: "\"")
                temp.removeLast()
                grouping = temp.last!
            case let x where x.contains("pLyr"):
                var temp = info.components(separatedBy: "\"")
                temp.removeLast()
                lyrics = temp.last!
            case let x where x.contains("pCat"):
                var temp = info.components(separatedBy: "\"")
                temp.removeLast()
                category = temp.last!
            case let x where x.contains("pDes"):
                var temp = info.components(separatedBy: "\"")
                temp.removeLast()
                songDescription = temp.last!
            case let x where x.contains("pSNm"):
                var temp = info.components(separatedBy: "\"")
                temp.removeLast()
                sortName = temp.last!
            case let x where x.contains("pSAl"):
                var temp = info.components(separatedBy: "\"")
                temp.removeLast()
                sortAlbum = temp.last!
            case let x where x.contains("pSAr"):
                var temp = info.components(separatedBy: "\"")
                temp.removeLast()
                sortArtist = temp.last!
            case let x where x.contains("pSCm"):
                var temp = info.components(separatedBy: "\"")
                temp.removeLast()
                sortComposer = temp.last!
            case let x where x.contains("pSAA"):
                var temp = info.components(separatedBy: "\"")
                temp.removeLast()
                sortAlbumArtist = temp.last!
            case let x where x.contains("pLov"):
                var temp = infoParts[1].components(separatedBy: "\"")
                temp.removeLast()
                loved = temp.last!.toBool()
            case let x where x.contains("pALv"):
                var temp = infoParts[1].components(separatedBy: "\"")
                temp.removeLast()
                albumLoved = temp.last!.toBool()
            default: break
            }
        }
        return self
    }
    
    //Converts the keys found in the NSRuleEditor to their proper key values. NSRuleEditor stores incorrect keys because those keys are displayed to the user, so they include things like spaces.
    override func value(forKey key: String) -> Any? {
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
        
        return super.value(forKey: newKey)
    }
    
    //Receives a string and a regular expression. If the regular expression is contained in the string at least once, return true. Otherwise return false.
    func matchesForRegexInText(_ regex: String!, text: String!) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            var resultsArray = [String]()
            autoreleasepool {
                let results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
                resultsArray = results.map { nsString.substring(with: $0.range)}
            }
            if resultsArray.count > 0 {return true}
            else{return false}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return false
        }
    }
    
    static func idSetFrom(_ anArray: [Song]) -> Set<String> {
        var newArray = [String]()
        for song in anArray {
            newArray.append(song.persistentID)
        }
        return Set(newArray)
    }
    
    override var description: String {
        return name + " by " + artist + " on " + album
    }
    
}
