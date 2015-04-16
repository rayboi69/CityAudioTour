//
//  SelectAttractionsTableViewController.swift
//  CityAudioTour
//
//  Created by Red_iMac on 3/12/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit

class SelectAttractionsTableViewController: UITableViewController {

    var identify = ""
    
    private var editable = false
    private var attractions = [Int]()
    private var _attractionsManager = AttractionsManager.sharedInstance
    private var _routesManager = RoutesManager.sharedInstance
    private var _selectAttractionsManager = SelectAttractionsManager.sharedInstance
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch identify {
        case "My Route":
            attractions = _selectAttractionsManager.allAttractions
            self.navigationItem.rightBarButtonItem = self.editButtonItem()
            editable = true
        default:
            attractions = _routesManager.selectedRoute!.AttractionIDs
            self.navigationItem.rightBarButtonItem = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return attractions.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as! UITableViewCell
            
            cell.textLabel?.text = identify
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("SelectAttractionCell", forIndexPath: indexPath) as! UITableViewCell
            let attraction = _attractionsManager.GetAttractionBy(attractions[indexPath.row])
            cell.textLabel?.text = attraction?.AttractionName
        }
        return cell
    }

    // MARK: - Edit mode

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        if indexPath.section == 0 {
            return false
        }
        return editable
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            attractions.removeAtIndex(indexPath.row)
            _selectAttractionsManager.removeAttractionAt(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        _selectAttractionsManager.moveItem(fromIndexPath.row, toIndex: toIndexPath.row)
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        if indexPath.section == 0 {
            return false
        }
        return editable
    }
    
    // Override to prevent the movement of rows in between section.
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            var row = 0
            if sourceIndexPath.section < proposedDestinationIndexPath.section {
                row = self.tableView(tableView, numberOfRowsInSection: sourceIndexPath.section) - 1
            }
            return NSIndexPath(forRow: row, inSection: sourceIndexPath.section)
        }
        return proposedDestinationIndexPath
    }

    // MARK: - Navigation

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if identify == "My Route" {
                _routesManager.selectedRoute = _selectAttractionsManager.myRoute
            }
            navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "SelectAttractionToDetail":
                let cell = sender as! UITableViewCell
                if let indexPath = tableView.indexPathForCell(cell) {
                    let detailScene = segue.destinationViewController as! DetailViewController
                    detailScene.receiveID = attractions[indexPath.row]
                }
            default: break
            }
        }
    }

}
