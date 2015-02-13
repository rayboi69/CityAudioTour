//
//  AttractBuilder.swift
//  DetailPage
//
//  Created by Pichan Vasantakitkumjorn on 2/11/15.
//  Copyright (c) 2015 Pichan Vasantakitkumjorn. All rights reserved.
//

import Foundation


class AttractionBuilder{
    
    let URL:String = "http://cityaudiotourweb.azurewebsites.net/api/attraction/"
    
    init(){}
    
    func getAttraction(AttractionID:Int) -> Attraction?{
        
        let serverLink = URL + String(AttractionID)
        
        var serverDNS : NSURL = NSURL(string:serverLink)!
        var requestMessage : NSURLRequest = NSURLRequest(URL: serverDNS, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 5000)
        
        let jsonObject = NSURLConnection.sendSynchronousRequest(requestMessage, returningResponse: nil, error: nil)
        
        if ( jsonObject != nil ) {
            let retval = Attraction()
            
            let json = JSON(data:jsonObject!)
            
            var address = json["Address"].stringValue
            var city = json["City"].stringValue
            var state = json["StateAbbreviation"].stringValue
            var zip = json["ZipCode"].stringValue
            
            retval.setAddress(address, city: city, state: state, ZIP: zip)
            retval.setAttractionName(json["Name"].stringValue)
            retval.setDetail(json["Details"].stringValue)
            retval.setContent(json["TextContent"].stringValue)
            return retval
        }else{
            return nil
        }
    }
    
}