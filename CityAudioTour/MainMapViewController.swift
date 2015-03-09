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
    
    //Interacting UI Elements
    @IBOutlet weak var mainMapView: MKMapView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //All variables for this class
    private let searchBarController:SearchBarDelegate = SearchBarDelegate()
    private let requestLocation:MKDirectionsRequest = MKDirectionsRequest()
    private let locationManager = CLLocationManager()
    private var mapController:MapDelegate!
    private var menuController:MenuController!
    private var selectedAttractionId : Int?
    private var attractions = [Attraction]()
    //Refer to attraction list selected by users after filtering.
    var selectedAttraction:[Attraction] = [Attraction]()
    var isRouteSelected:Bool = false;
    
    //Current Location button that update user's current location.
    @IBAction func buttonCurrentLocation(sender: AnyObject) {
        mapController.buttonIsPressed()
        locationManager.startUpdatingLocation()
    }
    
    //Menu button can hide or show a hidden menu.
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
        //If selectedAttraction is not empty, that means user select some route or filter it.
        selectedAttraction = AttractionsModel.sharedInstance.selectAttractions
        if !selectedAttraction.isEmpty{
            createPinPoint()
        }
    }
    //Show Navigator bar when moving to other views.
    override func viewDidDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        menuController.MenuHidden()
    }
    
    //Starting method when view is completely loaded.
    override func viewDidLoad() {
        super.viewDidLoad()

        startUpSetting()
    }
    
    //Send a warning if OS destroys this app for regaining memory.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Setting up everything in this view.
    private func startUpSetting(){
        //Set up Flyout menu
        menuController = MenuController(MenuView: menuView, MainView: self.view)
        
        //Set up searchBar delegate
        searchBar.delegate = searchBarController
        //Set up map view delegate
        mapController = MapDelegate(mapView: self)
        mainMapView.delegate = mapController
        
        //Set up location manager delegate
        locationManager.delegate = mapController
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // this if statement is required because the statement requestWhenInUseAuthorization will fail
        // on iOS versions lower than 8.0
        if (locationManager.respondsToSelector(Selector("requestWhenInUseAuthorization"))) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        //Start getting user's current location when application's started.
        locationManager.startUpdatingLocation()
        mainMapView.showsUserLocation = true
        //Create all pin points on the map based on attraction list.
        createPinPoint()
    }
    
    //Create all annotations on the map.
    private func createPinPoint(){
        //Clear all old annotation
        let oldAnnotationList = mainMapView.annotations
        mainMapView.removeAnnotations(oldAnnotationList)
        
        if !selectedAttraction.isEmpty{
            attractions = selectedAttraction
        }else{
            // Webservice call to get attractions
            attractions = AttractionsModel.sharedInstance.attractionsList!
        }
        
        // loop through attractions
        for attraction in attractions  {
            if !attraction.isHiden {
                var pin = MKPointAnnotation()
                pin.title = attraction.AttractionName
                pin.coordinate.latitude = attraction.Latitude
                pin.coordinate.longitude = attraction.Longitude
                
                // Add Pin to Map
                self.mainMapView.addAnnotation(pin)
            }
        }
        //Start creating route based on attraction list.
        createRoute()
    }
    
    //Creating route in the map based on attraction list.
    private func createRoute(){
        // remove existing route lines or overlays when this method starts
        var oldOverlays = mainMapView.overlays
        mainMapView.removeOverlays(oldOverlays)
        
        if isRouteSelected{
            // loop through attractions
            for attraction in attractions  {
                // get flying distance
                let startinglocation = locationManager.location
                let endingLocation = CLLocation(latitude: attraction.Latitude, longitude: attraction.Longitude)
                let distance = startinglocation.distanceFromLocation(endingLocation)
        
                attraction.FlyingDistance = distance
            }
        
            attractions.sort({ $0.FlyingDistance < $1.FlyingDistance })
        
            var counter = 0
            var prevMapItem = MKMapItem?()
            
            for attraction in attractions  {
        
                // get walking distance
        
                let startingCoordinate = locationManager.location.coordinate
                let startingPlaceMark = MKPlacemark(coordinate: startingCoordinate, addressDictionary: nil)
                let startingMapItem = MKMapItem(placemark: startingPlaceMark)
        
                let endingCoordinate = CLLocationCoordinate2D(latitude: attraction.Latitude, longitude: attraction.Longitude)
                let endingPlaceMark = MKPlacemark(coordinate: endingCoordinate, addressDictionary: nil)
                let endingMapItem = MKMapItem(placemark: endingPlaceMark)
        
                if (counter != 0) {
                    requestLocation.setSource(prevMapItem)
                }else {
                    requestLocation.setSource(startingMapItem)
                }
        
                requestLocation.transportType = MKDirectionsTransportType.Walking
                requestLocation.requestsAlternateRoutes = false
                requestLocation.setDestination(endingMapItem)
        
                prevMapItem = endingMapItem
        
                // Call Directions API
                let direction:MKDirections = MKDirections(request:requestLocation)
                direction.calculateDirectionsWithCompletionHandler({
                    (response:MKDirectionsResponse!, error:NSError!) -> Void in
                        if response == nil {
                            println(error)
                            return
                        }
                
                        let routeList = response.routes as [MKRoute]
                
                        for route in routeList{
                            for step in route.steps as [MKRouteStep]{
                                self.mainMapView.addOverlay(step.polyline)
                            }
                            attraction.WalkingDistance = route.distance
                        }
                })
                counter = counter + 1
            }
            isRouteSelected = false
        }
    }

    //When the button in call out window is pressed, it will go to detail page.
    func gotoDetailPage(view:MKAnnotationView!){
        
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
}

