//
//  MiniPlayerCover.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 6/28/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation

class MiniPlayerCover: NSObject {
    @IBOutlet weak var MiniPlayerCoverPanel: NSPanel!
    
    
    func enableMiniPlayerCover(){
        
    }
    
    func disableMiniPlayerCover(){
        
    }
    //Make the MiniPlayer cover invisible but still active
    func hideMiniPlayerCover(){
        //Prevents panel from appering in exposé
        MiniPlayerCoverPanel.collectionBehavior = NSWindowCollectionBehavior.Stationary
        //Makes the max and min size of the panel equal to its current size, so the size of the panel can not be modifed when it is hidded
        MiniPlayerCoverPanel.minSize = NSSize.init(width: MiniPlayerCoverPanel.frame.width, height: MiniPlayerCoverPanel.frame.height)
        MiniPlayerCoverPanel.maxSize = NSSize.init(width: MiniPlayerCoverPanel.frame.width, height: MiniPlayerCoverPanel.frame.height)
        //Setting the styleMask to 14 disables the menu bar but allows the panel to still exist (i.e. when clicking, our panel takes the click action, not any object beneith it)
        MiniPlayerCoverPanel.styleMask = 14
        //Make the panel invisible and imovable
        MiniPlayerCoverPanel.opaque = false
        MiniPlayerCoverPanel.backgroundColor = NSColor.clearColor()
        MiniPlayerCoverPanel.movable = false
    }
    //Make the MiniPlayer cover visable and adjustable
    func showMiniPlayerCover(){
        //Allows panel to appear in exposé
        MiniPlayerCoverPanel.collectionBehavior = NSWindowCollectionBehavior.Managed
        //Makes the max and min size of the panel equal to their defaults, so that the window can be adjusted
        MiniPlayerCoverPanel.minSize = NSSize.init(width: 148, height: 44)
        MiniPlayerCoverPanel.maxSize = NSSize.init(width: 400, height: 44)
        //Adds close, minimise, and resize buttons to the window without adding a menu bar
        MiniPlayerCoverPanel.titleVisibility = NSWindowTitleVisibility.Hidden;
        MiniPlayerCoverPanel.styleMask = 15
        MiniPlayerCoverPanel.styleMask |= NSFullSizeContentViewWindowMask;
        MiniPlayerCoverPanel.styleMask |= NSClosableWindowMask
        MiniPlayerCoverPanel.styleMask |= NSMiniaturizableWindowMask
        MiniPlayerCoverPanel.styleMask |= NSResizableWindowMask
        MiniPlayerCoverPanel.titlebarAppearsTransparent = true
        //Makes the panel white, visible, and movable
        MiniPlayerCoverPanel.backgroundColor = NSColor.whiteColor()
        MiniPlayerCoverPanel.opaque = true
        MiniPlayerCoverPanel.movable = true
        MiniPlayerCoverPanel.movableByWindowBackground = true
    }
}