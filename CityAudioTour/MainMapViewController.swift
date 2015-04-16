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

class MainMapViewController: UIViewController,UIAlertViewDelegate{
    
    //Interacting UI Elements
    @IBOutlet weak var mainMapView: MKMapView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var autoComplete: UITableView!
    @IBOutlet weak var detailBox: UILabel!
    @IBOutlet weak var hoursBox: UILabel!
    @IBOutlet weak var addressBox: UILabel!
    @IBOutlet weak var titleBtn: UIButton!
    //Element in Detail PopUp View
    @IBOutlet weak var DetailPopUpView: UIView!
    
    
    //All variables for this class
    private let requestLocation:MKDirectionsRequest = MKDirectionsRequest()
    private let locationManager = CLLocationManager()
    private var detailPopController:DetailPopUp!
    private var mapController:MapDelegate!
    private var menuController:MenuController!
    private var searchBarController:SearchBarDelegate!
    private var selectedAttractionId : Int?
   
    //Models
    private var routesManager = RoutesManager.sharedInstance
    private var attractionsModel = AttractionsManager.sharedInstance
    //Source and Destination coodinates for route steps.
    private var source:CLLocationCoordinate2D!
    private var destination:CLLocationCoordinate2D!

    //Current Location button that update user's current location.
    @IBAction func buttonCurrentLocation(sender: AnyObject) {
        mapController.currentBtnisClicked()
        locationManager.startUpdatingLocation()
    }
    
    //Menu button can hide or show a hidden menu.
    @IBAction func MenuBtn(sender: AnyObject) {
        if !menuController.isMenuShowing() {
            menuController.MenuShown()
            detailPopController.hideDetailPopUp()
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
    //Refresh map screen to show all current attractions on the map.
    @IBAction func ShowAll(sender: AnyObject) {
        routesManager.selectedRoute = nil
        attractionsModel.isAttractionsListChanged = false
        mapController.wantPinPoint()
        locationManager.startUpdatingLocation()
    }
    
    //Play an audio for this attraction.
    @IBAction func PlayBtn(sender: AnyObject) {
        //How are we gonna do with this button
    }
    
    //Start turn by turn system.
    //For Rey Raso, implement your logic here
    @IBAction func NavigatorBtn(sender: AnyObject) {
        
        let attractionName:String? = titleBtn.titleLabel?.text
        
        // set destination
        var destinationPlacemark:MKPlacemark = MKPlacemark(coordinate: destination, addressDictionary:nil)
        
        var destinationMapItem:MKMapItem = MKMapItem(placemark: destinationPlacemark)
        destinationMapItem.name = attractionName
        
        // set source as currentLocation
        var currentLocationMapItem:MKMapItem = MKMapItem.mapItemForCurrentLocation()
        
        // set launchOptions
        let launchOptions:NSDictionary = NSDictionary(object: MKLaunchOptionsDirectionsModeWalking, forKey: MKLaunchOptionsDirectionsModeKey)
        
        // open Maps
        MKMapItem.openMapsWithItems([currentLocationMapItem, destinationMapItem], launchOptions: launchOptions as [NSObject : AnyObject])
    }
    
    //Add the attraction to custom route
    @IBAction func AddCustomRouteBtn(sender: AnyObject) {
        let attractionName:String? = titleBtn.titleLabel?.text
        if objc_getClass("UIAlertController") != nil {
            var alert = UIAlertController(title: "Add " + attractionName!, message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: addCustomHandler))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            var alert = UIAlertView(title: "Add " + attractionName!, message: "Are you sure?", delegate: self, cancelButtonTitle: "Yes", otherButtonTitles: "No")
            alert.alertViewStyle = UIAlertViewStyle.Default
            alert.show()
        }

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
        
        //Set up detail pop up view
        detailPopController = DetailPopUp(popUpView: DetailPopUpView,mainView: self.view)
        
        //Set up Flyout menu
        menuController = MenuController(MenuView: menuView, MainView: self.view, PopUp: detailPopController)
        
        //Set up map view delegate
        mapController = MapDelegate(mapView: self,detailPopUpController: detailPopController)
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
    
    //For Red, implement the adding custom route logic here. (For IOS 8)
    private func addCustomHandler(alert:UIAlertAction!) -> Void{
        var myRoute = SelectAttractionsManager.sharedInstance
        myRoute.addAttraction(selectedAttractionId!)
    }
    
    //For Red, implement the adding custom route logic here. (For IOS 7)
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        var title = alertView.buttonTitleAtIndex(buttonIndex)
        
        if (title ==  "Yes"){
            //implement the adding custom route logic here.
            var myRoute = SelectAttractionsManager.sharedInstance
            myRoute.addAttraction(selectedAttractionId!)
        }
    }
    
    //When the button in call out window is pressed, it will go to detail page.
    func gotoDetailPage(ID:Int){
        
        selectedAttractionId = ID
        
        self.performSegueWithIdentifier("detailview", sender: self)
    }
    
    func setSelectedID(ID:Int){
        selectedAttractionId = ID
    }
    
    func setPeerToPeerRoute(source:CLLocationCoordinate2D,destination:CLLocationCoordinate2D){
        self.source = source
        self.destination = destination
    }
    
    //show alert box if some error occurs
    func showMessage(title:String,message:String){
        if objc_getClass("UIAlertController") != nil {
            var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            var alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
            alert.alertViewStyle = UIAlertViewStyle.Default
            alert.show()
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let identifier = segue.identifier {
            switch identifier {
            case "detailview", "PopupDetail":
                let detailScene = segue.destinationViewController as! DetailViewController
                detailScene.receiveID = selectedAttractionId
            case "RouteStepView":
                let routeStepScene = segue.destinationViewController as! RouteStepPage
                routeStepScene.source = source
                routeStepScene.destination = destination
                routeStepScene.attractionName = titleBtn.currentTitle
            case "MenuToMyRoute":
                let selectAttractionScene = segue.destinationViewController as! SelectAttractionsTableViewController
                selectAttractionScene.identify = "My Route"
            default: break
            }
        }
    }
}



