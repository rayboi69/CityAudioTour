//
//  SelectAttractionsTableViewController.swift
//  CityAudioTour
//
//  Created by Red_iMac on 3/12/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit

class SelectAttractionsTableViewController: UITableViewController {

    var route = Route()
    var editable = false
    private var attractionsManager = AttractionsManager.sharedInstance
    private var selectAttractionsManager = SelectAttractionsManager.sharedInstance
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return route.AttractionIDs.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SelectAttractionCell", forIndexPath: indexPath) as UITableViewCell
        let attraction = attractionsManager.GetAttractionBy(route.AttractionIDs[indexPath.row])
        cell.textLabel?.text = attraction?.AttractionName
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return route.Name
    }

    // MARK: - Edit mode
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return editable
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            route.AttractionIDs.removeAtIndex(indexPath.row)
            selectAttractionsManager.removeAttractionAt(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

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

    // MARK: - Navigation

    @IBAction func showAttractionsOnMap(sender: UIBarButtonItem) {
        RoutesManager.sharedInstance.selectedRoute = route
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "SelectAttractionToDetail":
                let cell = sender as UITableViewCell
                if let indexPath = tableView.indexPathForCell(cell) {
                    let detailScene = segue.destinationViewController as DetailViewController
                    detailScene.receiveID = route.AttractionIDs[indexPath.row]
                }
            default: break
            }
        }
    }

}
