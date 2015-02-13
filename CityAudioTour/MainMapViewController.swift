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
    
    var selectedAttractionId : Int?
    var attractions = [MapViewAttraction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set current user location
        var currentlat = 41.88
        var currentlon = -87.635
        
        var location = CLLocationCoordinate2D(latitude: currentlat, longitude: currentlon)
        var span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        var region = MKCoordinateRegion(center: location, span: span)
        
        self.mainMapView.setRegion(region, animated: true)
        self.mainMapView.showsUserLocation = true
        
        
        // Webservice call to get attractions
        var service = CATAzureService()
        attractions = service.GetAttractions()
        

        /* START TEST MOCK DATA

        var attractions = [MapViewAttraction]()

        var WillisTower = MapViewAttraction(AttractionId: 1, Name: "Willis Tower",Latitude: 41.8788067, Longitude: -87.6360050)
        attractions.append(WillisTower)
        
        var ArtMusuem = MapViewAttraction(AttractionId: 2, Name: "Art Institute of Chicago", Latitude: 41.8795473, Longitude: -87.6237238)
        attractions.append(ArtMusuem)
        
        var NavyPier = MapViewAttraction(AttractionId: 3, Name: "Navy Pier", Latitude: 41.8919114, Longitude: -87.60945749999996)
        attractions.append(NavyPier)
        
        // END TEST MOCK DATA
        */
        
        // loop through attractions
        for attraction in attractions  {
            
            var pin = MKPointAnnotation()
            pin.title = attraction.Name
            pin.coordinate.latitude = attraction.Latitude
            pin.coordinate.longitude = attraction.Longitude
            
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

        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinColor = MKPinAnnotationColor.Green
            
            var calloutButton = UIButton.buttonWithType(.DetailDisclosure) as UIButton
            pinView!.rightCalloutAccessoryView = calloutButton
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        var annotation = view.annotation
        
        for attraction in attractions  {
            
            if (annotation.title == attraction.Name &&
                annotation.coordinate.latitude == attraction.Latitude &&
                annotation.coordinate.longitude == attraction.Longitude)
            {
                selectedAttractionId = attraction.AttractionId
            }
        }
        
        //println(selectedAttractionId)
        
        self.performSegueWithIdentifier("detailview", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "detailview") {
            var detailController:DetailViewController = segue.destinationViewController as DetailViewController
            detailController.receiveID = selectedAttractionId
            
            //println(selectedAttractionId)
        }
    }


}

