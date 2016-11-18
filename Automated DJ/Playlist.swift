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
    
    func initWithString(_ aString: String) -> Playlist{
        //let myPlaylist = Playlist()
        let mySet = CharacterSet.init(charactersIn: "{,}")
        var myPlaylistArray = aString.components(separatedBy: mySet)
        myPlaylistArray.removeFirst()
        myPlaylistArray.removeLast()
        for info in myPlaylistArray {
            let infoParts = info.components(separatedBy: ":")
            if infoParts[0].contains("ID") {
                ID = Int(infoParts[1])!
            }
            else if infoParts[0].contains("pidx") {
                index = Int(infoParts[1])!
            }
            else if infoParts[0].contains("pnam") {
                var temp = infoParts[1].components(separatedBy: "\"")
                temp.removeLast()
                name = temp.last!
            }
            else if infoParts[0].contains("pPIS") {
                var temp = infoParts[1].components(separatedBy: "\"")
                temp.removeLast()
                persistentID = temp.last!
            }
            else if infoParts[0].contains("pDur") {
                duration = Int(infoParts[1])!
            }
            else if infoParts[0].contains("pSiz") {
                let formatter = NumberFormatter()
                formatter.numberStyle = NumberFormatter.Style.scientific
                size = (formatter.number(from: infoParts[1])?.intValue)!
            }
            else if infoParts[0].contains("pTim") {
                var temp = info.components(separatedBy: "\"")
                temp.removeLast()
                time = temp.last!
            }
            else if infoParts[0].contains("pvis") {
                var temp = infoParts[1].components(separatedBy: "\"")
                temp.removeLast()
                visible = temp.last!.toBool()
            }
            else if infoParts[0].contains("pSpK") {
                if infoParts[1].contains("kNon") {
                    specialKind = "none"
                }
                else if infoParts[1].contains("kSpL") {
                    specialKind = "Library"
                }
                else if infoParts[1].contains("kSpZ") {
                    specialKind = "Music"
                }
                else if infoParts[1].contains("kSpI") {
                    specialKind = "Movies"
                }
                else if infoParts[1].contains("kSpT") {
                    specialKind = "TV Shows"
                }
                else if infoParts[1].contains("kSpP") {
                    specialKind = "Podcasts"
                }
                else if infoParts[1].contains("kSpU") {
                    specialKind = "iTunes U"
                }
                else if infoParts[1].contains("kSpA") {
                    specialKind = "Audiobooks"
                }
                else if infoParts[1].contains("kSpM") {
                    specialKind = "Purchased Music"
                }
                else if infoParts[1].contains("kSpF") {
                    specialKind = "Folder"
                }
            }
            else if infoParts[0].contains("pLov") {
                var temp = infoParts[1].components(separatedBy: "\"")
                temp.removeLast()
                loved = temp.last!.toBool()
            }
            else if infoParts[0].contains("pSmt") {
                var temp = infoParts[1].components(separatedBy: "\"")
                temp.removeLast()
                smart = temp.last!.toBool()
            }
            else if infoParts[0].contains("pShr") {
                var temp = infoParts[1].components(separatedBy: "\"")
                temp.removeLast()
                shared = temp.last!.toBool()
            }
            else if infoParts[0].contains("pGns") {
                var temp = infoParts[1].components(separatedBy: "\"")
                temp.removeLast()
                genius = temp.last!.toBool()
            }
        }
        return self
    }
    
    static func getPlaylistNames(_ withTieredPlaylists: Bool, aPlaylistArray: [Playlist]) -> [String]{
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

    static func getNewPlaylistDuration(_ someSongs: [Song]) -> Double{
        var totalDuration = 0.0
        for aSong in someSongs {
            totalDuration = totalDuration + aSong.duration
        }
        return totalDuration
    }
    
}
