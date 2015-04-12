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
    private var routesManager = RoutesManager.sharedInstance
    private var attractionsModel = AttractionsManager.sharedInstance
    private var routes = [Route]()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        routes = routesManager.routesList!
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
    
    // MARK: - Navigation
  
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        routesManager.selectedRoute = routes[indexPath.row]
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "RouteToSelectAttractionsInRoute":
                let cell = sender as UITableViewCell
                if let indexPath = tableView.indexPathForCell(cell) {
                    
                    let selectAttractionsScene = segue.destinationViewController as SelectAttractionsTableViewController
                    let selectRoute = routes[indexPath.row]
                    let attractions = attractionsModel.GetAttractionsConcreteObjects(selectRoute.AttractionIDs)
                    
                    routesManager.selectedRoute = selectRoute
                    selectAttractionsScene.route = selectRoute
                    selectAttractionsScene.editable = false
                }
            default: break
            }
        }
    }
}
