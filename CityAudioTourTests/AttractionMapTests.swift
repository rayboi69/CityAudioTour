//
//  AttractionMapTests.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 5/27/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit
import XCTest

class AttractionMapTests: XCTestCase {

    var attractionMapView:AttractionMapController!
    var service:CATAzureService!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        service = CATAzureService()
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        attractionMapView = storyboard.instantiateViewControllerWithIdentifier("AttractMap") as! AttractionMapController
        attractionMapView.list = service.GetAttractions()
        
        var dummy = attractionMapView.view
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        super.tearDown()
    }

    func testAllUIAreExisted(){
        
        XCTAssertNotNil(attractionMapView.mapView, "Expected Map View is created.")
        XCTAssertNotNil(attractionMapView.NameLabel, "Expected Attraction Name Label is created.")
        XCTAssertNotNil(attractionMapView.addrLabel, "Expected Attraction Address Label is created.")
        XCTAssertNotNil(attractionMapView.distanceLabel, "Expected Distance Label is created.")
        XCTAssertNotNil(attractionMapView.nextBtn, "Expected Next Button is created.")
        XCTAssertNotNil(attractionMapView.prevBtn, "Expected Previous Button is created.")
        XCTAssertNotNil(attractionMapView.DetailBox, "Expected Detail Box view is created.")
        XCTAssertNotNil(attractionMapView.miniPopUpDetail, "Expected flyout mini-detail is created.")
        XCTAssertNotNil(attractionMapView.OpenHoursBox, "Expected Open Hours is created.")
    }

    func testNextandPrevButton(){
        
        attractionMapView.CreatePinPoint()
        
        XCTAssertEqual(attractionMapView.list.count, attractionMapView.mapView.annotations.count, "Expected Map View creates all annotations based on the list that it gets.")
        XCTAssertEqual(attractionMapView.NameLabel.currentTitle!, attractionMapView.list[0].AttractionName, "Expected Name Button is showing the first attraction name.")
        XCTAssertEqual(attractionMapView.addrLabel.text!, attractionMapView.list[0].AttractionAddress, "Expected Address Label is showing the first attraction address.")
        XCTAssertEqual(attractionMapView.DetailBox.text, attractionMapView.list[0].Detail, "Expected Detail Box is showing the first attraction detail.")
        XCTAssertTrue(attractionMapView.prevBtn.hidden, "Expected that Previous Button is hidden at the first time.")
        XCTAssertFalse(attractionMapView.nextBtn.hidden, "Expected that Next Button is shown at the first time.")
        
        var index = 1
        var count = attractionMapView.list.count
        
        while (index < count){
            attractionMapView.nextAttractBtn(index)
            XCTAssertEqual(attractionMapView.NameLabel.currentTitle!, attractionMapView.list[index].AttractionName, "Expected Name Button is showing the attraction name.")
            XCTAssertEqual(attractionMapView.addrLabel.text!, attractionMapView.list[index].AttractionAddress, "Expected Address Label is showing the attraction address.")
            XCTAssertEqual(attractionMapView.DetailBox.text, attractionMapView.list[index].Detail, "Expected Detail Box is showing the attraction detail.")
            XCTAssertFalse(attractionMapView.prevBtn.hidden, "Expected that Previous Button is shown when go to next attraction.")
            index++
        }
        
        XCTAssertEqual(attractionMapView.NameLabel.currentTitle!, attractionMapView.list[count - 1].AttractionName, "Expected Name Button is showing the last attraction name.")
        XCTAssertEqual(attractionMapView.addrLabel.text!, attractionMapView.list[count - 1].AttractionAddress, "Expected Address Label is showing the last attraction address.")
        XCTAssertEqual(attractionMapView.DetailBox.text, attractionMapView.list[count - 1].Detail, "Expected Detail Box is showing the last attraction detail.")
        XCTAssertFalse(attractionMapView.prevBtn.hidden, "Expected that Previous Button is shown at the last attraction.")
        XCTAssertTrue(attractionMapView.nextBtn.hidden, "Expected that Next Button is hidden at the last attraction.")
        
        index -= 2
        count = 0
        
        while(index >= count){
            attractionMapView.prevAttractBtn(index)
            XCTAssertEqual(attractionMapView.NameLabel.currentTitle!, attractionMapView.list[index].AttractionName, "Expected Name Button is showing the attraction name.")
            XCTAssertEqual(attractionMapView.addrLabel.text!, attractionMapView.list[index].AttractionAddress, "Expected Address Label is showing the attraction address.")
            XCTAssertEqual(attractionMapView.DetailBox.text, attractionMapView.list[index].Detail, "Expected Detail Box is showing the attraction detail.")
            XCTAssertFalse(attractionMapView.nextBtn.hidden, "Expected that Previous Button is shown.")
            index--
        }
        
        //Back to the beginning.
        XCTAssertEqual(attractionMapView.list.count, attractionMapView.mapView.annotations.count, "Expected Map View creates all annotations based on the list that it gets.")
        XCTAssertEqual(attractionMapView.NameLabel.currentTitle!, attractionMapView.list[0].AttractionName, "Expected Name Button is showing the first attraction name.")
        XCTAssertEqual(attractionMapView.addrLabel.text!, attractionMapView.list[0].AttractionAddress, "Expected Address Label is showing the first attraction address.")
        XCTAssertEqual(attractionMapView.DetailBox.text, attractionMapView.list[0].Detail, "Expected Detail Box is showing the first attraction detail.")
        XCTAssertTrue(attractionMapView.prevBtn.hidden, "Expected that Previous Button is hidden at the first time.")
        XCTAssertFalse(attractionMapView.nextBtn.hidden, "Expected that Next Button is shown at the first time.")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
