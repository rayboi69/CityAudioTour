//
//  AttractionListTableViewController.swift
//  CityAudioTour
//
//  Created by Red_iMac on 2/27/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit

class AttractionListTableViewController: UITableViewController {

    var sectionTitle = "Attraction List"
    private var _routesManager = RoutesManager.sharedInstance
    private var _attractionsManager = AttractionsManager.sharedInstance
    private var _selectAttractionsManager = SelectAttractionsManager.sharedInstance
    private var attractions = [Attraction]()
    
    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
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
            return attractions.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AttractionCell", forIndexPath: indexPath) as! UITableViewCell
        let attraction = attractions[indexPath.row]
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
            
            let alert = UIAlertController(title: nil, message: "\(self.attractions[indexPath.row].AttractionName) has been added to My Route", preferredStyle: .ActionSheet)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil)
            
            alert.addAction(okAction)
            
            self.editing = false
            self._selectAttractionsManager.addAttraction(self.attractions[indexPath.row].AttractionID)
            self.presentViewController(alert, animated: true, completion: nil)
        })
        
        addToMyRoute.backgroundColor = UIColor.blueColor()
        
        return [addToMyRoute]
    }
    
    // MARK: - Navigation
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var attraction = attractions[indexPath.row]
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
                detailScene.receiveID = attractions[indexPath.row].AttractionID
            }
        }
    }

}
