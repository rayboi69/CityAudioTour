//
//  FilterTableViewController.swift
//  CityAudioTour
//
//  Created by Red_iMac on 2/27/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {

    var categories: [Category]?
    var tags: [Tag]?
    var catSet: NSMutableSet!
    var tagSet: NSMutableSet!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = ClassificationManager.sharedInstance.categoryList
        tags = ClassificationManager.sharedInstance.tagList
        catSet = ClassificationManager.sharedInstance.selectedCategories
        tagSet = ClassificationManager.sharedInstance.selectedTags
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        AttractionsManager.sharedInstance.FilterAttractions(catSet, selectedTag: tagSet)
        RoutesManager.sharedInstance.FilterRoutes(catSet, selectedTag: tagSet)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return categories!.count
        } else {
            return tags!.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath) as! UITableViewCell
        // Configure the cell...
        if indexPath.section == 0 {
            cell.textLabel?.text = categories![indexPath.row].Name
            let catID = categories![indexPath.row].CategoryID
            if catSet.containsObject(catID){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        } else {
            cell.textLabel?.text = tags![indexPath.row].Name
            let tagID = tags![indexPath.row].TagID
            if tagSet.containsObject(tagID){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Categories"
        } else {
            return "Tags"
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let catID = categories![indexPath.row].CategoryID
            if catSet.containsObject(catID) {
                catSet.removeObject(catID)
            } else {
                catSet.addObject(catID)
            }
        } else {
            let tagID = tags![indexPath.row].TagID
            if tagSet.containsObject(tagID) {
                tagSet.removeObject(tagID)
            } else {
                tagSet.addObject(tagID)
            }
        }
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }

}
