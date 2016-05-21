//
//  AutomateShowCommand.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/20/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class AutomateShowCommand: NSScriptCommand {
    override func performDefaultImplementation() -> AnyObject? {
        let show = self.evaluatedArguments!["ShowName"] as! String
        debugPrint("We were prompted to automate: \(show)");
        return true
    }
}