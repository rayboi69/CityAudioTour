//
//  CameraControl.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 4/8/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import Foundation
import MapKit

class CameraControl{
    
    //Coordinate values
    private var maxLatitude:CLLocationDegrees = 0
    private var minLatitude:CLLocationDegrees = 0
    private var maxLongitude:CLLocationDegrees = 0
    private var minLongitude:CLLocationDegrees = 0
    
    
    func setMinMaxCoordinate(pin:CLLocationCoordinate2D){
        if pin.latitude > maxLatitude {
            maxLatitude = pin.latitude
        }
        if pin.latitude < minLatitude {
            minLatitude = pin.latitude
        }
        if pin.longitude > maxLongitude {
            maxLongitude = pin.longitude
        }
        if pin.longitude < minLongitude {
            minLongitude = pin.longitude
        }
    }
    
    func resetMinMax(){
        maxLatitude = 0
        minLatitude = 0
        maxLongitude = 0
        minLongitude = 0
    }

    func calculateCenter() -> MKCoordinateRegion{
        
        let latitudeMeter = (maxLatitude - minLatitude) / 800
        let longitudeMeter = (maxLongitude - minLongitude) / 800
        let Span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latitudeMeter, longitudeDelta: longitudeMeter)
        
        let centerLat = (maxLatitude + minLatitude) - 0.02
        let centerLong = (maxLongitude + minLongitude) + 0.02
        let center:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLong)
        
        let cameraCenter:MKCoordinateRegion = MKCoordinateRegionMake(center,Span)
        return cameraCenter
    }

}