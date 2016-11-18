//
//  LogGenerator.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 7/2/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class LogGenerator: NSObject {
    //If user has enabled logging, then write the given string to the log
    func writeToLog(_ aString: String){
        let perferencesObject = (NSApplication.shared().delegate as! AppDelegate).PreferencesObject
        if perferencesObject?.useLogs == true {
            let logEntry = aString + "\n"
            let logFile = (perferencesObject?.logFilepath)! + "/Automated DJ log.txt"
            //If a log file exists, then append the logEntry to the log file. If it does not exist, then create a new log file and add the logEntry to it.
            if FileManager.default.fileExists(atPath: logFile) == true {
                let entryAsData = logEntry.data(using: String.Encoding.utf8)
                //NOTE: Filepath stored in preferences only gets the directory the log should reside in. You need to add the filename of the log here.
                let fileHandler = FileHandle.init(forWritingAtPath:logFile)
                fileHandler?.seekToEndOfFile()
                fileHandler?.write(entryAsData!)
                fileHandler?.closeFile()
                }
            else{
                let _ = try? logEntry.write(toFile: logFile, atomically: false, encoding: String.Encoding.utf8)
            }
        }
    }
}
