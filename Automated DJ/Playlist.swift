//
//  Playlist.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/24/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

 @objc class Playlist: NSObject {
    
    var ID: Int = 0
    var index: Int = 0
    var name: String = ""
    var persistentID: String = ""
    var duration: Int = 0
    var size: Int = 0
    var time: String = ""
    var visible: Bool = false
    var specialKind: String = ""
    var loved: Bool = false
    var smart: Bool = false
    var shared: Bool = false
    var genius: Bool = false
    
    func initWithString(aString: String) -> Playlist{
        //let myPlaylist = Playlist()
        let mySet = NSCharacterSet.init(charactersInString: "{,}")
        var myPlaylistArray = aString.componentsSeparatedByCharactersInSet(mySet)
        myPlaylistArray.removeFirst()
        myPlaylistArray.removeLast()
        for info in myPlaylistArray {
            let infoParts = info.componentsSeparatedByString(":")
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
            else if infoParts[0].containsString("pDur") {
                duration = Int(infoParts[1])!
            }
            else if infoParts[0].containsString("pSiz") {
                let formatter = NSNumberFormatter()
                formatter.numberStyle = NSNumberFormatterStyle.ScientificStyle
                size = (formatter.numberFromString(infoParts[1])?.integerValue)!
            }
            else if infoParts[0].containsString("pTim") {
                var temp = info.componentsSeparatedByString("\"")
                temp.removeLast()
                time = temp.last!
            }
            else if infoParts[0].containsString("pvis") {
                var temp = infoParts[1].componentsSeparatedByString("\"")
                temp.removeLast()
                visible = temp.last!.toBool()
            }
            else if infoParts[0].containsString("pSpK") {
                if infoParts[1].containsString("kNon") {
                    specialKind = "none"
                }
                else if infoParts[1].containsString("kSpL") {
                    specialKind = "Library"
                }
                else if infoParts[1].containsString("kSpZ") {
                    specialKind = "Music"
                }
                else if infoParts[1].containsString("kSpI") {
                    specialKind = "Movies"
                }
                else if infoParts[1].containsString("kSpT") {
                    specialKind = "TV Shows"
                }
                else if infoParts[1].containsString("kSpP") {
                    specialKind = "Podcasts"
                }
                else if infoParts[1].containsString("kSpU") {
                    specialKind = "iTunes U"
                }
                else if infoParts[1].containsString("kSpA") {
                    specialKind = "Audiobooks"
                }
                else if infoParts[1].containsString("kSpM") {
                    specialKind = "Purchased Music"
                }
                else if infoParts[1].containsString("kSpF") {
                    specialKind = "Folder"
                }
            }
            else if infoParts[0].containsString("pLov") {
                var temp = infoParts[1].componentsSeparatedByString("\"")
                temp.removeLast()
                loved = temp.last!.toBool()
            }
            else if infoParts[0].containsString("pSmt") {
                var temp = infoParts[1].componentsSeparatedByString("\"")
                temp.removeLast()
                smart = temp.last!.toBool()
            }
            else if infoParts[0].containsString("pShr") {
                var temp = infoParts[1].componentsSeparatedByString("\"")
                temp.removeLast()
                shared = temp.last!.toBool()
            }
            else if infoParts[0].containsString("pGns") {
                var temp = infoParts[1].componentsSeparatedByString("\"")
                temp.removeLast()
                genius = temp.last!.toBool()
            }
        }
        return self
    }
    
    static func getPlaylistNames(withTieredPlaylists: Bool, aPlaylistArray: [Playlist]) -> [String]{
        var allNames: [String] = []
        
        for aPlaylist in aPlaylistArray {
            if aPlaylist.specialKind == "none" || aPlaylist.specialKind == "Purchased Music" {
                if aPlaylist.duration > 0 && aPlaylist.name != "Music Videos" && aPlaylist.name != "Home Videos" && aPlaylist.name != "Audiobooks" && aPlaylist.name != "Tier 1" && aPlaylist.name != "Tier 2" && aPlaylist.name != "Tier 3"{
                    allNames.append(aPlaylist.name)
                }
                else if (withTieredPlaylists == true && (aPlaylist.name == "Tier 1" || aPlaylist.name == "Tier 2" || aPlaylist.name == "Tier 3")) {
                    allNames.append(aPlaylist.name)
                }
            }
        }
        
        return allNames
    }

    static func getNewPlaylistDuration(someSongs: [Song]) -> Double{
        var totalDuration = 0.0
        for aSong in someSongs {
            totalDuration = totalDuration + aSong.duration
        }
        return totalDuration
    }
    
}