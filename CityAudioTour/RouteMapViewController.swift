//
//  RouteMapViewController.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 5/7/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RouteMapViewController: UIViewController {
    
    @IBOutlet weak var RNameLabel: UILabel!
    @IBOutlet weak var attractNameLabel: UIButton!
    @IBOutlet weak var addrLabel: UILabel!
    @IBOutlet weak var routeMap: MKMapView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var prevBtn: UIButton!
    
    
    private let requestLocation:MKDirectionsRequest = MKDirectionsRequest()
    private let locationManager = CLLocationManager()
    private let latitudeMeter:CLLocationDistance = 5000
    private let longitudeMeter:CLLocationDistance = 5000
    private let attractionManager:AttractionsManager = AttractionsManager.sharedInstance
    private var managerDelegate:LCManagerDelegate!
    private var checkTimer:NSTimeInterval = 30.0
    private var checkNewLocation:NSTimer!
    private var mapDelegate:RouteMapDelegate!
    private var pinList:[MKAnnotation] = [MKAnnotation]()
    var route:Route!
    var attractIndex:Int = 0
    var attractList:[Attraction] = [Attraction]()
    
    
    @IBAction func removeBtn(sender: AnyObject) {
    }
    
    @IBAction func NaviBtn(sender: AnyObject) {
        
        if(pinList.isEmpty || attractList.isEmpty){
            var alert:UIAlertController = UIAlertController(title: "Error Message!", message: "No attraction information retrieved. Please check Internet Connection.", preferredStyle: UIAlertControllerStyle.Alert)
            var OKBtn:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            
            alert.addAction(OKBtn)
            self.presentViewController(alert, animated: true, completion: nil)
            return;
        }
        
        if (CLLocationManager.authorizationStatus() ==  CLAuthorizationStatus.Denied || locationManager.location == nil) {
            
            var alert:UIAlertController = UIAlertController(title: "GPS system was disable!", message: "Please enable GPS system before using navigator.", preferredStyle: UIAlertControllerStyle.Alert)
            var OKBtn:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            
            alert.addAction(OKBtn)
            self.presentViewController(alert, animated: true, completion: nil)
            return;
        }
        
        let pin = pinList[attractIndex] as! pinHolder
        let attractionName:String? = pin.attraction.AttractionName
        let destination:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: pin.attraction.Latitude, longitude: pin.attraction.Longitude)
        // set destination
        var destinationPlacemark:MKPlacemark = MKPlacemark(coordinate: destination, addressDictionary:nil)
        
        var destinationMapItem:MKMapItem = MKMapItem(placemark: destinationPlacemark)
        destinationMapItem.name = attractionName
        
        // set source as currentLocation
        var currentLocationMapItem:MKMapItem = MKMapItem.mapItemForCurrentLocation()
        
        // set launchOptions
        let launchOptions:NSDictionary = NSDictionary(object: MKLaunchOptionsDirectionsModeWalking, forKey: MKLaunchOptionsDirectionsModeKey)
        
        // iOS8
        var alert = UIAlertController(title: "Open in Apple Maps", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            // open Maps
            MKMapItem.openMapsWithItems([currentLocationMapItem, destinationMapItem], launchOptions: launchOptions as [NSObject : AnyObject])
        }))
        
        // don't do anything for No
        alert.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func currBtn(sender: AnyObject) {
        
        if (CLLocationManager.authorizationStatus() ==  CLAuthorizationStatus.Denied || locationManager.location == nil) {
            return;
        }
        
        if (managerDelegate.location != nil){
            var camera:MKCoordinateRegion! = MKCoordinateRegionMakeWithDistance(managerDelegate.location!.coordinate, latitudeMeter, longitudeMeter)
            routeMap.setRegion(camera, animated: true)
        }
    }
    
    @IBAction func nextAttract(sender: AnyObject) {
        
        if(pinList.isEmpty || attractList.isEmpty){
            return;
        }
        
        attractIndex++;
        prevBtn.hidden = false;
        prevBtn.enabled = true;
        
        routeMap.selectAnnotation(pinList[attractIndex], animated: true)
        var camera:MKCoordinateRegion! = MKCoordinateRegionMakeWithDistance(pinList[attractIndex].coordinate, latitudeMeter, longitudeMeter)
        routeMap.setRegion(camera, animated: true)
        
        attractNameLabel.setTitle(attractList[attractIndex].AttractionName, forState: UIControlState.Normal)
        addrLabel.text = attractList[attractIndex].AttractionAddress
        
        if attractIndex == pinList.count {
            nextBtn.enabled = false
            nextBtn.hidden = true
        }
        
    }
    
    @IBAction func prevAttract(sender: AnyObject) {
        
        if(pinList.isEmpty || attractList.isEmpty){
            return;
        }
        
        attractIndex--;
        nextBtn.hidden = false;
        nextBtn.enabled = true;
        routeMap.selectAnnotation(pinList[attractIndex], animated: true)
        var camera:MKCoordinateRegion! = MKCoordinateRegionMakeWithDistance(pinList[attractIndex].coordinate, latitudeMeter, longitudeMeter)
        routeMap.setRegion(camera, animated: true)
        attractNameLabel.setTitle(attractList[attractIndex].AttractionName, forState: UIControlState.Normal)
        addrLabel.text = attractList[attractIndex].AttractionAddress
        
        if attractIndex == 0 {
            prevBtn.enabled = false
            prevBtn.hidden = true
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        if checkNewLocation != nil {
            checkNewLocation.invalidate()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        checkAuthority()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managerDelegate = LCManagerDelegate()
        managerDelegate.popupWindow = warningSign
        managerDelegate.passAuthorize = getAuthorized
        
        locationManager.delegate = managerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapDelegate = RouteMapDelegate(routeView: self)
        routeMap.delegate = mapDelegate
        routeMap.showsUserLocation = true
        startPinning()
        checkAuthority()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAuthorized() -> Void {
        
        locationManager.startUpdatingLocation()
        checkNewLocation = NSTimer.scheduledTimerWithTimeInterval(checkTimer, target: self, selector: Selector("reRoute"), userInfo: nil, repeats: true)
    }
    
    func warningSign() -> Void {
        var alert:UIAlertController = UIAlertController(title: "Location service is not enabled!", message: "You can enable in Settings->Privacy->Location->Location Services.", preferredStyle: UIAlertControllerStyle.Alert)
        var settingBtn:UIAlertAction = UIAlertAction(title: "Setting", style: UIAlertActionStyle.Default, handler: {(action)-> Void in
            UIApplication.sharedApplication().openURL(NSURL (string: UIApplicationOpenSettingsURLString)!)
        })
        var cancelBtn:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(settingBtn)
        alert.addAction(cancelBtn)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func startPinning(){
        route = RoutesManager.sharedInstance.selectedRoute!
        RNameLabel.text = route.Name
        var attractID = route.AttractionIDs
        for ID in attractID {
            attractList.append(attractionManager.GetAttractionBy(ID)!)
        }
        
        pinList.removeAll(keepCapacity: false)
        routeMap.removeAnnotations(routeMap.annotations)
        
        prevBtn.hidden = true;
        prevBtn.enabled = false;
        
        if(attractList.isEmpty){
            nextBtn.hidden = true;
            nextBtn.enabled = false;
            attractNameLabel.setTitle("", forState: UIControlState.Normal)
            addrLabel.text = ""
            return
        }
        
        var index:Int = 1
        
        for attract in attractList{
            var pin:MKPointAnnotation = pinHolder(attraction: attract,index: index);
            pin.title = attract.AttractionName
            pin.coordinate.latitude = attract.Latitude
            pin.coordinate.longitude = attract.Longitude
            pinList.append(pin)
            index++;
        }
        
        routeMap.addAnnotations(pinList)
        routeMap.selectAnnotation(pinList[self.attractIndex], animated: true)
        var camera:MKCoordinateRegion! = MKCoordinateRegionMakeWithDistance(pinList[self.attractIndex].coordinate, latitudeMeter, longitudeMeter)
        routeMap.setRegion(camera, animated: false)
        
        if (pinList.count == 1){
            nextBtn.hidden = true;
            nextBtn.enabled = false;
        }
        
        if (CLLocationManager.authorizationStatus() !=  CLAuthorizationStatus.Denied && locationManager.location != nil) {
            reRoute()
        }
    }
    
    func reRoute(){
        // remove existing route lines or overlays when this method starts
        if (locationManager.location == nil){
            return
        }
        routeMap.removeOverlays(routeMap.overlays)
        println("Route is called.")
        var counter = 0
        var prevMapItem = MKMapItem?()
        
        for attraction in attractList  {
            
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
            
            requestLocation.transportType = MKDirectionsTransportType.Automobile
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
                
                let routeList = response.routes as! [MKRoute]
                
                for route in routeList{
                    for step in route.steps as! [MKRouteStep]{
                        self.routeMap.addOverlay(step.polyline)
                    }
                    attraction.WalkingDistance = route.distance
                }
            })
            counter++
        }
        
    }
    
    private func checkAuthority(){
        if CLLocationManager.authorizationStatus() !=  CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
            if (checkNewLocation != nil){
                checkNewLocation.invalidate()
            }
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if attractList.isEmpty {
            var alert:UIAlertController = UIAlertController(title: "Error Message!", message: "No attraction information retrieved. Please check Internet Connection.", preferredStyle: UIAlertControllerStyle.Alert)
            var OKBtn:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            
            alert.addAction(OKBtn)
            self.presentViewController(alert, animated: true, completion: nil)
            return;
        }
        
        if (segue.identifier == "toDetailPage") {
            var detailPage:DetailViewController = segue.destinationViewController as! DetailViewController
            detailPage.recvattract = attractList[attractIndex]
        }else if (segue.identifier == "toAudio"){
            let audioViewController:AudioTourViewController = segue.destinationViewController as! AudioTourViewController
            audioViewController.receiveID = attractList[attractIndex].AttractionID
            
        }
    }
    
    
}
