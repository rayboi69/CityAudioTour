//
//  RouteStepPage.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 4/9/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit
import MapKit

class RouteStepPage: UITableViewController {
    
    //Step list
    private var steps:[String] = [String]()
    //Main elements for requesting step instructions.
    var source:CLLocationCoordinate2D!
    var destination:CLLocationCoordinate2D!
    var attractionName:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requireStep()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Route", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = steps[indexPath.row]
        cell.textLabel?.numberOfLines = 3

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Route steps for " + attractionName
    }
    //Request step instructions and show on the table.
    private func requireStep(){
        let startingPlaceMark = MKPlacemark(coordinate: source, addressDictionary: nil)
        let startingMapItem = MKMapItem(placemark: startingPlaceMark)
        
        let endingPlaceMark = MKPlacemark(coordinate: destination, addressDictionary: nil)
        let endingMapItem = MKMapItem(placemark: endingPlaceMark)
        
        let requestMessage:MKDirectionsRequest = MKDirectionsRequest()
        requestMessage.transportType = MKDirectionsTransportType.Automobile
        requestMessage.requestsAlternateRoutes = false
        requestMessage.setSource(startingMapItem)
        requestMessage.setDestination(endingMapItem)
        
        let direction:MKDirections = MKDirections(request:requestMessage)
        direction.calculateDirectionsWithCompletionHandler({
            (response:MKDirectionsResponse!, error:NSError!) -> Void in
            //If response is nil, there is something wrong with connection
            if response == nil {
                self.alertMessage()
            }else{
                let routeList = response.routes as! [MKRoute]
                
                for route in routeList {
                    for step in route.steps as! [MKRouteStep]{
                        self.steps.append(step.instructions)
                    }
                }
                self.tableView.reloadData()
            }
        })
    }
    
    //Show an alert message if can't get data from server.
    private func alertMessage(){
        if objc_getClass("UIAlertController") != nil {
            var alert = UIAlertController(title: "Error: Can't get information", message: "Please Check Internet Connection!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            var alert = UIAlertView(title: "Error: Can't get information", message: "Please Check Internet Connection!", delegate: nil, cancelButtonTitle: "OK")
            alert.alertViewStyle = UIAlertViewStyle.Default
            alert.show()
        }

    }
    
}
