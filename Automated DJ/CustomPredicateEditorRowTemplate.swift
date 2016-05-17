//
//  CustomPredicateEditorRowTemplate.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/17/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

class CustomPredicateEditorRowTemplate: NSPredicateEditorRowTemplate {
    
    override var templateViews: [NSView]{
        get {
            var views = super.templateViews
            print(views)
            return views
        }
        
    }
    
}