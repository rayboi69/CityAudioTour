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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*//get data from server
        categories = ClassificationModel.sharedInstance.categoryList
        tags = ClassificationModel.sharedInstance.tagList
        */
        
        self.getFakeData()  //fake data
    }

    func getFakeData() {
        categories = [Category]()
        categories?.append(Category(id: 1, name: "Category: 1"))
        categories?.append(Category(id: 2, name: "Category: 2"))
        categories?.append(Category(id: 3, name: "Category: 3"))
        categories?.append(Category(id: 4, name: "Category: 4"))
        
        tags = [Tag]()
        tags?.append(Tag(id: 1, name: "Tag: 1"))
        tags?.append(Tag(id: 2, name: "Tag: 2"))
        tags?.append(Tag(id: 3, name: "Tag: 3"))
        tags?.append(Tag(id: 4, name: "Tag: 4"))
        tags?.append(Tag(id: 5, name: "Tag: 5"))
        tags?.append(Tag(id: 6, name: "Tag: 6"))
        tags?.append(Tag(id: 7, name: "Tag: 7"))
        tags?.append(Tag(id: 8, name: "Tag: 8"))
        tags?.append(Tag(id: 9, name: "Tag: 9"))
        tags?.append(Tag(id: 10, name: "Tag: 10"))
    }
    
    func update() {
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        if indexPath.section == 0 {
            cell.textLabel?.text = categories![indexPath.row].Name
        } else {
            cell.textLabel?.text = tags![indexPath.row].Name
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

    }
    
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
