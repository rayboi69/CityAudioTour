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
    
    //
    //Petes idea implementation
    //
    private var _selectAttractionsIndexes: [Int]?

    
    init()
    {
        _attractionsList = [Attraction]()
        _service = CATAzureService()
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
    //
    //
    func GetAttractionBy(id:Int) -> Attraction
    {
        let attractionResult = _attractionsList?.filter({ m in
                m.AttractionID == id
        })
        return attractionResult!.first as AnyObject as Attraction
    }
    
    //
    // New Filtering System
    //
    func FilterAttractions(selectedCat: NSSet, selectedTag: NSSet)
    {
        _selectAttractionsIndexes = []
        var index = 0
        
        for attraction in _attractionsList!
        {
            var isSelected = false
            if(selectedCat.containsObject(attraction.CategoryID))
            {
                isSelected = true
            }
            
            for tag in attraction.TagIDs
            {
                if(selectedTag.containsObject(tag))
                {
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
    var attractionsList : [Attraction]
    {
        get{
            var filteredAttractions = [Attraction]()
            //Validates if the user did some filtering
            if _selectAttractionsIndexes?.count > 0
            {
                for var index = 0; index < _selectAttractionsIndexes?.count; ++index
                {
                    var selectedIndex = _selectAttractionsIndexes?[index]
                    var attraction = _attractionsList![selectedIndex!]
                    filteredAttractions.append(attraction)
                }
                
                return filteredAttractions
            }
            else
            {
                return _attractionsList!
            }
        }

    }
    

}
