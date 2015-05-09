//
//  AttractionMapController.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 5/7/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AttractionMapController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var NameLabel: UIButton!
    @IBOutlet weak var addrLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var DetailBox: UITextView!
    @IBOutlet weak var OpenHoursBox: UITextView!
    @IBOutlet weak var miniPopUpDetail: UIVisualEffectView!
    @IBOutlet weak var innerView: UIView!
    
    private let locationManager = CLLocationManager()
    private let latitudeMeter:CLLocationDistance = 5000
    private let longitudeMeter:CLLocationDistance = 5000
    private var managerDelegate:LCManagerDelegate!
    private var checkTimer:NSTimeInterval = 10.0
    private var checkDistance:NSTimer!
    private var mapDelegate:AttractionMapDelegate!
    private var pinList:[MKAnnotation] = [MKAnnotation]()
    private var detailPopUpController:DetailPopUp!
    var index:Int = 0
    var list:[Attraction]!
    
    @IBAction func currentBtn(sender: AnyObject) {
        if (managerDelegate.location != nil){
            var camera:MKCoordinateRegion! = MKCoordinateRegionMakeWithDistance(managerDelegate.location!.coordinate, latitudeMeter, longitudeMeter)
            mapView.setRegion(camera, animated: true)
        }
    }
    
    @IBAction func nextAttractBtn(sender: AnyObject) {
        index++;
        prevBtn.hidden = false;
        prevBtn.enabled = true;
        
        mapView.selectAnnotation(pinList[index], animated: true)
        var camera:MKCoordinateRegion! = MKCoordinateRegionMakeWithDistance(pinList[index].coordinate, latitudeMeter, longitudeMeter)
        mapView.setRegion(camera, animated: true)
        
        NameLabel.setTitle(list[index].AttractionName, forState: UIControlState.Normal)
        addrLabel.text = list[index].AttractionAddress
        distanceLabel.text = "\(list[index].Distance) miles"
        DetailBox.text = list[index].Detail
        
        if index == pinList.count {
            nextBtn.enabled = false
            nextBtn.hidden = true
        }

    }
    
    
    @IBAction func prevAttractBtn(sender: AnyObject) {
        index--;
        nextBtn.hidden = false;
        nextBtn.enabled = true;
        mapView.selectAnnotation(pinList[index], animated: true)
        var camera:MKCoordinateRegion! = MKCoordinateRegionMakeWithDistance(pinList[index].coordinate, latitudeMeter, longitudeMeter)
        mapView.setRegion(camera, animated: true)
        NameLabel.setTitle(list[index].AttractionName, forState: UIControlState.Normal)
        addrLabel.text = list[index].AttractionAddress
        distanceLabel.text = "\(list[index].Distance) miles"
        DetailBox.text = list[index].Detail
        
        if index == 0 {
            prevBtn.enabled = false
            prevBtn.hidden = true
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        checkAuthority()
    }
    
    override func viewDidDisappear(animated: Bool) {
        locationManager.stopUpdatingLocation()
        if (checkDistance != nil){
            checkDistance.invalidate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailPopUpController = DetailPopUp(popUpView: miniPopUpDetail, mainView: self.view)
        
        managerDelegate = LCManagerDelegate()
        managerDelegate.popupWindow = warning
        managerDelegate.passAuthorize = isAuthorized
        managerDelegate.attractList = list
        
        locationManager.delegate = managerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapDelegate = AttractionMapDelegate(controller: self);
        
        mapView.delegate = mapDelegate;
        mapView.showsUserLocation = true
        
        checkAuthority()
    }

    func warning() -> Void{
        var alert:UIAlertController = UIAlertController(title: "Location service is not enabled!", message: "You can enable in Settings->Privacy->Location->Location Services.", preferredStyle: UIAlertControllerStyle.Alert)
        var settingBtn:UIAlertAction = UIAlertAction(title: "Setting", style: UIAlertActionStyle.Default, handler: {(action)-> Void in
            UIApplication.sharedApplication().openURL(NSURL (string: UIApplicationOpenSettingsURLString)!)
        })
        var cancelBtn:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(settingBtn)
        alert.addAction(cancelBtn)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func isAuthorized() -> Void{
        println("AuthorizedWhenInUse");
        distanceLabel.hidden = false
        managerDelegate.attractList = list
        locationManager.startUpdatingLocation()
        
        checkDistance = NSTimer.scheduledTimerWithTimeInterval(checkTimer, target: self, selector: Selector("updateDistance"), userInfo: nil, repeats: true)
    }
    
    func updateDistance() {
        if !list.isEmpty {
            distanceLabel.text = "\(list[index].Distance) miles"
        }
    }
    
    func CreatePinPoint(){
        
        pinList.removeAll(keepCapacity: false)
        mapView.removeAnnotations(mapView.annotations)
        
        prevBtn.hidden = true;
        prevBtn.enabled = false;
        
        if(list.isEmpty){
            nextBtn.hidden = true;
            nextBtn.enabled = false;
            NameLabel.setTitle("", forState: UIControlState.Normal)
            addrLabel.text = ""
            distanceLabel.text = ""
            DetailBox.text = ""
            return
        }
        
        var index:Int = 1
        
        managerDelegate.attractList = list
        
        for attract in list{
            var pin:MKPointAnnotation = pinHolder(attraction: attract,index: index);
            pin.title = attract.AttractionName
            pin.coordinate.latitude = attract.Latitude
            pin.coordinate.longitude = attract.Longitude
            pinList.append(pin)
            index++;
        }
        
        mapView.addAnnotations(pinList)
        mapView.selectAnnotation(pinList[self.index], animated: true)
        var camera:MKCoordinateRegion! = MKCoordinateRegionMakeWithDistance(pinList[self.index].coordinate, latitudeMeter, longitudeMeter)
        mapView.setRegion(camera, animated: false)
        
        if (pinList.count == 1){
            nextBtn.hidden = true;
            nextBtn.enabled = false;
        }
        
    }
        
    private func checkAuthority(){
        if CLLocationManager.authorizationStatus() ==  CLAuthorizationStatus.AuthorizedWhenInUse {
            isAuthorized()
        }else{
            managerDelegate.popupWindow = warning
            managerDelegate.passAuthorize = isAuthorized
            locationManager.requestWhenInUseAuthorization()
            distanceLabel.hidden = true
            if (checkDistance != nil ){
                checkDistance.invalidate()
            }
            locationManager.stopUpdatingLocation()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toDetail") {
            var audioViewController:DetailViewController = segue.destinationViewController as! DetailViewController
            audioViewController.recvattract = list[index]
        }
    }

}
