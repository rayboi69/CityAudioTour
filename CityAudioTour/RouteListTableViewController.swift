//
//  RouteListTableViewController.swift
//  CityAudioTour
//
//  Created by Red_iMac on 3/1/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit

class RouteListTableViewController: UITableViewController {

    var sectionTitle = "Route List"
    var server = CATAzureService()
    var routes: [Route]!
    
    func prepareSelectRoute(row: Int) -> [Attraction] {
        // TODO: implement this method
        //println(routes[row].AttractionIDs)
        var attractions = AttractionsModel.sharedInstance.attractionsList!
        var selectRoute = [Attraction]()
        selectRoute.append(attractions[1])
        selectRoute.append(attractions[2])
        selectRoute.append(attractions[3])
        return selectRoute
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routes = server.GetRoutes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RouteCell", forIndexPath: indexPath) as UITableViewCell
        // Configure the cell...
        let route = routes![indexPath.row]
        cell.textLabel?.text = route.Name
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
                case "SentRouteToMapView":
                    if let indexPath = self.tableView.indexPathForSelectedRow() {
                        let mapScene = segue.destinationViewController as MainMapViewController
                        mapScene.selectedAttraction = self.prepareSelectRoute(indexPath.row)
                    }
                default: break
            }
        }
    }

}
