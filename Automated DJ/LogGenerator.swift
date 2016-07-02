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
    @IBOutlet weak var PreferencesObject: Preferences!
    
    //If user has enabled logging, then write the given string to the log
    func writeToLog(aString: String){
        if PreferencesObject.useLogs == true {
            let logEntry = aString + "\n"
            let logFile = PreferencesObject.logFilepath + "/log.txt"
            //If a log file exists, then append the logEntry to the log file. If it does not exist, then create a new log file and add the logEntry to it.
            if NSFileManager.defaultManager().fileExistsAtPath(logFile) == true {
                let entryAsData = logEntry.dataUsingEncoding(NSUTF8StringEncoding)
                //NOTE: Filepath stored in preferences only gets the directory the log should reside in. You need to add the filename of the log here.
                let fileHandler = NSFileHandle.init(forWritingAtPath:logFile)
                fileHandler?.seekToEndOfFile()
                fileHandler?.writeData(entryAsData!)
                fileHandler?.closeFile()
                }
            else{
                let _ = try? logEntry.writeToFile(logFile, atomically: false, encoding: NSUTF8StringEncoding)
            }
        }
    }
}