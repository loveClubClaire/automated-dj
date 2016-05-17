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
    @IBOutlet weak var automatorWindow: NSWindow!
    
    @IBAction func Generate(sender: AnyObject) {
        print(predicateEditor.objectValue?.description)
    }
    func initalize() {
        let resultPredicate = NSPredicate(format: "firstName = '' ")
        
        let firstNameTimpleate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "firstName")], rightExpressionAttributeType: NSAttributeType.StringAttributeType, modifier:  NSComparisonPredicateModifier.DirectPredicateModifier, operators: [NSPredicateOperatorType.EqualToPredicateOperatorType.rawValue,NSPredicateOperatorType .NotEqualToPredicateOperatorType.rawValue], options: 0)
        
        let lastNameTimpleate = NSPredicateEditorRowTemplate.init(leftExpressions: [NSExpression.init(forKeyPath: "lastName")], rightExpressionAttributeType: NSAttributeType.StringAttributeType, modifier:  NSComparisonPredicateModifier.DirectPredicateModifier, operators: [NSPredicateOperatorType.EqualToPredicateOperatorType.rawValue,NSPredicateOperatorType .NotEqualToPredicateOperatorType.rawValue], options: 0)
        
        let array = [firstNameTimpleate,lastNameTimpleate]
        
        print(resultPredicate.predicateFormat)
        
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
        if predicateEditor.numberOfRows < 6 {
            var frame = predicateEditorView.frame
            frame.size.height = CGFloat(predicateEditor.numberOfRows * 25)
            //Const is one row height (25 in this case) added to the origin found in IB
            //frame.origin.y = 93 - CGFloat(predicateEditor.numberOfRows * 25)
            predicateEditorView.frame = frame
            
            let aHeight = CGFloat((predicateEditor.numberOfRows) * 25)
            AutomatorWindowObject.changeWindowSizeBy(aHeight)
        }
    }
}
