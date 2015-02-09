//
//  MainMapViewController.swift
//  CityAudioTour
//
//  Created by Raul Rey Aso on 2/5/2015
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit
import MapKit

class MainMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mainMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create an object MapViewAttraction
        // var a = MapViewAttraction()
        
        // Creates a list of MapViewAttractions, this list will be retrieved by the web service
        var attractions: [MapViewAttraction] = []
        
        // START TEST MOCK DATA
        var WillisTower = MapViewAttraction(name: "Willis Tower", status: "Open", latitude: 41.8788067, longitude: -87.6360050)
        attractions.append(WillisTower)
        
        var ArtMusuem = MapViewAttraction(name: "Art Institute of Chicago", status: "Closed", latitude: 41.8795473, longitude: -87.6237238)
        attractions.append(ArtMusuem)
        
        var NavyPier = MapViewAttraction(name: "Navy Pier", status: "Open", latitude: 41.8919114, longitude: -87.60945749999996)
        attractions.append(NavyPier)
        
        var LincolnParkZoo = MapViewAttraction(name: "Lincoln Park Zoo", status: "Closed", latitude: 41.9175023, longitude: -87.63243940000001)
        attractions.append(LincolnParkZoo)
        
        var SheddAquarium = MapViewAttraction(name: "Shedd Aquarium", status: "Open", latitude: 41.86759505, longitude: -87.6136641706734)
        attractions.append(SheddAquarium)
        // END TEST MOCK DATA
        
        
        var currentlat = 41.876189
        var currentlon = -87.627418

        var location = CLLocationCoordinate2D(latitude: currentlat, longitude: currentlon)
        var span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        var region = MKCoordinateRegion(center: location, span: span)
        
        self.mainMapView.setRegion(region, animated: true)
        self.mainMapView.showsUserLocation = true
        
        // loop through attractions
        for mpa in attractions  {
            
            var pin = MKPointAnnotation()
            pin.title = mpa.name
            pin.subtitle = mpa.status
            pin.coordinate.latitude = mpa.latitude
            pin.coordinate.longitude = mpa.longitude
            
            // Add Pin to Map
            self.mainMapView.addAnnotation(pin)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        
        var button = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
        
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            if (annotation.subtitle == "Open")
            {
                pinView!.canShowCallout = true
                pinView!.animatesDrop = true
                pinView!.pinColor = MKPinAnnotationColor.Green
                pinView!.rightCalloutAccessoryView = button
            }
            else if (annotation.subtitle == "Closed")
            {
                pinView!.canShowCallout = true
                pinView!.animatesDrop = true
                pinView!.pinColor = MKPinAnnotationColor.Red
                pinView!.rightCalloutAccessoryView = button
            }
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }


}

