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
    
    @IBAction func Generate(sender: AnyObject) {
        print(predicateEditor.objectValue?.description)
    }
    
    func initalize() {
    
        let resultPredicate = NSPredicate(format: "Album = '' ")
        let stringModifiers = [NSPredicateOperatorType.EqualToPredicateOperatorType.rawValue,NSPredicateOperatorType.NotEqualToPredicateOperatorType.rawValue,NSPredicateOperatorType.BeginsWithPredicateOperatorType.rawValue,NSPredicateOperatorType.EndsWithPredicateOperatorType.rawValue,NSPredicateOperatorType.ContainsPredicateOperatorType.rawValue]
        let intModifiers = [NSPredicateOperatorType.EqualToPredicateOperatorType.rawValue,NSPredicateOperatorType.NotEqualToPredicateOperatorType.rawValue,NSPredicateOperatorType.GreaterThanPredicateOperatorType.rawValue,NSPredicateOperatorType.LessThanPredicateOperatorType.rawValue]
        
        
        let albumTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Album")], rightExpressionAttributeType: NSAttributeType.StringAttributeType, modifier:  NSComparisonPredicateModifier.DirectPredicateModifier, operators: stringModifiers, options: 0)
        
        let albumArtistTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Album Artist")], rightExpressionAttributeType: NSAttributeType.StringAttributeType, modifier:  NSComparisonPredicateModifier.DirectPredicateModifier, operators: stringModifiers, options: 0)
        
        let artistTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Artist")], rightExpressionAttributeType: NSAttributeType.StringAttributeType, modifier:  NSComparisonPredicateModifier.DirectPredicateModifier, operators: stringModifiers, options: 0)
        
        let categoryTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Category")], rightExpressionAttributeType: NSAttributeType.StringAttributeType, modifier:  NSComparisonPredicateModifier.DirectPredicateModifier, operators: stringModifiers, options: 0)
        
        let commentsTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Comments")], rightExpressionAttributeType: NSAttributeType.StringAttributeType, modifier:  NSComparisonPredicateModifier.DirectPredicateModifier, operators: stringModifiers, options: 0)
        
        let composerTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Composer")], rightExpressionAttributeType: NSAttributeType.StringAttributeType, modifier:  NSComparisonPredicateModifier.DirectPredicateModifier, operators: stringModifiers, options: 0)
        
        let descriptionTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Description")], rightExpressionAttributeType: NSAttributeType.StringAttributeType, modifier:  NSComparisonPredicateModifier.DirectPredicateModifier, operators: stringModifiers, options: 0)
        
        let genreTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Genre")], rightExpressionAttributeType: NSAttributeType.StringAttributeType, modifier:  NSComparisonPredicateModifier.DirectPredicateModifier, operators: stringModifiers, options: 0)
        
        let groupingTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Grouping")], rightExpressionAttributeType: NSAttributeType.StringAttributeType, modifier:  NSComparisonPredicateModifier.DirectPredicateModifier, operators: stringModifiers, options: 0)
        
        let kindTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Kind")], rightExpressionAttributeType: NSAttributeType.StringAttributeType, modifier:  NSComparisonPredicateModifier.DirectPredicateModifier, operators: stringModifiers, options: 0)
    
        let nameTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Name")], rightExpressionAttributeType: NSAttributeType.StringAttributeType, modifier:  NSComparisonPredicateModifier.DirectPredicateModifier, operators: stringModifiers, options: 0)
        
        let sortAlbumTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Sort Album")], rightExpressionAttributeType: NSAttributeType.StringAttributeType, modifier:  NSComparisonPredicateModifier.DirectPredicateModifier, operators: stringModifiers, options: 0)
        
        let sortAlbumArtistTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Sort Album Artist")], rightExpressionAttributeType: NSAttributeType.StringAttributeType, modifier:  NSComparisonPredicateModifier.DirectPredicateModifier, operators: stringModifiers, options: 0)
        
        let sortArtistTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Sort Artist")], rightExpressionAttributeType: NSAttributeType.StringAttributeType, modifier:  NSComparisonPredicateModifier.DirectPredicateModifier, operators: stringModifiers, options: 0)
        
        let sortComposerTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Sort Composer")], rightExpressionAttributeType: NSAttributeType.StringAttributeType, modifier:  NSComparisonPredicateModifier.DirectPredicateModifier, operators: stringModifiers, options: 0)
        
        let sortNameTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Sort Name")], rightExpressionAttributeType: NSAttributeType.StringAttributeType, modifier:  NSComparisonPredicateModifier.DirectPredicateModifier, operators: stringModifiers, options: 0)
        
        let playsTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Plays")], rightExpressionAttributeType: NSAttributeType.Integer64AttributeType, modifier:  NSComparisonPredicateModifier.DirectPredicateModifier, operators: intModifiers, options: 0)
        
        let timeTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Time")], rightExpressionAttributeType: NSAttributeType.Integer64AttributeType, modifier:  NSComparisonPredicateModifier.DirectPredicateModifier, operators: intModifiers, options: 0)
        
        let yearTemplate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "Year")], rightExpressionAttributeType: NSAttributeType.Integer64AttributeType, modifier:  NSComparisonPredicateModifier.DirectPredicateModifier, operators: intModifiers, options: 0)
        
        let array = [albumTemplate,albumArtistTemplate,artistTemplate,categoryTemplate,commentsTemplate,composerTemplate,descriptionTemplate,genreTemplate,groupingTemplate,kindTemplate,nameTemplate,playsTemplate,sortAlbumTemplate,sortAlbumArtistTemplate,sortArtistTemplate,sortComposerTemplate,sortNameTemplate,timeTemplate,yearTemplate]
                
        predicateEditor.rowTemplates = array
        predicateEditor.objectValue = resultPredicate
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(didRowsChange),
            name: NSRuleEditorRowsDidChangeNotification,
            object: nil)
        
        //This is called because by default the window contains one row in the predicateEditor 
        AutomatorWindowObject.changeWindowSizeBy(25)
        
    }
    
    func didRowsChange(notification: NSNotification){
        //Code for changing the objects above the PredicateEditor to reflect if we are applying one rule or many rules
        if predicateEditor.numberOfRows == 1 {
            matchButton.title = "Match the following rule:"
            matchLabel.hidden = true
            matchPopupButton.hidden = true
        }
        else{
            matchButton.title = "Match"
            matchPopupButton.hidden = false
            matchLabel.hidden = false
        }
        
        if predicateEditor.numberOfRows < 6 {
            let aHeight = CGFloat((predicateEditor.numberOfRows) * 25)
            AutomatorWindowObject.changeWindowSizeBy(aHeight)
        }
    }
}
