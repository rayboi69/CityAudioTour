//
//  PopularManager.swift
//  CityAudioTour
//
//  Created by Red_iMac on 5/29/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import Foundation

class PopularManager {
    
    //
    //Singleton Pattern
    //
    class var sharedInstance: PopularManager
    {
        
        struct Static {
            static var instance: PopularManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = PopularManager()
        }
        
        return Static.instance!
    }
    
    private var _service: CATAzureService?
    private var _attractionsList: [Attraction]?
    private var _isAttractionsListChanged:Bool = false
    
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
    private func LoadAttractionsList() -> [Attraction]
    {
        _attractionsList = _service?.GetPopularAttractions()
        
        return _attractionsList!
    }
    
    //
    //
    //
    func GetAttractionBy(id:Int) -> Attraction?
    {
        let attractionResult = _attractionsList?.filter({ m in
            m.AttractionID == id
        })
        return attractionResult!.first as Attraction!
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
    // Implement method to Get Attractions
    //
    func GetAttractionsConcreteObjects(attractionsIDs:[Int]) -> [Attraction]
    {
        var attractions = [Attraction]()
        
        for var index = 0; index < attractionsIDs.count; ++index {
            var attractionResult : Attraction = self.GetAttractionBy(attractionsIDs[index])!
            attractions.append(attractionResult)
        }
        
        return attractions
    }
    
    //
    //Lazy Getters
    //
    var attractionsList : [Attraction]
        {
        get{
            var filteredAttractions = [Attraction]()
            //Validates if the user did some filtering
            if let s = _selectAttractionsIndexes
            {
                for var index = 0; index < _selectAttractionsIndexes?.count; ++index
                {
                    var selectedIndex = _selectAttractionsIndexes?[index]
                    var attraction = _attractionsList![selectedIndex!]
                    filteredAttractions.append(attraction)
                }
                //return sortAttractionList(filteredAttractions)
                return filteredAttractions
            }
            else
            {
                //return sortAttractionList(_attractionsList!)
                return _attractionsList!
            }
        }
        
    }
    
    var isAttractionsListChanged : Bool
        {
        get{
            return _isAttractionsListChanged
        }
        set{
            _isAttractionsListChanged = newValue
        }
        
    }
    
    //MARK: - Sorting
    
    func sortByTitle(this: Attraction, that: Attraction) -> Bool {
        return this.AttractionName < that.AttractionName
    }
    
    func sortByReverseTitle(this: Attraction, that: Attraction) -> Bool {
        return this.AttractionName > that.AttractionName
    }
    
    func sortByDistance(this:Attraction, that: Attraction) -> Bool {
        return this.Distance < that.Distance
    }
    
    func sortAttractionList(list: [Attraction], sortBy: String) -> [Attraction] {
        switch sortBy {
        case "Title":
            return sorted(list, sortByTitle)
        case "Reverse":
            return sorted(list, sortByReverseTitle)
        case "Distance":
            return sorted(list, sortByDistance)
        default:
            return list
        }
    }
}
