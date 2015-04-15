//
//  CATAzureServiceTests.swift
//  CityAudioTour
//
//  Created by Raul Rey Aso on 3/9/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import XCTest
import CityAudioTour
import SwiftyJSON

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
        
        var expectation:[Attraction] = service.GetAttractions()
        var result:[Attraction] = service.GetAttractions()
        
        var index:Int = 0
        
        if expectation.isEmpty || result.isEmpty {
            XCTFail("Can't get data with some reason")
        }
        
        while (index < expectation.count){
            XCTAssertEqual(expectation[index].AttractionID, result[index].AttractionID, "Same Attraction ID")
            XCTAssertEqual(expectation[index].AttractionName, result[index].AttractionName, "Same Attraction Name")
            XCTAssertEqualWithAccuracy(expectation[index].Latitude, result[index].Latitude, 0.005 ,"Same Latitude")
            XCTAssertEqualWithAccuracy(expectation[index].Longitude, result[index].Longitude, 0.005 ,"Same Longitude")
            XCTAssertEqual(expectation[index].CategoryID, result[index].CategoryID, "Same Category ID")
            var tagIndex = 0
            while (tagIndex < expectation[index].TagIDs.count){
                XCTAssertEqual(expectation[index].TagIDs[tagIndex], result[index].TagIDs[tagIndex], "Same Tag ID")
                tagIndex++
            }
            XCTAssertEqual(expectation[index].AttractionAddress, "", "No Attraction Address yet")
            XCTAssertEqual(result[index].AttractionAddress, "", "No Attraction Address yet")
            XCTAssertEqual(expectation[index].Detail, "", "No Attraction Detail yet")
            XCTAssertEqual(result[index].Detail, "", "No Attraction Detail yet")
            XCTAssertEqual(expectation[index].Content, "", "No Attraction Content yet")
            XCTAssertEqual(result[index].Content, "", "No Attraction Content yet")
            index++
        }
    }
    
    func testGetCategotyList(){
        var expectation:[Category] = service.GetCategoryList()
        var result:[Category] = service.GetCategoryList()
        
        if expectation.isEmpty || result.isEmpty {
            XCTFail("Can't get data with some reason")
        }
        
        var index:Int = 0
        
        while (index < expectation.count){
            XCTAssertEqual(expectation[index].CategoryID, result[index].CategoryID, "Same Category ID")
            XCTAssertEqual(expectation[index].Name, result[index].Name, "Same Category Name")
            index++
        }
    }
    
    func testGetTagList(){
        var expectation:[Tag] = service.GetTagList()
        var result:[Tag] = service.GetTagList()
        
        if expectation.isEmpty || result.isEmpty {
            XCTFail("Can't get data with some reason")
        }
        
        var index:Int = 0
        
        while (index < expectation.count){
            XCTAssertEqual(expectation[index].TagID, result[index].TagID, "Same Tag ID")
            XCTAssertEqual(expectation[index].Name, result[index].Name, "Same Tag Name")
            index++
        }
    }
    
    func testGetRoutes(){
        var expectation:[Route] = service.GetRoutes()
        var result:[Route] = service.GetRoutes()
    
        if expectation.isEmpty || result.isEmpty {
            XCTFail("Can't get data with some reason")
        }
    
        var index:Int = 0
    
        while (index < expectation.count){
            XCTAssertEqual(expectation[index].RouteID, result[index].RouteID, "Same Route ID")
            XCTAssertEqual(expectation[index].Name, result[index].Name, "Same Route Name")
    
            var attractIDIndex = 0
    
            while (attractIDIndex < expectation[index].AttractionIDs.count){
                XCTAssertEqual(expectation[index].AttractionIDs[attractIDIndex], result[index].AttractionIDs[attractIDIndex], "Same AttractionIDs")
                attractIDIndex++
            }

            attractIDIndex = 0
            
            while (attractIDIndex < expectation[index].TagsIDs.count){
                XCTAssertEqual(expectation[index].TagsIDs[attractIDIndex], result[index].TagsIDs[attractIDIndex], "Same TagsIDs")
                attractIDIndex++
            }
            
            attractIDIndex = 0
            
            while (attractIDIndex < expectation[index].CategoriesIDs.count){
                XCTAssertEqual(expectation[index].CategoriesIDs[attractIDIndex], result[index].CategoriesIDs[attractIDIndex], "Same CategoriesIDs")
                attractIDIndex++
            }
            index++
        }
    }
    
    func testGetAttraction(){
        
        var expectation:[Attraction] = service.GetAttractions()
        var result:[Attraction] = service.GetAttractions()
        
        if expectation.isEmpty || result.isEmpty {
            XCTFail("Can't get data with some reason")
        }
        
        
        for attractID in expectation{
            let expect:XCTestExpectation = expectationWithDescription("Get AttractionDetail of " + String(attractID.AttractionID))
            service.GetAttraction(attractID.AttractionID, MainThread: NSOperationQueue(), handler: {(respond:NSURLResponse!,data:NSData!,error:NSError!) -> Void in
                if data != nil{
                    let json = JSON(data:data!)
                    
                    var address = json["Address"].stringValue
                    var city = json["City"].stringValue
                    var state = json["StateAbbreviation"].stringValue
                    var zip = json["ZipCode"].stringValue
                    
                    attractID.setAddress(address, city: city, state: state, ZIP: zip)
                    attractID.AttractionName = json["Name"].stringValue
                    attractID.Detail = json["Details"].stringValue
                    attractID.Content = json["TextContent"].stringValue
                    expect.fulfill()
                }else{
                    XCTFail("Can't get data with some reason")
                }
            })
            waitForExpectationsWithTimeout(5, handler: nil)
        }
        
        for attractID in result{
            let expect:XCTestExpectation = expectationWithDescription("Get AttractionDetail of " + String(attractID.AttractionID))
            service.GetAttraction(attractID.AttractionID, MainThread: NSOperationQueue(), handler: {(respond:NSURLResponse!,data:NSData!,error:NSError!) -> Void in
                if data != nil{
                    let json = JSON(data:data!)
                    
                    var address = json["Address"].stringValue
                    var city = json["City"].stringValue
                    var state = json["StateAbbreviation"].stringValue
                    var zip = json["ZipCode"].stringValue
                    
                    attractID.setAddress(address, city: city, state: state, ZIP: zip)
                    attractID.AttractionName = json["Name"].stringValue
                    attractID.Detail = json["Details"].stringValue
                    attractID.Content = json["TextContent"].stringValue
                    expect.fulfill()
                }else{
                    XCTFail("Can't get data with some reason")
                }
            })
            waitForExpectationsWithTimeout(5, handler: nil)
        }
        
        var index:Int = 0
        
        while (index < expectation.count){
            XCTAssertEqual(expectation[index].AttractionID, result[index].AttractionID, "Same Attraction ID")
            XCTAssertEqual(expectation[index].AttractionName, result[index].AttractionName, "Same Attraction Name")
            XCTAssertEqual(expectation[index].AttractionAddress, result[index].AttractionAddress, "Same Attraction Address")
            XCTAssertEqual(expectation[index].Detail, result[index].Detail, "Same Attraction Detail")
            XCTAssertEqual(expectation[index].Content, result[index].Content, "Same Attraction Content")
            index++
        }
    }
    
    
    func testGetAttractionContentByID(){
        var attractList:[Attraction] = service.GetAttractions()
        
        if attractList.isEmpty {
            XCTFail("Can't get data with some reason")
        }
        
        class content{
            var content:String = ""
            var description:String = ""
        }
        
        var expectation:[content] = [content]()
        var result:[content] = [content]()
        
        for attractID in attractList{
            let expect:XCTestExpectation = expectationWithDescription("Get AttractionContent of " + String(attractID.AttractionID))
            service.GetAttractionContentByID(attractID.AttractionID, MainThread: NSOperationQueue(), handler: {(respond:NSURLResponse!,data:NSData!,error:NSError!) -> Void in
                if data != nil{
                    var json = JSON(data: data!)
                    var title = json[1]["Title"].stringValue
                    var speechText = json[1]["Description"].stringValue
                    let content:content = content()
                    content.content = title
                    content.description = speechText
                    
                    expectation.append(content)
                    
                    expect.fulfill()
                }else{
                    XCTFail("Can't get data with some reason")
                }
            })
            waitForExpectationsWithTimeout(5, handler: nil)
        }
        
        for attractID in attractList{
            let expect:XCTestExpectation = expectationWithDescription("Get AttractionContent of " + String(attractID.AttractionID))
            service.GetAttractionContentByID(attractID.AttractionID, MainThread: NSOperationQueue(), handler: {(respond:NSURLResponse!,data:NSData!,error:NSError!) -> Void in
                if data != nil{
                    var json = JSON(data: data!)
                    var title = json[1]["Title"].stringValue
                    var speechText = json[1]["Description"].stringValue
                    let content:content = content()
                    content.content = title
                    content.description = speechText
                    
                    result.append(content)
                    
                    expect.fulfill()
                }else{
                    XCTFail("Can't get data with some reason")
                }
            })
            waitForExpectationsWithTimeout(5, handler: nil)
        }
        
        var index:Int = 0
        
        while (index < expectation.count){
            XCTAssertEqual(expectation[index].content, result[index].content, "Same Attraction Content")
            XCTAssertEqual(expectation[index].description, result[index].description, "Same Attraction Description")
            index++
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
