//
//  AttractionsModel.swift
//  CityAudioTour
//
//  Created by Juan Garcia on 2/23/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import Foundation
class AttractionsModel {
    
    //
    //Singleton Pattern
    //
    class var sharedInstance: AttractionsModel
    {
        
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
    private var _routeAttractions: [Attraction]?
    
    //
    //Petes idea implementation
    //
    private var _selectAttractionsIndexes: [Int]?

    
    init()
    {
        _attractionsList = [Attraction]()
        _service = CATAzureService()
        _routeAttractions = []
        LoadAttractionsList()
    }
    
    //
    // Initializes the attractionsList with the data from the server
    //
    func LoadAttractionsList() -> [Attraction]
    {
        _attractionsList = _service?.GetAttractions()
        return _attractionsList!
    }

    
    //
    // Params: selectedCat: NSSet and selectedTag: NSSet - Should come from the ClassifiedModel
    //
    func FilterAttraction(selectedCat: NSSet, selectedTag: NSSet)
    {
        _selectAttractionsIndexes = []
        var index = 0
        for attraction in _attractionsList!
        {
            attraction.isHiden = true
            var isSelected = false
            
            if(selectedCat.containsObject(attraction.CategoryID))
            {
                attraction.isHiden = false
                isSelected = true
            }
            
            for tag in attraction.TagIDs
            {
                if(selectedTag.containsObject(tag))
                {
                    attraction.isHiden = false;
                    isSelected = true
                    break
                }
            }
            
            if isSelected
            {
                _selectAttractionsIndexes?.append(index)
            }
            
            index = index + 1
        }
    }
    
    //
    // New Filtering System
    //
    func FilterAttractions(selectedCat: NSSet, selectedTag: NSSet, isRoute: Bool)
    {
        _selectAttractionsIndexes = []
        var index = 0
        var attractionsToFIlter = [Attraction]()
        
        if isRoute
        {
            attractionsToFIlter = _routeAttractions!
        }
        else
        {
            attractionsToFIlter = _attractionsList!
            routeAttractions = []
        }
        
        for attraction in attractionsToFIlter
        {
            attraction.isHiden = true
            var isSelected = false
            
            if(selectedCat.containsObject(attraction.CategoryID))
            {
                attraction.isHiden = false
                isSelected = true
            }
            
            for tag in attraction.TagIDs
            {
                if(selectedTag.containsObject(tag))
                {
                    attraction.isHiden = false;
                    isSelected = true
                    break
                }
            }
            
            if isSelected
            {
                _selectAttractionsIndexes?.append(index)
            }
            
            index = index + 1
        }
    }

    
    
    //
    //Lazy Getters
    //
    var attractionsList: [Attraction]
    {
        get {
            return _attractionsList!
        }
    }
    
    
    var routeAttractions: [Attraction]
    {
        get {
            return _routeAttractions!
        }
        set {
            _routeAttractions = newValue
        }
    }
    
    var filteredAttractions : [Attraction]
    {
        get{
            var filteredAttractions = [Attraction]()
            var attractionsToFIlter = [Attraction]()
            
            if routeAttractions.count > 0
            {
                attractionsToFIlter = _routeAttractions!
            }
            else
            {
                attractionsToFIlter = _attractionsList!
            }
            
            for var index = 0; index < _selectAttractionsIndexes?.count; ++index {
                var selectedIndex = _selectAttractionsIndexes?[index]
                var attraction = attractionsToFIlter[selectedIndex!]
                filteredAttractions.append(attraction)
            }
            return filteredAttractions
        }
    }
    

}
