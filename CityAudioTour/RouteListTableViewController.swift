//
//  RouteListTableViewController.swift
//  CityAudioTour
//
//  Created by Red_iMac on 3/1/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit

class RouteListTableViewController: UITableViewController {

    var server = CATAzureService()
    var routes: [Route]!
    var selectRoute: [Attraction]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routes = server.GetRoutes()
        selectRoute = [Attraction]()
        
        //test with fake data
        var a = AttractionsModel.sharedInstance.attractionsList!
        selectRoute.append(a[1])
        selectRoute.append(a[2])
        selectRoute.append(a[3])
        selectRoute.append(a[4])
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
                case "SentRouteToMapView":
                    if let indexPath = self.tableView.indexPathForSelectedRow() {
                        let mapScene = segue.destinationViewController as MainMapViewController
                        mapScene.selectedAttraction = selectRoute
                    }
                default: break
            }
        }
    }

}
