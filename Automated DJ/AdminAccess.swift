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
    fileprivate func getAdminAccess() -> Bool {
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
}
