//
//  LCManagerDelegate.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 5/7/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class LCManagerDelegate:NSObject, CLLocationManagerDelegate{
    
    private let request:MKDirectionsRequest = MKDirectionsRequest()
    private var currentLocation:CLLocation!
    var attractList:[Attraction]!
    var popupWindow = {() -> Void in }
    var passAuthorize = {() -> Void in }
    var updateTable = {() -> Void in }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if (locations != nil){
            println("In IF")
            currentLocation = locations[0] as! CLLocation
            getDistanceUpdate();
        }else{
            println("In else")
            currentLocation = nil
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("Method is called.");
        
        switch(status){
            
        case CLAuthorizationStatus.Denied:
            println("Denied");
            popupWindow()
            break;
            
        case CLAuthorizationStatus.AuthorizedWhenInUse:
            passAuthorize()
            break;
            
        default:
            println("Default");
            break;
        }

    }
    
    
    private func getDistanceUpdate(){
        if (attractList != nil){
            for attract in attractList {
                var meter = currentLocation.distanceFromLocation(CLLocation(latitude: attract.Latitude, longitude: attract.Longitude))
                var mile = meter / 1609.344
                attract.Distance = Double(round(100*mile)/100)
                println(meter.description)
            }
        }
        if (updateTable != nil){
            updateTable()
        }
    }
    
    var location: CLLocation?  {
        get{
            return currentLocation
        }
    }
    
}