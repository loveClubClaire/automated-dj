//
//  NSWindow+Extention.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/26/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation

extension NSWindow {

    func makeDisabled(){
        var subviews = self.contentView?.subviews
        let count = subviews?.count
        
        for _ in 0...count!-1{
            let item = subviews?.popLast()
            if(item!.isKindOfClass(NSButton)){
                (item as! NSButton).enabled = false
            }
            if (item!.isKindOfClass(NSTextField)) {
                (item as! NSTextField).enabled = false
                (item as! NSTextField).textColor = NSColor.scrollBarColor()
            }
            if item!.isKindOfClass(NSPopUpButton) {
                (item as! NSPopUpButton).enabled = false
            }
            if item!.isKindOfClass(NSScrollView) {
                (item as! NSScrollView).hidden = true
            }
            if(item!.isKindOfClass(NSProgressIndicator)){
                (item as! NSProgressIndicator).startAnimation(self)
            }
        }
    }
    
    func makeEnabled(){
        var subviews = self.contentView?.subviews
        let count = subviews?.count
        var scrollView: NSScrollView?
        
        for _ in 0...count!-1{
            let item = subviews?.popLast()
            if(item!.isKindOfClass(NSButton)){
                (item as! NSButton).enabled = true
                if item?.identifier == "rulesEnabled" {
                    if (item as! NSButton).state == NSOffState{
                        scrollView!.hidden = true
                    }
                }
            }
            if (item!.isKindOfClass(NSTextField)) {
                if item?.identifier != "totalTime"{
                    (item as! NSTextField).enabled = true
                    (item as! NSTextField).textColor = NSColor.labelColor()
                }
            }
            if item!.isKindOfClass(NSPopUpButton) {
                (item as! NSPopUpButton).enabled = true
            }
            if item!.isKindOfClass(NSScrollView) {
                scrollView = (item as! NSScrollView)
                (item as! NSScrollView).hidden = false
            }
            if(item!.isKindOfClass(NSProgressIndicator)){
                (item as! NSProgressIndicator).stopAnimation(self)
            }
        }
    }

    
}