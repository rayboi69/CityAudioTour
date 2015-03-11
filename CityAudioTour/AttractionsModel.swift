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
    
    private var _service: CATAzureService?
    private var _attractionsList: [Attraction]?
    private var _selectAttractions: [Attraction]?
    
    
    init() {
        _attractionsList = [Attraction]()
        _service = CATAzureService()
        _selectAttractions = []
        LoadAttractionsList()
    }
    
    //
    // Initializes the attractionsList with the data from the server
    //
    func LoadAttractionsList() -> [Attraction]{
        _attractionsList = _service?.GetAttractions()
        return _attractionsList!
    }

    
    //
    // Params: selectedCat: NSSet and selectedTag: NSSet - Should come from the ClassifiedModel
    //
    func FilterAttraction(selectedCat: NSSet, selectedTag: NSSet) {
        for attraction in _attractionsList!
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
    
    //Lazy Getters
    var attractionsList: [Attraction] {
        get {
            return _attractionsList!
        }
    }
    
    
    var selectAttractions: [Attraction] {
        get {
            return _selectAttractions!
        }
        set {
            _selectAttractions = newValue
        }
    }
    

}
