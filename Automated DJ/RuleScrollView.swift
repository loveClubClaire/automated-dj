//
//  TestingClass.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 5/16/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import Foundation
import Cocoa



class RuleScrollView: NSObject {
    
    @IBOutlet weak var AutomatorWindowObject: AutomatorWindow!
    @IBOutlet weak var predicateEditor: NSPredicateEditor!
    @IBOutlet weak var predicateEditorView: NSScrollView!
    @IBOutlet weak var matchButton: NSButton!
    @IBOutlet weak var matchLabel: NSTextField!
    @IBOutlet weak var matchPopupButton: NSPopUpButton!
    
    @IBAction func Generate(_ sender: AnyObject) {
        print((predicateEditor.objectValue as AnyObject).description)
    }
    
    func initalize() {
    
        let resultPredicate = NSPredicate(format: "Artist = '' ")
        let stringModifiers = [NSComparisonPredicate.Operator.equalTo.rawValue,NSComparisonPredicate.Operator.notEqualTo.rawValue,NSComparisonPredicate.Operator.beginsWith.rawValue,NSComparisonPredicate.Operator.endsWith.rawValue,NSComparisonPredicate.Operator.contains.rawValue]
        let intModifiers = [NSComparisonPredicate.Operator.equalTo.rawValue,NSComparisonPredicate.Operator.notEqualTo.rawValue,NSComparisonPredicate.Operator.greaterThan.rawValue,NSComparisonPredicate.Operator.lessThan.rawValue]
        
        
        let albumTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Album")], rightExpressionAttributeType: NSAttributeType.stringAttributeType, modifier:  NSComparisonPredicate.Modifier.direct, operators: stringModifiers as [NSNumber], options: 0)
        
        let albumArtistTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Album Artist")], rightExpressionAttributeType: NSAttributeType.stringAttributeType, modifier:  NSComparisonPredicate.Modifier.direct, operators: stringModifiers as [NSNumber], options: 0)
        
        let artistTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Artist")], rightExpressionAttributeType: NSAttributeType.stringAttributeType, modifier:  NSComparisonPredicate.Modifier.direct, operators: stringModifiers as [NSNumber], options: 0)
        
        let categoryTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Category")], rightExpressionAttributeType: NSAttributeType.stringAttributeType, modifier:  NSComparisonPredicate.Modifier.direct, operators: stringModifiers as [NSNumber], options: 0)
        
        let commentsTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Comments")], rightExpressionAttributeType: NSAttributeType.stringAttributeType, modifier:  NSComparisonPredicate.Modifier.direct, operators: stringModifiers as [NSNumber], options: 0)
        
        let composerTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Composer")], rightExpressionAttributeType: NSAttributeType.stringAttributeType, modifier:  NSComparisonPredicate.Modifier.direct, operators: stringModifiers as [NSNumber], options: 0)
        
        let descriptionTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Description")], rightExpressionAttributeType: NSAttributeType.stringAttributeType, modifier:  NSComparisonPredicate.Modifier.direct, operators: stringModifiers as [NSNumber], options: 0)
        
        let genreTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Genre")], rightExpressionAttributeType: NSAttributeType.stringAttributeType, modifier:  NSComparisonPredicate.Modifier.direct, operators: stringModifiers as [NSNumber], options: 0)
        
        let groupingTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Grouping")], rightExpressionAttributeType: NSAttributeType.stringAttributeType, modifier:  NSComparisonPredicate.Modifier.direct, operators: stringModifiers as [NSNumber], options: 0)
        
        let kindTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Kind")], rightExpressionAttributeType: NSAttributeType.stringAttributeType, modifier:  NSComparisonPredicate.Modifier.direct, operators: stringModifiers as [NSNumber], options: 0)
    
        let nameTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Name")], rightExpressionAttributeType: NSAttributeType.stringAttributeType, modifier:  NSComparisonPredicate.Modifier.direct, operators: stringModifiers as [NSNumber], options: 0)
        
        let sortAlbumTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Sort Album")], rightExpressionAttributeType: NSAttributeType.stringAttributeType, modifier:  NSComparisonPredicate.Modifier.direct, operators: stringModifiers as [NSNumber], options: 0)
        
        let sortAlbumArtistTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Sort Album Artist")], rightExpressionAttributeType: NSAttributeType.stringAttributeType, modifier:  NSComparisonPredicate.Modifier.direct, operators: stringModifiers as [NSNumber], options: 0)
        
        let sortArtistTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Sort Artist")], rightExpressionAttributeType: NSAttributeType.stringAttributeType, modifier:  NSComparisonPredicate.Modifier.direct, operators: stringModifiers as [NSNumber], options: 0)
        
        let sortComposerTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Sort Composer")], rightExpressionAttributeType: NSAttributeType.stringAttributeType, modifier:  NSComparisonPredicate.Modifier.direct, operators: stringModifiers as [NSNumber], options: 0)
        
        let sortNameTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Sort Name")], rightExpressionAttributeType: NSAttributeType.stringAttributeType, modifier:  NSComparisonPredicate.Modifier.direct, operators: stringModifiers as [NSNumber], options: 0)
        
        let playsTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Plays")], rightExpressionAttributeType: NSAttributeType.integer64AttributeType, modifier:  NSComparisonPredicate.Modifier.direct, operators: intModifiers as [NSNumber], options: 0)
        
        let timeTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Time")], rightExpressionAttributeType: NSAttributeType.integer64AttributeType, modifier:  NSComparisonPredicate.Modifier.direct, operators: intModifiers as [NSNumber], options: 0)
        
        let yearTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Year")], rightExpressionAttributeType: NSAttributeType.integer64AttributeType, modifier:  NSComparisonPredicate.Modifier.direct, operators: intModifiers as [NSNumber], options: 0)
        
        let array = [albumTemplate,albumArtistTemplate,artistTemplate,categoryTemplate,commentsTemplate,composerTemplate,descriptionTemplate,genreTemplate,groupingTemplate,kindTemplate,nameTemplate,playsTemplate,sortAlbumTemplate,sortAlbumArtistTemplate,sortArtistTemplate,sortComposerTemplate,sortNameTemplate,timeTemplate,yearTemplate]
                
        predicateEditor.rowTemplates = array
        predicateEditor.objectValue = resultPredicate
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didRowsChange),
            name: NSNotification.Name.NSRuleEditorRowsDidChange,
            object: nil)
        
        //This is called because by default the window contains one row in the predicateEditor 
        AutomatorWindowObject.changeWindowSizeBy(25)
        
    }
    
    func didRowsChange(_ notification: Notification){
        //Code for changing the objects above the PredicateEditor to reflect if we are applying one rule or many rules
        if predicateEditor.numberOfRows == 1 {
            matchButton.title = "Match the following rule:"
            matchLabel.isHidden = true
            matchPopupButton.isHidden = true
        }
        else{
            matchButton.title = "Match"
            matchPopupButton.isHidden = false
            matchLabel.isHidden = false
        }
        
        if predicateEditor.numberOfRows < 6 {
            let aHeight = CGFloat((predicateEditor.numberOfRows) * 25)
            AutomatorWindowObject.changeWindowSizeBy(aHeight)
        }
    }
}
