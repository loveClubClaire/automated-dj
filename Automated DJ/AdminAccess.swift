//
//  AdminAccess.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/20/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class AdminAccess: NSObject {
    @IBOutlet weak var PreferencesObject: Preferences!
    @IBOutlet weak var PasswordWindow: NSWindow!
    @IBOutlet weak var NewPasswordWindow: NSWindow!
    @IBOutlet weak var PasswordTextField: NSSecureTextField!
    @IBOutlet weak var NewPasswordTextField: NSSecureTextField!
    @IBOutlet weak var RepeatNewPasswordTextField: NSSecureTextField!
    @IBOutlet weak var requireAdmin: NSButton!
    
    let passwordGroup = DispatchGroup()
    var resultOK = false
    var isNew = false
    var adminPasswordFilepath = ""
    
    func isAuthorized() -> Bool {
        //If application preferences "requires admin access" is turned off, then authorization is automatic. If its turned on, then we make a call to getAdminAccess which forces the user to enter in the admin password for the system. If its a valid password, then authorization is given.
        var toReturn = false
        if PreferencesObject.isAdmin == false {
            toReturn = true
        }
        else{
            toReturn = getAdminAccess()
        }
        return toReturn
    }
    
    fileprivate func getAdminAccess() -> Bool {
        let applicationSupportFilepath = try! FileManager().url(for: FileManager.SearchPathDirectory.applicationSupportDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        if(applicationSupportFilepath.absoluteString.contains("com.sixteensquared.Automated-DJ")){
            return automatedDJAdminAccess()
        }
        else{
            return macOSAdminAccess()
        }
    }
    
    fileprivate func macOSAdminAccess() -> Bool {
        var result = false;
        var authRef: AuthorizationRef? = nil
        var myStatus = AuthorizationCreate(nil, nil, AuthorizationFlags(), &authRef)
        var right = AuthorizationItem.init(name: kAuthorizationRightExecute, valueLength: 0, value: nil, flags: 0)
        var rights = AuthorizationRights.init(count: 1, items: &right)
        //The AuthorizationFlags.DestroyRights flag is what forces the system to ask for an admin password EACH time this function is called. Prevents a sucessful authorization from being remembered
        let flags = AuthorizationFlags(rawValue: AuthorizationFlags().rawValue |  AuthorizationFlags.interactionAllowed.rawValue | AuthorizationFlags.extendRights.rawValue | AuthorizationFlags.destroyRights.rawValue)
        //Call AuthorizationCopyRights to determine or extend the allowable rights.
        myStatus = AuthorizationCopyRights(authRef!, &rights, nil, flags, nil)
        if myStatus == errAuthorizationSuccess {
            result = true
        }
        return result
    }
    
    fileprivate func automatedDJAdminAccess() -> Bool{
        let applicationSupportFilepath = try! FileManager().url(for: FileManager.SearchPathDirectory.applicationSupportDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        let storedDataFilepath = applicationSupportFilepath.path + "/Automated DJ"
        if(FileManager().fileExists(atPath: storedDataFilepath) == false){
            try! FileManager().createDirectory(atPath: storedDataFilepath, withIntermediateDirectories:false, attributes: nil)
        }
        adminPasswordFilepath = storedDataFilepath + "/sysdata.txt"
        
        passwordGroup.enter()
        NSApplication.shared().activate(ignoringOtherApps: true)
        PasswordWindow.center()
        PasswordWindow.makeKeyAndOrderFront(self)
        NSApp.runModal(for: PasswordWindow)
      
        //Wait for the dispatch group is empty, then execute code in the block
        passwordGroup.wait()
        let result = self.resultOK
        self.resultOK = false
        return result
    }
    
    @IBAction func requireAdmin(_ sender: Any) {
        //When the require Administrator Privilages check box is checked this function is called. If the button is being turned on, the function checks to see if a password exists. If one does not, then a request is made to set one. If the button is being turned on while the command key is pressed, then a request to set one is called. This is the only way to reset the admin password
        if requireAdmin.state == 1 {
            let applicationSupportFilepath = try! FileManager().url(for: FileManager.SearchPathDirectory.applicationSupportDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
            if(applicationSupportFilepath.absoluteString.contains("com.sixteensquared.Automated-DJ")){
                let applicationSupportFilepath = try! FileManager().url(for: FileManager.SearchPathDirectory.applicationSupportDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
                let storedDataFilepath = applicationSupportFilepath.path + "/Automated DJ"
                if(FileManager().fileExists(atPath: storedDataFilepath) == false){
                    try! FileManager().createDirectory(atPath: storedDataFilepath, withIntermediateDirectories:false, attributes: nil)
                }
                adminPasswordFilepath = storedDataFilepath + "/sysdata.txt"
                //Get the information stored in file at the adminPasswordFilepath. If its empty (or non existant), bring up the new password window
                let hashedPassword = NSKeyedUnarchiver.unarchiveObject(withFile: adminPasswordFilepath)
                //Get the current event (the currently pressed down keys)
                let currentEvent = NSApplication.shared().currentEvent
                //get the key modifier flags, and use the bitwise and function to remove the machine specific bits. Leaving you with the unadulatrated modiferFlag
                let trueRawModiferFlag = (currentEvent?.modifierFlags.rawValue)! & NSEventModifierFlags.deviceIndependentFlagsMask.rawValue
                //If the key ModiferFlag equates to the command key being pressed or there is no hashedPassword
                if hashedPassword == nil || trueRawModiferFlag == NSEventModifierFlags.command.rawValue{
                    NewPasswordWindow.center()
                    NewPasswordWindow.makeKeyAndOrderFront(self)
                    NSApp.runModal(for: NewPasswordWindow)
                }
            }
        }
    }
    @IBAction func newPasswordOk(_ sender: Any) {
        if(NewPasswordTextField.stringValue == RepeatNewPasswordTextField.stringValue){
            let hashed = sha256(string: NewPasswordTextField.stringValue)
            NSKeyedArchiver.archiveRootObject(hashed!, toFile: adminPasswordFilepath)
            NewPasswordWindow.orderOut(self)
            cancelNewPassword(self)
            requireAdmin.state = 1
            NSApp.stopModal()
        }
        else{
            let myPopup: NSAlert = NSAlert()
            myPopup.alertStyle = NSAlertStyle.critical
            myPopup.addButton(withTitle: "OK")
            myPopup.messageText = "Passwords must match!"
            myPopup.runModal()
        }
    }
    @IBAction func cancelNewPassword(_ sender: Any) {
        requireAdmin.state = 0
        NewPasswordWindow.orderOut(self)
        NewPasswordTextField.stringValue = ""
        NewPasswordTextField.selectText(self)
        RepeatNewPasswordTextField.stringValue = ""
        NSApp.stopModal()
    }
    @IBAction func passwordOk(_ sender: Any) {
        let savedPassword = NSKeyedUnarchiver.unarchiveObject(withFile: adminPasswordFilepath) as! Data
        let passwordAttempt = sha256(string: PasswordTextField.stringValue)
        
        if (savedPassword == passwordAttempt) {
            resultOK = true
            cancelPassword(self)
        }
        else{
            let numberOfShakes:Int = 4
            let durationOfShake:Float = 0.5
            let vigourOfShake:Float = 0.02
            
            let frame:CGRect = (PasswordWindow.frame)
            let shakeAnimation = CAKeyframeAnimation()
            
            let shakePath = CGMutablePath()
            shakePath.move(to: CGPoint(x: NSMinX(frame), y: NSMinY(frame)))
            
            for _ in 1...numberOfShakes {
                shakePath.addLine(to: CGPoint(x:NSMinX(frame) - frame.size.width * CGFloat(vigourOfShake), y: NSMinY(frame)))
                shakePath.addLine(to: CGPoint(x:NSMinX(frame) + frame.size.width * CGFloat(vigourOfShake), y: NSMinY(frame)))
            }
            
            shakePath.closeSubpath()
            shakeAnimation.path = shakePath
            shakeAnimation.duration = CFTimeInterval(durationOfShake)
            PasswordWindow.animations = ["frameOrigin":shakeAnimation]
            PasswordWindow.animator().setFrameOrigin((PasswordWindow.frame.origin))
            PasswordTextField.selectText(self)
        }
        
        
    }
    @IBAction func cancelPassword(_ sender: Any) {
        PasswordWindow.orderOut(self)
        NSApp.stopModal()
        PasswordTextField.stringValue = ""
        passwordGroup.leave()
    }
    
    func sha256(string: String) -> Data? {
        guard let messageData = string.data(using:String.Encoding.utf8) else { return nil }
        var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_SHA256(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData
    }
}
