//
//  AttractionsModel.swift
//  CityAudioTour
//
//  Created by Juan Garcia on 2/23/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import Foundation
class AttractionsModel {
    
    
    //Singleton Pattern
    class var sharedInstance: AttractionsModel {
        
        struct Static {
            static var instance: AttractionsModel?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = AttractionsModel()
        }
        
        return Static.instance!
    }
    
    var service: CATAzureService?
    var attractionsList: [Attraction]?
    
    init() {
        attractionsList = [Attraction]()
        service = CATAzureService()
    }
    
    //
    // Initializes the attractionsList with the data from the server
    //
    func LoadAttractionsList() -> [Attraction]{
        attractionsList = self.service?.GetAttractions()
        return self.attractionsList!
    }

    
    //
    // Params: selectedCat: NSSet and selectedTag: NSSet - Should come from the ClassifiedModel
    //
    func FilterAttraction(selectedCat: NSSet, selectedTag: NSSet) {
        println("***** Filtering *****");
        for attraction in attractionsList!
        {
            attraction.isHiden = true
            
            if(selectedCat.containsObject(attraction.CategoryID))
            {
                attraction.isHiden = false
            }
            
            for tag in attraction.TagIDs
            {
                if(selectedTag.containsObject(tag))
                {
                    attraction.isHiden = false;
                    break
                }
            }
        }
    }
}
