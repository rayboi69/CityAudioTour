//
//  AttractionListTableViewController.swift
//  CityAudioTour
//
//  Created by Red_iMac on 2/27/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit

class AttractionListTableViewController: UITableViewController {

    //var attractions: [Attraction]! = AttractionsModel.sharedInstance.attractionsList
    var sectionTitle = "Attraction List"
    private var _attractionsModel = AttractionsModel.sharedInstance
    private var _attractions = [Attraction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            return _attractions.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AttractionCell", forIndexPath: indexPath) as UITableViewCell
        let attraction = _attractions[indexPath.row]
        cell.textLabel?.text = attraction.AttractionName
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle
    }
    
    override func viewDidAppear(animated: Bool) {
        _attractions = _attractionsModel.attractionsList
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO - Implement with new filtering system
        //let attraction = attractions![indexPath.row]
        //AttractionsModel.sharedInstance.routeAttractions = [attraction]
        //navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ListToDetail" {
            let cell = sender as UITableViewCell
            if let indexPath = tableView.indexPathForCell(cell) {
                let detailScene = segue.destinationViewController as DetailViewController
                detailScene.receiveID = _attractions[indexPath.row].AttractionID
            }
        }
    }

}
