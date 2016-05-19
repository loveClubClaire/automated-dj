//
//  GlobalAnnouncementsWindow.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/19/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class GlobalAnnoucementsWindow: NSWindow {
    @IBOutlet weak var GlobalAnnouncementsObject: GloablAnnouncements!
    override func keyDown(anEvent: NSEvent) {
        //get the key modifier flags, and use the bitwise and function to remove the machine specific bits. Leaving you with the unadulatrated modiferFlag
        let trueRawModiferFlag = anEvent.modifierFlags.rawValue & NSEventModifierFlags.DeviceIndependentModifierFlagsMask.rawValue
        
        //If the key ModiferFlag equates to the command key being pressed
        if (trueRawModiferFlag == NSEventModifierFlags.CommandKeyMask.rawValue) {
            //If the E key (which has a keyCode of 14) is pressed along with the command key, call the edit function
            if anEvent.keyCode == 14 {
                GlobalAnnouncementsObject.editAnnouncement(self)
            }
        }
            //Else if the delete key (key code 51) is pressed call the delete function
        else if(anEvent.keyCode == 51){
            GlobalAnnouncementsObject.deleteAnnouncements(self)
        }
            //Else just do what would have been expected
        else{
            super.keyDown(anEvent)
        }
    }
}