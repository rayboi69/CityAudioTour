//
//  SearchBarDelegate.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 3/2/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import Foundation
import UIKit

class SearchBarDelegate:NSObject,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource{
    
    private let mapView:MainMapViewController!
    private let mapController:MapDelegate!
    private let list:[Attraction] = AttractionsManager.sharedInstance.attractionsList
    private var filtered:[Attraction] = []
    
    init(mapView:MainMapViewController,mapController:MapDelegate){
        self.mapView = mapView
        self.mapController = mapController
    }
    //When we click search button on the keyboard, this method will be called to
    //handle it.
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        mapView.autoComplete.hidden = true
        mapController.createSpecificPinPoint(searchBar.text)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        mapView.autoComplete.hidden = false
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        mapView.autoComplete.hidden = true
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = list.filter({ (attraction) -> Bool in
            let length = Range(start: searchText.startIndex, end: searchText.endIndex)
            var temp:NSString?
            if searchText.endIndex <= attraction.AttractionName.endIndex{
                temp = attraction.AttractionName.substringWithRange(length)
                let range = temp!.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range.location != NSNotFound
            }else{
                return false
            }
            
        })
        mapView.autoComplete.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mapView.searchBar.text.isEmpty {
            return list.count
        }
        return filtered.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //User selects attraction in search.
        mapView.searchBar.resignFirstResponder()
        mapView.searchBar.setShowsCancelButton(false, animated: true)
        if !filtered.isEmpty{
            mapView.searchBar.text = filtered[indexPath.row].AttractionName
        }else{
            mapView.searchBar.text = list[indexPath.row].AttractionName
        }
        tableView.hidden = true
        
        mapController.createSpecificPinPoint(mapView.searchBar.text)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        if !filtered.isEmpty {
            cell.textLabel?.text = filtered[indexPath.row].AttractionName
        }else {
            cell.textLabel?.text = list[indexPath.row].AttractionName
        }
        
        return cell
    }
    
    
    
}