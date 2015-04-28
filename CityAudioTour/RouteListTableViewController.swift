//
//  RouteListTableViewController.swift
//  CityAudioTour
//
//  Created by Red_iMac on 3/1/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit

class RouteListTableViewController: UITableViewController, UISearchBarDelegate {

    var sectionTitle = "Route List"
    private var _routesManager = RoutesManager.sharedInstance
    private var _attractionsManager = AttractionsManager.sharedInstance
    private var routes = [Route]()
    
    // MARK: - Search bar
    
    private var filtered = [Route]()
    private var searchActive : Bool = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = self.routes.filter({( route: Route) -> Bool in
            let stringMatch = route.Name.lowercaseString.rangeOfString(searchText.lowercaseString)
            return stringMatch != nil
        })
        searchActive = (searchBar.text.isEmpty ? false : true)
        tableView.reloadData()
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        routes = _routesManager.routesList!
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
        return (searchActive ? filtered.count : routes.count)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RouteCell", forIndexPath: indexPath) as! UITableViewCell
        let route = (searchActive ? filtered[indexPath.row] : routes[indexPath.row])
        cell.textLabel?.text = route.Name
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle
    }
    
    // MARK: - Navigation
  
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _routesManager.selectedRoute = (searchActive ? filtered[indexPath.row] : routes[indexPath.row])
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "RouteToSelectAttractionsInRoute":
                let cell = sender as! UITableViewCell
                if let indexPath = tableView.indexPathForCell(cell) {
                    
                    let selectAttractionsScene = segue.destinationViewController as! SelectAttractionsTableViewController
                    let selectRoute = (searchActive ? filtered[indexPath.row] : routes[indexPath.row])
                    let attractions = _attractionsManager.GetAttractionsConcreteObjects(selectRoute.AttractionIDs)
                    
                    _routesManager.selectedRoute = selectRoute
                    selectAttractionsScene.identify = selectRoute.Name
                }
            default: break
            }
        }
    }
}
