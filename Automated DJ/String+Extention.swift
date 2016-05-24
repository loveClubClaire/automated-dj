//
//  String+Extention.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/24/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation


extension String {
    func toBool() -> Bool {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return false
        }
    }
}