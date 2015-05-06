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
    
    enum Type { case Attraction, Route }

    private var routesManager = RoutesManager.sharedInstance
    private var attractionsManager = AttractionsManager.sharedInstance
    private var selectAttractionsManager = SelectAttractionsManager.sharedInstance
    private var classificationManager = ClassificationManager.sharedInstance
    
    private var routes = [Route]()
    private var attractions = [Attraction]()
    private var type: Type!
    
    enum Sort : String{
        case None = "None"
        case Title = "Title"
        case Reverse = "Reverse"
    }
    
    // MARK: - Sorting List
    
    private var _sort = Sort.None
    
    @IBAction func sortButton(sender: UIButton) {
        var alert = UIAlertController(title: "", message: "Choose Sort Option", preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Name", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self._sort = Sort.Title
            self.sortList()
        }))
        alert.addAction(UIAlertAction(title: "Reverse Name", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self._sort = Sort.Reverse
            self.sortList()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        switch type! {
        case .Attraction:
            alert.addAction(UIAlertAction(title: "Distance", style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                self._sort = Sort.Title
                self.sortList()
            }))
        case .Route:
            alert.addAction(UIAlertAction(title: "Number", style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                self._sort = Sort.Title
                self.sortList()
            }))
        }
        
        alert.popoverPresentationController?.sourceView = sender as UIView
        alert.popoverPresentationController?.sourceRect = CGRect(x: (sender.frame.width/2), y: sender.frame.height, width: 0, height: 0)
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Up
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func sortList() {
        switch type! {
        case .Attraction:
            attractions = attractionsManager.sortAttractionList(attractions, sortBy: _sort.rawValue)
        case .Route:
            routes = routesManager.sortAttractionList(routes, sortBy: _sort.rawValue)
        }
        tableView.reloadData()
    }
    
    // MARK: - Search bar
    
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
        if searchBar.text.isEmpty {
            switch sectionTitle {
            case "Attraction List":
                attractions = attractionsManager.attractionsList
            case "Route List":
                routes = routesManager.routesList!
            default: break
            }
        } else {
            switch type! {
            case .Attraction:
                attractions = self.attractions.filter({( attraction: Attraction) -> Bool in
                    let stringMatch = attraction.AttractionName.lowercaseString.rangeOfString(searchText.lowercaseString)
                    let categoryName = self.classificationManager.GetCategoryBy(attraction.CategoryID).lowercaseString.rangeOfString(searchText.lowercaseString)
                    return (categoryName != nil) || (stringMatch != nil)
                })
            case .Route:
                routes = self.routes.filter({( route: Route) -> Bool in
                    let stringMatch = route.Name.lowercaseString.rangeOfString(searchText.lowercaseString)
                    return stringMatch != nil
                })
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch sectionTitle {
        case "Attraction List":
            type = .Attraction
        case "Route List":
            type = .Route
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
        searchBar.text = ""
        self.sortList()
        tableView.reloadData()
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
        switch type! {
        case .Attraction:
            return (attractions.count)
        case .Route:
            return (routes.count)
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell :UITableViewCell
        
        switch type! {
        case .Attraction:
            cell = tableView.dequeueReusableCellWithIdentifier("AttractionCell", forIndexPath: indexPath) as! UITableViewCell
            let attraction = (attractions[indexPath.row])
            cell.textLabel?.text = attraction.AttractionName
        case .Route:
            cell = tableView.dequeueReusableCellWithIdentifier("RouteCell", forIndexPath: indexPath) as! UITableViewCell
            let route = (routes[indexPath.row])
            cell.textLabel?.text = route.Name
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return type! == .Attraction ? true : false
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        var addToMyRoute = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Add" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            var selectAttraction = (self.attractions[indexPath.row])
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
        switch type! {
        case .Attraction:
            var attraction = (attractions[indexPath.row])
            var route = Route()
            route.AttractionIDs = [attraction.AttractionID]
            route.CategoriesIDs = [attraction.CategoryID]
            route.TagsIDs = attraction.TagIDs
            routesManager.selectedRoute = route
            navigationController?.popToRootViewControllerAnimated(true)
        case .Route:
            routesManager.selectedRoute = (routes[indexPath.row])
            navigationController?.popToRootViewControllerAnimated(true)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "RouteToSelectAttractionsInRoute":
                let cell = sender as! UITableViewCell
                if let indexPath = tableView.indexPathForCell(cell) {
                    
                    let selectAttractionsScene = segue.destinationViewController as! SelectAttractionsTableViewController
                    let selectRoute = (routes[indexPath.row])
                    let attractions = attractionsManager.GetAttractionsConcreteObjects(selectRoute.AttractionIDs)
                    
                    routesManager.selectedRoute = selectRoute
                    selectAttractionsScene.identify = selectRoute.Name
                }
            case "ListToDetail":
                let cell = sender as! UITableViewCell
                if let indexPath = tableView.indexPathForCell(cell) {
                    let detailScene = segue.destinationViewController as! DetailViewController
                    let attraction = (attractions[indexPath.row])
                    detailScene.receiveID = attraction.AttractionID
                }
            default: break
            }
        }

    }

}
