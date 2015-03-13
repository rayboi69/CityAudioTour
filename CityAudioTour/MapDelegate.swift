//
//  MapDelegate.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 3/2/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import Foundation
import MapKit


class MapDelegate:NSObject, MKMapViewDelegate, CLLocationManagerDelegate{
    //All variables for this class
    private let latitudeMeter:CLLocationDistance = 1500
    private let longitudeMeter:CLLocationDistance = 1500
    private let mapView:MainMapViewController!
    private var currentLocation:CLLocation?
    private var camera:MKCoordinateRegion!
    private var isFindingCurrent = false
    private var needAttraction = true
    
    //Need this constructor to create a super class (NSObject).
    override init(){
        super.init()
    }
    //Constructor for this class.
    init(mapView:MainMapViewController){
        self.mapView = mapView
    }
    
    //Get current Location when locationManager.startUpdatingLocation() is called.
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if (locations != nil){
            currentLocation = locations[0] as? CLLocation
            if isFindingCurrent {
                camera = MKCoordinateRegionMakeWithDistance(currentLocation!.coordinate, latitudeMeter, longitudeMeter)
                mapView.mainMapView.setRegion(camera, animated: true)
                isFindingCurrent = false
            }
            manager.stopUpdatingLocation()
            
            if needAttraction{
                mapView.createPinPoint()
                needAttraction = false
            }
            
            
        }else{
            //Can't get data with some reason.
        }
    }
    
    //When we call addAnnotation of map view, this method will be called to modify each annotation style
    //on the map. We can modify to be our own images in the future if we want.
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinColor = MKPinAnnotationColor.Green
            
            var calloutButton = UIButton.buttonWithType(.DetailDisclosure) as UIButton
            pinView!.rightCalloutAccessoryView = calloutButton
        }
        else{
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    //When the button in annotation is pressed, this method will be called to handle it.
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        self.mapView.gotoDetailPage(view)
    }
    
    //When we add overlay or polyline in the map, this method will be called to draw a polyline
    //in the map.
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        var renderer : MKPolylineRenderer! = nil
        if let overlay = overlay as? MKPolyline {
            renderer = MKPolylineRenderer(polyline:overlay)
            renderer.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.8)
            renderer.lineWidth = 2
        }
        return renderer
    }
    
    func wantPinPoint(){
        needAttraction = true
    }
    
    func currentBtnisClicked(){
        isFindingCurrent = true
    }
    
    func getCurrentLocation() -> CLLocation{
        return currentLocation!;
    }
}
