//
//  MainMapViewController.swift
//  CityAudioTour
//
//  Created by Raul Rey Aso on 2/5/2015
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MainMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mainMapView: MKMapView!
    @IBOutlet weak var menuView: UIView!
    
    var menuController:MenuController!
    var selectedAttractionId : Int?
    var attractions = [Attraction]()
    
    let locationManager = CLLocationManager()

    @IBAction func MenuBtn(sender: AnyObject) {
        if !menuController.isMenuShowing() {
            menuController.MenuShown()
        }else{
            menuController.MenuHidden()
        }
    }
    
    
    //Hide Navigator bar when main screen is appeared.
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    //Show Navigator bar when moving to other views.
    override func viewDidDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up Flyout menu
        menuController = MenuController(MenuView: menuView, MainView: self.view)
        
        // set up LocationManager
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // this if statement is required because the statement requestWhenInUseAuthorization will fail 
        // on iOS versions lower than 8.0
        if (self.locationManager.respondsToSelector(Selector("requestWhenInUseAuthorization"))) {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        self.locationManager.startUpdatingLocation()
        
        // set current user location to 1 E. Jackson Chicago, IL this can also be set in Debug
        /*var currentlat = 41.877860
        var currentlon = -87.627262
        
        var location = CLLocationCoordinate2D(latitude: currentlat, longitude: currentlon)
        var span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        var region = MKCoordinateRegion(center: location, span: span)
        
        self.mainMapView.setRegion(region, animated: true)*/
        self.mainMapView.showsUserLocation = true

        // Webservice call to get attractions
        var service = CATAzureService()
        attractions = service.GetAttractions()
        
        /* START TEST MOCK DATA */
        //var attractions = [MapViewAttraction]()
        /*var WillisTower = Attraction()
        WillisTower.AttractionID = 1
        WillisTower.AttractionName = "Willis Tower"
        WillisTower.Latitude = 41.8788067
        WillisTower.Longitude = -87.6360050
        attractions.append(WillisTower)
        
        var ArtMusuem = Attraction()
        ArtMusuem.AttractionID = 2
        ArtMusuem.AttractionName = "Art Institute of Chicago"
        ArtMusuem.Latitude = 41.8795473
        ArtMusuem.Longitude = -87.6237238
        attractions.append(ArtMusuem)
        
        var NavyPier = Attraction()
        NavyPier.AttractionID = 3
        NavyPier.AttractionName = "Navy Pier"
        NavyPier.Latitude = 41.8919114
        NavyPier.Longitude = -87.60945749999996
        attractions.append(NavyPier)*/
        // END TEST MOCK DATA

        
        // loop through attractions
        for attraction in attractions  {
            
            var pin = MKPointAnnotation()
            pin.title = attraction.AttractionName
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
            
            if (annotation.title == attraction.AttractionName &&
                annotation.coordinate.latitude == attraction.Latitude &&
                annotation.coordinate.longitude == attraction.Longitude)
            {
                selectedAttractionId = attraction.AttractionID
            }
        }
        
        self.performSegueWithIdentifier("detailview", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "detailview") {
            var detailController:DetailViewController = segue.destinationViewController as DetailViewController
            detailController.receiveID = selectedAttractionId
        }
    }
    
    // this function is used for iOS versions lower than 5
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        // this sets the current location to center in the map
        var span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        var region = MKCoordinateRegion(center: newLocation.coordinate, span: span)
        self.mainMapView.setRegion(region, animated: true)
        self.mainMapView.showsUserLocation = true
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        // this sets the current location to center in the map
        var span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        var region = MKCoordinateRegion(center: manager.location.coordinate, span: span)
        self.mainMapView.setRegion(region, animated: true)
        self.mainMapView.showsUserLocation = true
        
        // loop through attractions
        for attraction in attractions  {
            
            // get flying distance
            let startinglocation = manager.location;
            let endingLocation = CLLocation(latitude: attraction.Latitude, longitude: attraction.Longitude)
            let distance = startinglocation.distanceFromLocation(endingLocation)
            
            attraction.FlyingDistance = distance
        }
        
        attractions.sort({ $0.FlyingDistance < $1.FlyingDistance })
        
        var counter = 0
        var prevMapItem = MKMapItem?()
        for attraction in attractions  {
            
            // get walking distance
            let req = MKDirectionsRequest()
            
            let startingCoordinate = manager.location.coordinate
            let startingPlaceMark = MKPlacemark(coordinate: startingCoordinate, addressDictionary: nil)
            let startingMapItem = MKMapItem(placemark: startingPlaceMark)
            
            let endingCoordinate = CLLocationCoordinate2D(latitude: attraction.Latitude, longitude: attraction.Longitude)
            let endingPlaceMark = MKPlacemark(coordinate: endingCoordinate, addressDictionary: nil)
            let endingMapItem = MKMapItem(placemark: endingPlaceMark)
            
            if (counter != 0) {
                req.setSource(prevMapItem) }
            else {
                req.setSource(startingMapItem) }
            
            req.transportType = MKDirectionsTransportType.Walking
            req.requestsAlternateRoutes = false
            req.setDestination(endingMapItem)
            
            prevMapItem = endingMapItem
            
            // Call Directions API
            let dir = MKDirections(request:req)
            dir.calculateDirectionsWithCompletionHandler() {
                (response:MKDirectionsResponse!, error:NSError!) in
                if response == nil {
                    println(error)
                    return
                }
                let route = response.routes[0] as MKRoute
                let poly = route.polyline
                self.mainMapView.addOverlay(poly)
                attraction.WalkingDistance = route.distance
            }
            
            counter = counter + 1
            
        }
        
        
        /*
        for attraction in attractions  {
            
            // get flying distance
            let startinglocation = manager.location;
            let endingLocation = CLLocation(latitude: attraction.Latitude, longitude: attraction.Longitude)
            let distance = startinglocation.distanceFromLocation(endingLocation)
            
            attraction.FlyingDistance = distance
            
            // get walking distance
            let req = MKDirectionsRequest()
            
            let startingCoordinate = manager.location.coordinate
            let startingPlaceMark = MKPlacemark(coordinate: startingCoordinate, addressDictionary: nil)
            let startingMapItem = MKMapItem(placemark: startingPlaceMark)
            
            let endingCoordinate = CLLocationCoordinate2D(latitude: attraction.Latitude, longitude: attraction.Longitude)
            let endingPlaceMark = MKPlacemark(coordinate: endingCoordinate, addressDictionary: nil)
            let endingMapItem = MKMapItem(placemark: endingPlaceMark)
            
            req.setSource(startingMapItem)
            req.transportType = MKDirectionsTransportType.Walking
            req.requestsAlternateRoutes = false
            req.setDestination(endingMapItem)
            
            let dir = MKDirections(request:req)
            dir.calculateDirectionsWithCompletionHandler() {
                (response:MKDirectionsResponse!, error:NSError!) in
                if response == nil {
                    println(error)
                    return
                }
                let route = response.routes[0] as MKRoute
                let poly = route.polyline
                self.mainMapView.addOverlay(poly)
                attraction.WalkingDistance = route.distance
            }
        }*/
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        var v : MKPolylineRenderer! = nil
        if let overlay = overlay as? MKPolyline {
            v = MKPolylineRenderer(polyline:overlay)
            v.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.8)
            v.lineWidth = 2
        }
        return v
    }

}

