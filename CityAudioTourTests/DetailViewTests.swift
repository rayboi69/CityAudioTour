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
    
//    var detailView:DetailViewController!
//    var service:CATAzureService!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        //service = CATAzureService()
        //detailView = DetailViewController()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //Check all contents before showing on Detail View. The result must be match based on
    //attraction ID received from server.
//    func testDetailBasedOnAttractionID(){
//        
//        //Get all attractions first
//        var attractList:[Attraction] = service.GetAttractions()
//        //If it is zero, it can't get data. Test failed.
//        if attractList.isEmpty {
//            XCTFail("Can't get data with some reason")
//        }
//        //Loop through all attractions to check that detail page will get the same result before
//        //it shows that result on screen.
//        for attractID in attractList{
//            let expect:XCTestExpectation = expectationWithDescription("Get AttractionDetail of " + String(attractID.AttractionID))
//            service.GetAttraction(attractID.AttractionID, MainThread: NSOperationQueue(), handler: {(respond:NSURLResponse!,data:NSData!,error:NSError!) -> Void in
//                if data != nil{
//                    let json = JSON(data:data!)
//                    
//                    var address = json["Address"].stringValue
//                    var city = json["City"].stringValue
//                    var state = json["StateAbbreviation"].stringValue
//                    var zip = json["ZipCode"].stringValue
//                    
//                    attractID.setAddress(address, city: city, state: state, ZIP: zip)
//                    attractID.AttractionName = json["Name"].stringValue
//                    attractID.Detail = json["Details"].stringValue
//                    
//                    expect.fulfill()
//                }else{
//                    XCTFail("Can't get data with some reason")
//                }
//            })
//            waitForExpectationsWithTimeout(5, handler: nil)
//        }
//        //Data request will be done by detailViewController. Then we compare the results.
//        //It must be the same as above.
//        for attract in attractList{
//            let expect:XCTestExpectation = expectationWithDescription("Get AttractionContent of " + String(attract.AttractionID))
//            
//            let attraction = Attraction()
//            detailView.receiveID = attract.AttractionID
//            //Same logic except it doesn't set up UI of detailView.
////            detailView.handler = {(response:NSURLResponse!,data:NSData!,error:NSError!) -> Void in
////                if data != nil{
////                    
////                    let json = JSON(data:data!)
////                    
////                    var address = json["Address"].stringValue
////                    var city = json["City"].stringValue
////                    var state = json["StateAbbreviation"].stringValue
////                    var zip = json["ZipCode"].stringValue
////                    
////                    attraction.setAddress(address, city: city, state: state, ZIP: zip)
////                    attraction.AttractionName = json["Name"].stringValue
////                    attraction.Detail = json["Details"].stringValue
////                    
////                    expect.fulfill()
////                }else{
////                    XCTFail("Can't get data with some result.")
////                }
////            }
//            detailView.viewDidLoad()
//            
//            waitForExpectationsWithTimeout(5, handler: nil)
//            
//            //If detailView is loaded, all equal checkings must be working fine and be able to
//            //compare all results.
//            XCTAssertEqual(attract.AttractionName, attraction.AttractionName, "Same attraction name")
//            XCTAssertEqual(attract.Detail,attraction.Detail ,"Same attraction detail")
//            XCTAssertEqual(attract.AttractionAddress, attraction.AttractionAddress, "Same attraction address")
//        }
//    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
