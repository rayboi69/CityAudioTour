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
    private var routesModel = RoutesModel.sharedInstance
    private var attractionsModel = AttractionsModel.sharedInstance
    private var routes = [Route]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        routes = routesModel.routesList!
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RouteCell", forIndexPath: indexPath) as UITableViewCell
        let route = routes[indexPath.row]
        cell.textLabel?.text = route.Name
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        routesModel.selectedRoute = routes[indexPath.row]
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as UITableViewCell

        if let identifier = segue.identifier {
            switch identifier {
            case "RouteToSelectAttractionsInRoute":
                if let indexPath = tableView.indexPathForCell(cell) {
                    let selectAttractionsScene = segue.destinationViewController as SelectAttractionsTableViewController
                    routesModel.selectedRoute = routes[indexPath.row]
                    var attractionIDs = routesModel.selectedRoute?.AttractionIDs
                    
                    selectAttractionsScene.attractions = attractionsModel.GetAttractionsConcreteObjects(attractionIDs!)
                    selectAttractionsScene.routeTitle = routes[indexPath.row].Name
                    
                }
            default: break
            }
        }
    }
}
