//
//  SelectAttractionsModel.swift
//  CityAudioTour
//
//  Created by Red_iMac on 4/3/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import Foundation
class SelectAttractionsManager {
    
    class var sharedInstance: SelectAttractionsManager {
        struct Static {
            static var instance: SelectAttractionsManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = SelectAttractionsManager()
        }
        
        return Static.instance!
    }
    
    private var _attractionManager = AttractionsManager.sharedInstance
    private var title = "My Route"
    private var attractionIDs = [Int]()
    
    var allAttractions: [Int] {
        get {
            return attractionIDs
        }
    }
    
    var myRoute: Route? {
        get {
            var route = Route()
            route.Name = title
            route.AttractionIDs = attractionIDs
            (route.CategoriesIDs, route.TagsIDs) = getCategoriesAndTags()
            return route
        }
    }
    
    private func getCategoriesAndTags() -> ([Int], [Int]){
        var categorys = [Int]()
        var tags = [Int]()
        
        for ID in attractionIDs {
            let attraction = _attractionManager.GetAttractionBy(ID)
            
            //add categories
            if !contains(categorys, attraction!.CategoryID) {
                categorys.append(attraction!.CategoryID)
            }
            
            // add tags
            for tag in attraction!.TagIDs {
                if !contains(tags, tag) {
                    tags.append(tag)
                }
            }
        }
        
        return (categorys, tags)
    }
    
    func myRouteWithTitle(name: String) -> Route?{
        var route = Route()
        route.Name = name
        route.AttractionIDs = attractionIDs
        (route.CategoriesIDs, route.TagsIDs) = getCategoriesAndTags()
        return route
    }
    
    func setTitle(name: String) {
        title = name
    }
    
    func isContain(ID: Int) -> Bool {
        return contains(attractionIDs, ID)
    }
    
    func addAttraction(ID: Int) {
        if !contains(attractionIDs, ID) {
            attractionIDs.append(ID)
        }
    }
    
    func removeAttractionAt(index: Int) {
        if !attractionIDs.isEmpty && index < attractionIDs.count {
            attractionIDs.removeAtIndex(index)
        }
    }
    
    func moveItem(fromIndex: Int, toIndex: Int) {
        var itemToMove = attractionIDs[fromIndex]
        attractionIDs.removeAtIndex(fromIndex)
        attractionIDs.insert(itemToMove, atIndex: toIndex)
    }
}