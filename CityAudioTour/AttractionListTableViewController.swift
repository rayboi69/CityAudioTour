//
//  AttractionListTableViewController.swift
//  CityAudioTour
//
//  Created by Red_iMac on 2/27/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit

class AttractionListTableViewController: UITableViewController, UISearchBarDelegate {

    var sectionTitle = "Attraction List"
    private var _routesManager = RoutesManager.sharedInstance
    private var _attractionsManager = AttractionsManager.sharedInstance
    private var _selectAttractionsManager = SelectAttractionsManager.sharedInstance
    private var attractions = [Attraction]()
    
    // MARK: - Search bar
    
    private var filtered = [Attraction]()
    private var searchActive : Bool = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = self.attractions.filter({( attraction: Attraction) -> Bool in
            let stringMatch = attraction.AttractionName.lowercaseString.rangeOfString(searchText)
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
        attractions = _attractionsManager.attractionsList
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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (searchActive ? filtered.count : attractions.count)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AttractionCell", forIndexPath: indexPath) as! UITableViewCell
        let attraction = (searchActive ? filtered[indexPath.row] : attractions[indexPath.row])
        cell.textLabel?.text = attraction.AttractionName
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        var addToMyRoute = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Add" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            var selectAttraction = (self.searchActive ? self.filtered[indexPath.row] : self.attractions[indexPath.row])
            var alert: UIAlertController
            
            if self._selectAttractionsManager.isContain(selectAttraction.AttractionID) {
                alert = UIAlertController(title: selectAttraction.AttractionName + " was already added to your route.", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okey", style: UIAlertActionStyle.Default, handler: nil))
            } else {
                alert = UIAlertController(title: "Add " + selectAttraction.AttractionName, message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
                    self._selectAttractionsManager.addAttraction(selectAttraction.AttractionID)
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
        var attraction = (searchActive ? filtered[indexPath.row] : attractions[indexPath.row])
        var route = Route()
        route.AttractionIDs = [attraction.AttractionID]
        route.CategoriesIDs = [attraction.CategoryID]
        route.TagsIDs = attraction.TagIDs
        _routesManager.selectedRoute = route
        navigationController?.popToRootViewControllerAnimated(true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ListToDetail" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPathForCell(cell) {
                let detailScene = segue.destinationViewController as! DetailViewController
                let attraction = (searchActive ? filtered[indexPath.row] : attractions[indexPath.row])
                detailScene.receiveID = attraction.AttractionID
            }
        }
    }

}
