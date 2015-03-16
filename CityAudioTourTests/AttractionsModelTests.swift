//
//  AttractionsModelTests.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 3/16/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit
import XCTest

class AttractionsModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitilizeValues(){
        var expected = AttractionsModel.sharedInstance.attractionsList
        var result = AttractionsModel.sharedInstance.attractionsList
        
        if expected.isEmpty || result.isEmpty {
            XCTFail("Can't get data with some reason.")
        }
        
        var index = 0
        
        while (index < expected.count){
            
            XCTAssertEqual(expected[index].AttractionID, result[index].AttractionID, "Same Attraction ID")
            XCTAssertEqual(expected[index].AttractionName, result[index].AttractionName, "Same Attraction Name")
            XCTAssertEqualWithAccuracy(expected[index].Latitude, result[index].Latitude, 0.005 ,"Same Latitude")
            XCTAssertEqualWithAccuracy(expected[index].Longitude, result[index].Longitude, 0.005 ,"Same Longitude")
            XCTAssertEqual(expected[index].CategoryID, result[index].CategoryID, "Same Category ID")
            var tagIndex = 0
            while (tagIndex < expected[index].TagIDs.count){
                XCTAssertEqual(expected[index].TagIDs[tagIndex], result[index].TagIDs[tagIndex], "Same Tag ID")
                tagIndex++
            }
            XCTAssertEqual(expected[index].AttractionAddress, "", "No Attraction Address yet")
            XCTAssertEqual(result[index].AttractionAddress, "", "No Attraction Address yet")
            XCTAssertEqual(expected[index].Detail, "", "No Attraction Detail yet")
            XCTAssertEqual(result[index].Detail, "", "No Attraction Detail yet")
            XCTAssertEqual(expected[index].Content, "", "No Attraction Content yet")
            XCTAssertEqual(result[index].Content, "", "No Attraction Content yet")
            index++
        }
    }
    
    func testGetAttractionBy(){
        var expected = AttractionsModel.sharedInstance.attractionsList
        var result = AttractionsModel.sharedInstance.attractionsList
        
        if expected.isEmpty || result.isEmpty {
            XCTFail("Can't get data with some reason.")
        }
        
        var index = 0
        
        while (index < expected.count){
            
            var expectAttract = AttractionsModel.sharedInstance.GetAttractionBy(expected[index].AttractionID)
            var resultAttract = AttractionsModel.sharedInstance.GetAttractionBy(result[index].AttractionID)
            
            if (expectAttract == nil || resultAttract == nil) {
                XCTFail("Can't get data with some reason.")
            }else{
            
                XCTAssertEqual(expectAttract!.AttractionID, resultAttract!.AttractionID, "Same Attraction ID")
                XCTAssertEqual(expectAttract!.AttractionName, resultAttract!.AttractionName, "Same Attraction Name")
                XCTAssertEqualWithAccuracy(expectAttract!.Latitude, resultAttract!.Latitude, 0.005 ,"Same Latitude")
                XCTAssertEqualWithAccuracy(expectAttract!.Longitude, resultAttract!.Longitude, 0.005 ,"Same Longitude")
                XCTAssertEqual(expectAttract!.CategoryID, resultAttract!.CategoryID, "Same Category ID")
                
                var tagIndex = 0
                while (tagIndex < expectAttract!.TagIDs.count){
                    XCTAssertEqual(expectAttract!.TagIDs[tagIndex], resultAttract!.TagIDs[tagIndex], "Same Tag ID")
                    tagIndex++
                }
                XCTAssertEqual(expectAttract!.AttractionAddress, "", "No Attraction Address yet")
                XCTAssertEqual(resultAttract!.AttractionAddress, "", "No Attraction Address yet")
                XCTAssertEqual(expectAttract!.Detail, "", "No Attraction Detail yet")
                XCTAssertEqual(resultAttract!.Detail, "", "No Attraction Detail yet")
                XCTAssertEqual(expectAttract!.Content, "", "No Attraction Content yet")
                XCTAssertEqual(resultAttract!.Content, "", "No Attraction Content yet")
            
                index++
            }
        }
    }

    func testGetAttractionsConcreteObjects(){
        var attractList = AttractionsModel.sharedInstance.attractionsList
        
        if attractList.isEmpty{
            XCTFail("Can't get data with some reason.")
        }
        
        var attractID = [Int]()
        
        for attract in attractList{
            attractID.append(attract.AttractionID)
        }
        
        var expected = AttractionsModel.sharedInstance.GetAttractionsConcreteObjects(attractID)
        var result = AttractionsModel.sharedInstance.GetAttractionsConcreteObjects(attractID)
        
        if expected.isEmpty || result.isEmpty{
            XCTFail("Can't get data with some reason.")
        }
        
        var index = 0
        
        while (index < expected.count){
            XCTAssertEqual(expected[index].AttractionID, result[index].AttractionID, "Same Attraction ID")
            XCTAssertEqual(expected[index].AttractionName, result[index].AttractionName, "Same Attraction Name")
            XCTAssertEqualWithAccuracy(expected[index].Latitude, result[index].Latitude, 0.005 ,"Same Latitude")
            XCTAssertEqualWithAccuracy(expected[index].Longitude, result[index].Longitude, 0.005 ,"Same Longitude")
            XCTAssertEqual(expected[index].CategoryID, result[index].CategoryID, "Same Category ID")
            var tagIndex = 0
            while (tagIndex < expected[index].TagIDs.count){
                XCTAssertEqual(expected[index].TagIDs[tagIndex], result[index].TagIDs[tagIndex], "Same Tag ID")
                tagIndex++
            }
            XCTAssertEqual(expected[index].AttractionAddress, "", "No Attraction Address yet")
            XCTAssertEqual(result[index].AttractionAddress, "", "No Attraction Address yet")
            XCTAssertEqual(expected[index].Detail, "", "No Attraction Detail yet")
            XCTAssertEqual(result[index].Detail, "", "No Attraction Detail yet")
            XCTAssertEqual(expected[index].Content, "", "No Attraction Content yet")
            XCTAssertEqual(result[index].Content, "", "No Attraction Content yet")
            index++
        }
    }
    
    //Test FilterAttraction later.
//    func testFilterAttractions(){
//        
//    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
