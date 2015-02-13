//
//  JSONFactory.swift
//  DetailPage
//
//  Created by Pichan Vasantakitkumjorn on 2/11/15.
//  Copyright (c) 2015 Pichan Vasantakitkumjorn. All rights reserved.
//

import Foundation

class JSONFactory{
    
    var error: NSError?
    var URL:String = "http://cityaudiotourweb.azurewebsites.net/api/attraction/"
    
    
    init(){}
    
    func getJSONArray() -> [JSONObject]?{
        
        var serverDNS : NSURL = NSURL(string:URL)!
        var requestMessage : NSURLRequest = NSURLRequest(URL: serverDNS, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 5000)
        
        let jsonObject = NSURLConnection.sendSynchronousRequest(requestMessage, returningResponse: nil, error: nil)
        
        if ( jsonObject != nil ){
            let jsonDict = NSJSONSerialization.JSONObjectWithData(jsonObject!, options: nil, error: &error) as [NSDictionary]
            var retval = [JSONObject]()
            
            for object in jsonDict {
                retval.append(JSONObject(obj: object))
            }
            
            return retval
        }else{
            return nil
        }
    }
    
    func getJSONObject(AttractionID:Int) -> JSONObject?{
        
        URL = URL + String(AttractionID)
        var serverDNS : NSURL = NSURL(string:URL)!
        var requestMessage : NSURLRequest = NSURLRequest(URL: serverDNS, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 5000)
        
        let jsonObject = NSURLConnection.sendSynchronousRequest(requestMessage, returningResponse: nil, error: nil)
        
        if ( jsonObject != nil ){
            let jsonDict = NSJSONSerialization.JSONObjectWithData(jsonObject!, options: nil, error: &error) as NSDictionary
            
            let retval = JSONObject(obj: jsonDict)
            
            return retval
        }else{
            return nil
        }
    }
    
}