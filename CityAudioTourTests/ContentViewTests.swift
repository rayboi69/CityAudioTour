//
//  ContentViewTests.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 3/12/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit
import XCTest

class ContentViewTests: XCTestCase {
    
    var service: CATAzureService!
    var contentView:AudioTourViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        service = CATAzureService()
        contentView = AudioTourViewController()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testContentBasedOnAttractionID(){
        class Content{
            var ID = 0
            var description:String = ""
            var title:String = ""
        }
        
        //Get all attractions first
        var attractList:[Attraction] = service.GetAttractions()
        //If it is zero, it can't get data. Test failed.
        if attractList.isEmpty {
            XCTFail("Can't get data with some reason")
        }
        
        var expectation:[Content] = [Content]()
        
        for attractID in attractList{
            let expect:XCTestExpectation = expectationWithDescription("Get AttractionContent of " + String(attractID.AttractionID))
            service.GetAttractionContentByID(attractID.AttractionID, MainThread: NSOperationQueue(), handler: {(respond:NSURLResponse!,data:NSData!,error:NSError!) -> Void in
                if data != nil{
                    var json = JSON(data: data!)
                    var title = json[1]["Title"].stringValue
                    var speechText = json[1]["Description"].stringValue
                    let content:Content = Content()
                    content.title = title
                    content.description = speechText
                    content.ID = attractID.AttractionID
                    
                    expectation.append(content)
                    
                    expect.fulfill()
                }else{
                    XCTFail("Can't get data with some reason")
                }
            })
            waitForExpectationsWithTimeout(5, handler: nil)
        }
        
        if expectation.count == 0 {
            XCTFail("Can't get data with some reason")
        }
        
        for attractID in expectation{
            let expect:XCTestExpectation = expectationWithDescription("Get AttractionContent of " + String(attractID.ID))
            let content:Content = Content()
            contentView.receiveID = attractID.ID
//            contentView.handler = {(response:NSURLResponse!,data:NSData!,error:NSError!) -> Void in
//                if data != nil {
//                    var json = JSON(data: data!)
//                    content.title = json[1]["Title"].stringValue
//                    content.description = json[1]["Description"].stringValue
//                    expect.fulfill()
//                }else{
//                    XCTFail("Can't get data with some reason.")
//                }
//            }
            
            contentView.viewDidLoad()
            waitForExpectationsWithTimeout(5, handler: nil)
            
            XCTAssertEqual(attractID.description, content.description, "Same description")
            XCTAssertEqual(attractID.title, content.title, "Same Title")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
