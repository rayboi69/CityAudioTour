//
//  CustomRouteTests.swift
//  CityAudioTour
//
//  Created by Red_iMac on 4/18/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit
import XCTest
import CityAudioTour

class CustomRouteTests: XCTestCase {

    var viewController: SelectAttractionsTableViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        viewController = storyboard.instantiateViewControllerWithIdentifier("SelectAttractionsViewController") as! SelectAttractionsTableViewController
        viewController.loadView()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }

    func testViewControllerViewExists() {
        XCTAssertNotNil(viewController.view, "ViewController should contain a view")
    }
    
    func testSelectAttractionsManager() {
        
        // Test initialized
        var selectAttractions = SelectAttractionsManager.sharedInstance
        XCTAssert(selectAttractions.allAttractions.isEmpty, "allAttractions not initialized to be empty")
        
        // Test add
        selectAttractions.addAttraction(1)
        XCTAssertEqual(1, selectAttractions.allAttractions.count, "allAttractions contain \(selectAttractions.allAttractions.count), expect 1")
        XCTAssert(contains(selectAttractions.allAttractions, 1), "allAttractions doesn't contain 1")

        selectAttractions.addAttraction(1)
        selectAttractions.addAttraction(1)
        XCTAssertEqual(1, selectAttractions.allAttractions.count, "allAttractions contain duplicate value")
        
        selectAttractions.addAttraction(2)
        selectAttractions.addAttraction(3)
        selectAttractions.addAttraction(4)
        XCTAssertEqual(4, selectAttractions.allAttractions.count, "allAttractions contain \(selectAttractions.allAttractions.count), expect 4")
        XCTAssert(contains(selectAttractions.allAttractions, 1), "allAttractions doesn't contain 2")
        XCTAssert(contains(selectAttractions.allAttractions, 1), "allAttractions doesn't contain 3")
        XCTAssert(contains(selectAttractions.allAttractions, 1), "allAttractions doesn't contain 4")
        
        // Test remove
        selectAttractions.removeAttractionAt(1)
        XCTAssertEqual(3, selectAttractions.allAttractions.count, "allAttractions contain \(selectAttractions.allAttractions.count), expect 3")
        XCTAssertFalse(selectAttractions.allAttractions[1] == 2, "allAttractions[1]:\(selectAttractions.allAttractions[1]) should not be 2")
        XCTAssert([1,3,4] == selectAttractions.allAttractions, "Expect: [1,3,4] but allAttractions contain: \(selectAttractions.allAttractions)")
        
        selectAttractions.removeAttractionAt(2)
        XCTAssertEqual(2, selectAttractions.allAttractions.count, "allAttractions contain \(selectAttractions.allAttractions.count), expect 2")
        XCTAssertTrue(selectAttractions.allAttractions[1] == 3, "allAttractions[1]:\(selectAttractions.allAttractions[1]) should not be 3")
        XCTAssert([1,3] == selectAttractions.allAttractions, "Expect: [1,3] but allAttractions contain: \(selectAttractions.allAttractions)")
        
        // Test move
        selectAttractions.addAttraction(2)
        selectAttractions.addAttraction(4)
        selectAttractions.moveItem(2, toIndex: 1)
        XCTAssertEqual(4, selectAttractions.allAttractions.count, "allAttractions contain \(selectAttractions.allAttractions.count), expect 4")
        XCTAssertTrue(selectAttractions.allAttractions[1] == 2, "allAttractions[1]:\(selectAttractions.allAttractions[1]) should not be 2")
        XCTAssert([1,2,3,4] == selectAttractions.allAttractions, "Expect: [1,2,3,4] but allAttractions contain: \(selectAttractions.allAttractions)")
        
        // Test route
        let myRoute = selectAttractions.myRoute
        XCTAssert([1,2,3,4] == myRoute!.AttractionIDs, "Expect: [1,2,3,4] but myRoute contain: \(myRoute!.AttractionIDs)")
        XCTAssert("My Route" == myRoute!.Name, "Expect name: 'My Route' but myRoute contain: \(myRoute!.Name)")

    }
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
