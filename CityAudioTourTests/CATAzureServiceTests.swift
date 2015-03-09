//
//  CATAzureServiceTests.swift
//  CityAudioTour
//
//  Created by Raul Rey Aso on 3/9/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import XCTest
import CityAudioTour

class CATAzureServiceTests: XCTestCase {
    
    var service: CATAzureService!
    
    override func setUp() {
        super.setUp()
        
        service = CATAzureService()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetAttractions() {
        
        var attractions = service.GetAttractions()
        
        // This is an example of a functional test case.
        XCTAssert(attractions.count > 0, "Pass")
        
    }
}
