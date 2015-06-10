//
//  RouteMapViewTests.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 6/3/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit
import XCTest

class RouteMapViewTests: XCTestCase {

    var routeMapView:RouteMapViewController!
    var manager:RoutesManager!
    
    override func setUp() {
        super.setUp()
        
        manager = RoutesManager.sharedInstance
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        routeMapView = storyboard.instantiateViewControllerWithIdentifier("RouteMap") as! RouteMapViewController
        
        manager.selectedRoute = manager.GetRouteBy(2)
        
        var dummy = routeMapView.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAllUIAreExist(){
        XCTAssertNotNil(routeMapView.routeMap, "Expected Map View is created.")
        XCTAssertNotNil(routeMapView.attractNameLabel, "Expected Attraction Name Label is created.")
        XCTAssertNotNil(routeMapView.addrLabel, "Expected Attraction Address Label is created.")
        XCTAssertNotNil(routeMapView.nextBtn, "Expected Next Button is created.")
        XCTAssertNotNil(routeMapView.prevBtn, "Expected Previous Button is created.")
        XCTAssertNotNil(routeMapView.RNameLabel, "Expected Route Name Label is created.")
        XCTAssertNotNil(routeMapView.audioBtn, "Expected Audio Button is created.")
        XCTAssertNotNil(routeMapView.naviBtn, "Expected Navigator Button is created.")
    }

    func testNextPrevBtn(){
        
        var attractionList:[Attraction] = [Attraction]()
        let allRouteList:[Route] = manager.routesList!
        
        if (allRouteList.isEmpty){
            XCTFail("Can't get the route list due to internet connection issue.")
        }
        
        for ID in manager.selectedRoute!.AttractionIDs{
            attractionList.append(AttractionsManager.sharedInstance.GetAttractionBy(ID)!)
        }
        
        //Check at the starting Point
        XCTAssertEqual(routeMapView.RNameLabel.text!, manager.selectedRoute!.Name, "Expected Label to show current route name.")
        XCTAssertEqual(routeMapView.attractNameLabel.currentTitle!, attractionList[0].AttractionName, "Expected Button to show the first attraction name in the route list.")
        XCTAssertEqual(routeMapView.addrLabel.text!, attractionList[0].AttractionAddress, "Expected Label to show the first attraction address in the route list.")
        XCTAssertEqual(manager.selectedRoute!.AttractionIDs.count, attractionList.count, "Expected the size of attraction ID of route ID 1 is equal to actual attraction List.")
        XCTAssertTrue(routeMapView.prevBtn.hidden, "Expected that Previous Button is hidden for the first attraction.")
        XCTAssertFalse(routeMapView.nextBtn.hidden, "Expected that Next Button is shown for the first attraction.")
        
        var index = 1
        var count = attractionList.count
        
        while (index < count){
            routeMapView.nextAttract(index)
            XCTAssertEqual(routeMapView.attractNameLabel.currentTitle!, attractionList[index].AttractionName, "Expected Name Button is showing the attraction name.")
            XCTAssertEqual(routeMapView.addrLabel.text!, attractionList[index].AttractionAddress, "Expected Address Label is showing the attraction address.")
            XCTAssertFalse(routeMapView.prevBtn.hidden, "Expected that Previous Button is shown when go to next attraction.")
            index++
        }
        
        XCTAssertEqual(routeMapView.attractNameLabel.currentTitle!, attractionList[count - 1].AttractionName, "Expected Name Button is showing the last attraction name.")
        XCTAssertEqual(routeMapView.addrLabel.text!, attractionList[count - 1].AttractionAddress, "Expected Address Label is showing the last attraction address.")
        XCTAssertFalse(routeMapView.prevBtn.hidden, "Expected that Previous Button is shown at the last attraction.")
        XCTAssertTrue(routeMapView.nextBtn.hidden, "Expected that Next Button is hidden at the last attraction.")
        
        index -= 2
        count = 0
        
        while(index >= count){
            routeMapView.prevAttract(index)
            XCTAssertEqual(routeMapView.attractNameLabel.currentTitle!, attractionList[index].AttractionName, "Expected Name Button is showing the attraction name.")
            XCTAssertEqual(routeMapView.addrLabel.text!, attractionList[index].AttractionAddress, "Expected Address Label is showing the attraction address.")
            XCTAssertFalse(routeMapView.nextBtn.hidden, "Expected that Previous Button is shown.")
            index--
        }

        //Go back to starting Point
        XCTAssertEqual(routeMapView.RNameLabel.text!, manager.selectedRoute!.Name, "Expected Label to show current route name.")
        XCTAssertEqual(routeMapView.attractNameLabel.currentTitle!, attractionList[0].AttractionName, "Expected Button to show the first attraction name in the route list.")
        XCTAssertEqual(routeMapView.addrLabel.text!, attractionList[0].AttractionAddress, "Expected Label to show the first attraction address in the route list.")
        XCTAssertEqual(manager.selectedRoute!.AttractionIDs.count, attractionList.count, "Expected the size of attraction ID of route ID 1 is equal to actual attraction List.")
        XCTAssertTrue(routeMapView.prevBtn.hidden, "Expected that Previous Button is hidden for the first attraction.")
        XCTAssertFalse(routeMapView.nextBtn.hidden, "Expected that Next Button is shown for the first attraction.")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
