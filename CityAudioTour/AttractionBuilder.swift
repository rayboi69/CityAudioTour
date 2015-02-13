//
//  AttractBuilder.swift
//  DetailPage
//
//  Created by Pichan Vasantakitkumjorn on 2/11/15.
//  Copyright (c) 2015 Pichan Vasantakitkumjorn. All rights reserved.
//

import Foundation


class AttractionBuilder{
    
    init(){}
    
    func getAttractionList() -> [Attraction]?{
        
        let jsonArray = JSONFactory().getJSONArray()
        
        if ( jsonArray != nil ){
            var attractionList = [Attraction]()
            
            //            for jsonObj in jsonArray! {
            //                let attraction = Attraction()
            //                var address = jsonObj.getValueForKey("Address")
            //                var city = jsonObj.getValueForKey("City")
            //                var state = jsonObj.getValueForKey("StateAbbreviation")
            //                var zip = jsonObj.getValueForKey("ZipCode")
            //
            //                attraction.setAddress(address, city: city, state: state, ZIP: zip)
            //                attraction.setAttractionName(jsonObj.getValueForKey("Name"))
            //                attraction.setDetail(jsonObj.getValueForKey("Details"))
            //                attraction.setContent(jsonObj.getValueForKey("TextContent"))
            //
            //                attractionList.append(attraction)
            //            }
            
            return attractionList
        }else{
            return nil
        }
        
    }
    
    func getAttraction(AttractionID:Int) -> Attraction?{
        
        let jsonObj = JSONFactory().getJSONObject(AttractionID)
        
        if ( jsonObj != nil ) {
            let retval = Attraction()
            
            var address = jsonObj!.getValueForKey("Address")
            var city = jsonObj!.getValueForKey("City")
            var state = jsonObj!.getValueForKey("StateAbbreviation")
            var zip = jsonObj!.getValueForKey("ZipCode")
            
            retval.setAddress(address, city: city, state: state, ZIP: zip)
            retval.setAttractionName(jsonObj!.getValueForKey("Name"))
            retval.setDetail(jsonObj!.getValueForKey("Details"))
            retval.setContent(jsonObj!.getValueForKey("TextContent"))
            return retval
        }else{
            return nil
        }
    }
    
}