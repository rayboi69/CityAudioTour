//
//  RoutesModelTests.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 3/16/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.

import UIKit
import XCTest

class RoutesModelTests: XCTestCase {

    var manager:RoutesManager!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        manager = RoutesManager.sharedInstance
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAllRouteListAreExisted(){
        XCTAssertNotNil(manager.routesList, "Expected all routes are loaded.")
    }
    
    func testGetRouteByID(){
        
        if manager.routesList == nil || manager.routesList!.isEmpty {
            XCTFail("Can't get route list due to connection issue.")
        }
        XCTAssertEqual(manager.routesList!.count, 4, "Expected there currently are 4 routes.")
        
        
        var index = 0
        var id = 1
        
        while (index < manager.routesList!.count){
            var route = manager.GetRouteBy(id)
            XCTAssertEqual(route!.RouteID, manager.routesList![index].RouteID, "Expected the same route ID.")
            XCTAssertEqual(route!.Name, manager.routesList![index].Name, "Expected the same route name.")
            
            var attractID = 0
            while (attractID < route!.AttractionIDs.count){
                XCTAssertEqual(route!.AttractionIDs[attractID], manager.routesList![index].AttractionIDs[attractID], "Expected the same attraction ID.")
                attractID++
            }
            
            var tagID = 0
            while (tagID < route!.TagsIDs.count){
                XCTAssertEqual(route!.TagsIDs[tagID], manager.routesList![index].TagsIDs[tagID], "Expected the same tag ID.")
                tagID++
            }
            
            var catID = 0
            while (catID < route!.CategoriesIDs.count){
                XCTAssertEqual(route!.CategoriesIDs[catID], manager.routesList![index].CategoriesIDs[catID], "Expected the same category ID.")
                catID++
            }
            index++
            id++
        }
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
