//
//  CustomObjectTests.swift
//  Automated DJ
//
//  Created by Zachary Whitten on 11/22/16.
//  Copyright © 2016 16^2. All rights reserved.
//

import XCTest
@testable import Automated_DJ

class CustomObjectTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
    func testShow(){
        let name = "Test Show"
        //Monday, November 21, 2016 at 8:00 AM
        let startDate = Date.init(timeIntervalSince1970: 1479733200)
        //Monday, November 21, 2016 at 4:00 AM
        let endDate = Date.init(timeIntervalSince1970: 1479762000)
        //Create Show
        let show = Show.init(aName: name, aStartDate: startDate, anEndDate: endDate)
        //Check if obejct was created correctly
        XCTAssertEqual(name, show.name)
        XCTAssertEqual(startDate, show.startDate)
        XCTAssertEqual(endDate, show.endDate)
        //Check if archiving and unarchiving work
        NSKeyedArchiver.archiveRootObject(show, toFile: "archiveTest")
        let newShow = NSKeyedUnarchiver.unarchiveObject(withFile: "archiveTest") as! Show
        XCTAssertEqual(show, newShow)
        //Equality testing
        let anEqualShow = Show.init(aName: "Test Show", aStartDate: startDate, anEndDate: endDate)
        let anUnequalShow = Show.init(aName: "Not A Test Show", aStartDate: startDate, anEndDate: endDate);
        //Shows are equal
        XCTAssertTrue(show.isEqual(anEqualShow))
        //Shows are unequal
        XCTAssertFalse(show.isEqual(anUnequalShow))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
