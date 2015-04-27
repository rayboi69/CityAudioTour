//
//  SearchResultTableViewController.swift
//  CityAudioTour
//
//  Created by Red_iMac on 4/27/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit

class SearchResultTableViewController: UITableViewController {

    var sectionTitle = ""
    private var routesManager = RoutesManager.sharedInstance
    private var attractionsManager = AttractionsManager.sharedInstance
    private var selectAttractionsManager = SelectAttractionsManager.sharedInstance
    private var searchActive = false
    private var filtered = [AnyObject]()
    private var list = [AnyObject]()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //searchBar.delegate = self
        
        switch sectionTitle {
        case "Attraction List":
            list = [Attraction]() //as [Attraction]
            filtered = [Attraction]() //as [Attraction]
        case "Route List":
            list = [Route]() //as [Route]
            filtered = [Route]() //as [Route]
        default: break
        }
    }

    override func viewDidAppear(animated: Bool) {
        switch sectionTitle {
        case "Attraction List":
            list = attractionsManager.attractionsList
        case "Route List":
            list = routesManager.routesList!
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
            return filtered.count
        } else {
            return list.count
        }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AttractionCell", forIndexPath: indexPath) as! UITableViewCell
        let object: AnyObject
        
        if (searchActive) {
            object = filtered[indexPath.row]
        } else {
            object = list[indexPath.row]
        }
        
        cell.textLabel?.text = object.a
        return cell
    }
    */
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
