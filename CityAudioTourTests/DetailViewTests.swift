//
//  DetailViewTests.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 3/12/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit
import XCTest
import SwiftyJSON

class DetailViewTests: XCTestCase {
    
    var detailView:DetailViewController!
    var service:CATAzureService!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
 
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        detailView = storyboard.instantiateViewControllerWithIdentifier("DetailPage") as! DetailViewController
        detailView.recvattract = Attraction()
        var dummy = detailView.view
        service = CATAzureService()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAllUIAreExists() {
        XCTAssertNotNil(detailView.AttractionName, "Expected Attraction Name Label is loaded. ")
        XCTAssertNotNil(detailView.AttractionAddress, "Expected Attraction Address Label is loaded.")
        XCTAssertNotNil(detailView.AttractionDetail, "Expected Attraction Detail Box is loaded. ")
        XCTAssertNotNil(detailView.UIImageAttractionImage, "Expected Attraction image is loaded. ")
        XCTAssertNotNil(detailView.WorkingHours, "Expected Attraction Open Hours Label is loaded. ")
        XCTAssertNotNil(detailView.LoadingView, "Expected Spinner is loaded. ")
    }
    
    func testUIOutPut(){
        var list:[Attraction] = service.GetAttractions()
        
        if list.isEmpty {
            XCTFail("Can't get data with some reason")
        }
        
        for attractID in list{
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

        for attract in list{
            detailView.recvattract = attract
            
            detailView.viewDidLoad()
            
            XCTAssertEqual(detailView.AttractionName.text!, attract.AttractionName, "Expected Attraction Name is shown.")
            XCTAssertEqual(detailView.AttractionDetail.text!, attract.Detail, "Expected Attraction Detail is shown.")
            XCTAssertEqual(detailView.AttractionAddress.text!, attract.addrSecForm, "Expected Attraction Address is shown.")
            XCTAssertEqual(detailView.AttractionName.text!, attract.AttractionName, "Expected Attraction Name is shown.")
            XCTAssertTrue(!detailView.LoadingView.hidden, "Expected Spinner is shown.")
            
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
