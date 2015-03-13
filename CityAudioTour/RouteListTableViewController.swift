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
    var _routesModel = RoutesModel.sharedInstance
    var _routes = [Route]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        _routes = _routesModel.routesList
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
        return _routes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RouteCell", forIndexPath: indexPath) as UITableViewCell
        let route = _routes[indexPath.row]
        cell.textLabel?.text = route.Name
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO - Implement with new filtering system
        //AttractionsModel.sharedInstance.routeAttractions = prepareSelectRoute(indexPath.row)
        //setRoute?.drawRoute()
        //navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "RouteToSelectAttractionsInRoute":
                let cell = sender as UITableViewCell
                if let indexPath = tableView.indexPathForCell(cell) {
                    let selectAttractionsScene = segue.destinationViewController as SelectAttractionsTableViewController
                    //TODO - sent info to SelectAttractionsTableViewController
                    
                }
            default: break
            }
        }
    }
}
