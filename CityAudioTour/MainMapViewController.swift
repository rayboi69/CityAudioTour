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

class MainMapViewController: UIViewController{
    
    //Interacting UI Elements
    @IBOutlet weak var mainMapView: MKMapView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var autoComplete: UITableView!
    
    //All variables for this class
    private let requestLocation:MKDirectionsRequest = MKDirectionsRequest()
    private let locationManager = CLLocationManager()
    private var mapController:MapDelegate!
    private var menuController:MenuController!
    private var searchBarController:SearchBarDelegate!
    private var selectedAttractionId : Int?
    private var isConnected:Bool = true
    //Models
    private var routesManager = RoutesManager.sharedInstance
    private var attractionsModel = AttractionsManager.sharedInstance
    
    
    //Current Location button that update user's current location.
    @IBAction func buttonCurrentLocation(sender: AnyObject) {
        mapController.currentBtnisClicked()
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
    
    //Satellite button
    @IBAction func SatelliteBtn(sender: AnyObject) {
        if mainMapView.mapType != MKMapType.Satellite {
            mainMapView.mapType = MKMapType.Satellite
        }
    }
    //Standard button
    @IBAction func StandardBtn(sender: AnyObject) {
        if mainMapView.mapType != MKMapType.Standard {
            mainMapView.mapType = MKMapType.Standard
        }
    }
    //Temporary method
    @IBAction func ShowAll(sender: AnyObject) {
        routesManager.selectedRoute = nil
        attractionsModel.isAttractionsListChanged = false
        mapController.wantPinPoint()
        locationManager.startUpdatingLocation()
    }
    //Hide Navigator bar when main screen is appeared.
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if routesManager.selectedRoute != nil || attractionsModel.isAttractionsListChanged {
            mapController.wantPinPoint()
            attractionsModel.isAttractionsListChanged = false
        }
        locationManager.startUpdatingLocation()
    }
    
    //Show Navigator bar when moving to other views.
    override func viewDidDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        routesManager.selectedRoute = nil
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
        
        //Set up map view delegate
        mapController = MapDelegate(mapView: self)
        mainMapView.delegate = mapController
        mainMapView.showsUserLocation = true
        
        //Set up searchBar delegate
        searchBarController = SearchBarDelegate(mapView: self,mapController: mapController)
        searchBar.delegate = searchBarController
        
        //Set up tableView Delegate
        autoComplete.delegate = searchBarController
        autoComplete.dataSource = searchBarController
        autoComplete.hidden = true
        
        //Set up location manager delegate
        locationManager.delegate = mapController
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // this if statement is required because the statement requestWhenInUseAuthorization will fail
        // on iOS versions lower than 8.0
        if (locationManager.respondsToSelector(Selector("requestWhenInUseAuthorization"))) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        //In case no internet connection. 
        
//        if attractionsModel.attractionsList.isEmpty{
//            showMessage()
//            return
//        }
        
        //Start getting user's current location when application's started.
        locationManager.startUpdatingLocation()
        
    }
    
    //When the button in call out window is pressed, it will go to detail page.
    func gotoDetailPage(view:MKAnnotationView!){
        
        var annotation = view.annotation
        
        for attraction in attractionsModel.attractionsList  {
            
            if (annotation.title == attraction.AttractionName &&
                annotation.coordinate.latitude == attraction.Latitude &&
                annotation.coordinate.longitude == attraction.Longitude)
            {
                selectedAttractionId = attraction.AttractionID
            }
        }
        
        self.performSegueWithIdentifier("detailview", sender: self)
    }
    
    //Handle error later. In case no internet connection
    
//    private func showMessage(){
//        if objc_getClass("UIAlertController") != nil {
//            var alert = UIAlertController(title: "No Internet Connection", message: "Please Check Internet Connection!", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//        }else{
//            var alert = UIAlertView(title: "No Internet Connection", message: "Please Check Internet Connection!", delegate: nil, cancelButtonTitle: "OK")
//            alert.alertViewStyle = UIAlertViewStyle.Default
//            alert.show()
//        }
//
//        isConnected = false
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "detailview") {
            var detailController:DetailViewController = segue.destinationViewController as DetailViewController
            detailController.receiveID = selectedAttractionId
        }else if(segue.identifier == "RoutePage"){
            var routeController:RouteListTableViewController = segue.destinationViewController as RouteListTableViewController
        }
    }
}

