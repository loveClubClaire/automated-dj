//
//  NSWindow+Extention.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/26/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa

extension NSWindow {

    func makeDisabled(){
        var subviews = self.contentView?.subviews
        let count = subviews?.count
        
        for _ in 0...count!-1{
            let item = subviews?.popLast()
            if(item!.isKind(of: NSButton.self)){
                (item as! NSButton).isEnabled = false
            }
            if (item!.isKind(of: NSTextField.self)) {
                (item as! NSTextField).isEnabled = false
                (item as! NSTextField).textColor = NSColor.scrollBarColor
            }
            if item!.isKind(of: NSPopUpButton.self) {
                (item as! NSPopUpButton).isEnabled = false
            }
            if item!.isKind(of: NSScrollView.self) {
                (item as! NSScrollView).isHidden = true
            }
            if(item!.isKind(of: NSProgressIndicator.self)){
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
            if(item!.isKind(of: NSButton.self)){
                (item as! NSButton).isEnabled = true
                if item?.identifier == "rulesEnabled" {
                    if (item as! NSButton).state == NSOffState{
                        scrollView!.isHidden = true
                    }
                }
            }
            if (item!.isKind(of: NSTextField.self)) {
                if item?.identifier != "totalTime"{
                    (item as! NSTextField).isEnabled = true
                    (item as! NSTextField).textColor = NSColor.labelColor
                }
            }
            if item!.isKind(of: NSPopUpButton.self) {
                (item as! NSPopUpButton).isEnabled = true
            }
            if item!.isKind(of: NSScrollView.self) {
                scrollView = (item as! NSScrollView)
                (item as! NSScrollView).isHidden = false
            }
            if(item!.isKind(of: NSProgressIndicator.self)){
                (item as! NSProgressIndicator).stopAnimation(self)
            }
        }
    }

    
}
