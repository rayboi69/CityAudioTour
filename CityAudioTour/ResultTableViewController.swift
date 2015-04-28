//
//  SearchResultTableViewController.swift
//  CityAudioTour
//
//  Created by Red_iMac on 4/27/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit

class ResultTableViewController: UITableViewController, UISearchBarDelegate {

    var sectionTitle = "Route List"
    private var routesManager = RoutesManager.sharedInstance
    private var attractionsManager = AttractionsManager.sharedInstance
    private var selectAttractionsManager = SelectAttractionsManager.sharedInstance
    
    private var routes = [Route]()
    private var attractions = [Attraction]()
    
    private var filteredRoutes = [Route]()
    private var filteredAttractions = [Attraction]()
    
    private var type: String = ""
    
    // MARK: - Search bar
    
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
        
        switch type {
        case "Attraction":
            filteredAttractions = self.attractions.filter({( attraction: Attraction) -> Bool in
                let stringMatch = attraction.AttractionName.lowercaseString.rangeOfString(searchText.lowercaseString)
                return stringMatch != nil
            })
        case "Route":
            filteredRoutes = self.routes.filter({( route: Route) -> Bool in
                let stringMatch = route.Name.lowercaseString.rangeOfString(searchText.lowercaseString)
                return stringMatch != nil
            })
        default: break
        }
        
        searchActive = (searchBar.text.isEmpty ? false : true)
        tableView.reloadData()
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch sectionTitle {
        case "Attraction List":
            type = "Attraction"
        case "Route List":
            type = "Route"
        default: break
        }
        
        searchBar.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        switch sectionTitle {
        case "Attraction List":
            attractions = attractionsManager.attractionsList
        case "Route List":
            routes = routesManager.routesList!
        default: break
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if (searchActive) {
            switch type {
            case "Attraction":
                return filteredAttractions.count
            case "Route":
                return filteredRoutes.count
            default: break
            }
        } else {
            switch type {
            case "Attraction":
                return attractions.count
            case "Route":
                return routes.count
            default: break
            }
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultCell", forIndexPath: indexPath) as! UITableViewCell
        
        switch type {
        case "Attraction":
            let attraction = (searchActive ? filteredAttractions[indexPath.row] : attractions[indexPath.row])
            cell.textLabel?.text = attraction.AttractionName
        case "Route":
            let route = (searchActive ? filteredRoutes[indexPath.row] : routes[indexPath.row])
            cell.textLabel?.text = route.Name
        default: break
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return type == "Attraction" ? true : false
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        var addToMyRoute = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Add" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            var selectAttraction = (self.searchActive ? self.filteredAttractions[indexPath.row] : self.attractions[indexPath.row])
            var alert: UIAlertController
            
            if self.selectAttractionsManager.isContain(selectAttraction.AttractionID) {
                alert = UIAlertController(title: selectAttraction.AttractionName + " was already added to your route.", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okey", style: UIAlertActionStyle.Default, handler: nil))
            } else {
                alert = UIAlertController(title: "Add " + selectAttraction.AttractionName, message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
                    self.selectAttractionsManager.addAttraction(selectAttraction.AttractionID)
                }))
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
            }
            
            self.editing = false
            self.presentViewController(alert, animated: true, completion: nil)
        })
        addToMyRoute.backgroundColor = UIColor.blueColor()
        
        return [addToMyRoute]
    }

    // MARK: - Navigation
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch type {
        case "Attraction":
            var attraction = (searchActive ? filteredAttractions[indexPath.row] : attractions[indexPath.row])
            var route = Route()
            route.AttractionIDs = [attraction.AttractionID]
            route.CategoriesIDs = [attraction.CategoryID]
            route.TagsIDs = attraction.TagIDs
            routesManager.selectedRoute = route
            navigationController?.popToRootViewControllerAnimated(true)
        case "Route":
            routesManager.selectedRoute = (searchActive ? filteredRoutes[indexPath.row] : routes[indexPath.row])
            navigationController?.popToRootViewControllerAnimated(true)
        default: break
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "RouteToSelectAttractionsInRoute":
                let cell = sender as! UITableViewCell
                if let indexPath = tableView.indexPathForCell(cell) {
                    
                    let selectAttractionsScene = segue.destinationViewController as! SelectAttractionsTableViewController
                    let selectRoute = (searchActive ? filteredRoutes[indexPath.row] : routes[indexPath.row])
                    let attractions = attractionsManager.GetAttractionsConcreteObjects(selectRoute.AttractionIDs)
                    
                    routesManager.selectedRoute = selectRoute
                    selectAttractionsScene.identify = selectRoute.Name
                }
            case "ListToDetail":
                let cell = sender as! UITableViewCell
                if let indexPath = tableView.indexPathForCell(cell) {
                    let detailScene = segue.destinationViewController as! DetailViewController
                    let attraction = (searchActive ? filteredAttractions[indexPath.row] : attractions[indexPath.row])
                    detailScene.receiveID = attraction.AttractionID
                }
            default: break
            }
        }

    }

}
