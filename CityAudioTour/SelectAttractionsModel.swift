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
    
    var attractions: [Attraction] = []
    
    var myRoute: Route? {
        get {
            var ids = [Int()]
            var tags = NSMutableSet()
            var cats = NSMutableSet()
            
            for attraction in attractions {
                ids.append(attraction.AttractionID)
                tags.addObject(attraction.TagIDs)
                cats.addObject(attraction.CategoryID)
            }
            
            var route = Route()
            route.Name = "My Route"
            route.AttractionIDs = ids
            route.TagsIDs = tags.allObjects as [Int]
            route.CategoriesIDs = cats.allObjects as [Int]
            
            return route
        }
    }
}