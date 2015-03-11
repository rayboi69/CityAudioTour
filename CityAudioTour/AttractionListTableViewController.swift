//
//  AttractionListTableViewController.swift
//  CityAudioTour
//
//  Created by Red_iMac on 2/27/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit

class AttractionListTableViewController: UITableViewController {

    var attractions: [Attraction]! = AttractionsModel.sharedInstance.attractionsList
    var sectionTitle = "Attraction List"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        for attraction in attractions! {
            if !attraction.isHiden {
                count++
            }
        }
        return count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AttractionCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        let attraction = attractions![indexPath.row]
        if !attraction.isHiden {
            cell.textLabel?.text = attraction.AttractionName
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let attraction = attractions![indexPath.row]
        AttractionsModel.sharedInstance.routeAttractions = [attraction]
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ListToDetail" {
            let cell = sender as UITableViewCell
            if let indexPath = tableView.indexPathForCell(cell) {
                let detailScene = segue.destinationViewController as DetailViewController
                detailScene.receiveID = attractions![indexPath.row].AttractionID
            }
        }
    }

}
