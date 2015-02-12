//
//  DBConnector.swift
//  DetailPage
//
//  Created by Pichan Vasantakitkumjorn on 2/6/15.
//  Copyright (c) 2015 Pichan Vasantakitkumjorn. All rights reserved.
//

import Foundation

class DBConnector
{
    
    var URL:String = "http://cityaudiotourweb.azurewebsites.net/api/attraction/" // URL for our database
    let ID:Int! // Attraction ID
    
    
    init(AttractionID:Int){
        ID = AttractionID
        URL = URL + String(ID)
    }
    
    internal func execute(){
        //do something with URL first before calling connectToDB method
        connectToDB()
    }
    
    private func connectToDB(){
        
        // For single
        var error: NSError?
        var serverDNS : NSURL = NSURL(string: URL)!
        var requestMessage : NSURLRequest = NSURLRequest(URL: serverDNS, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 5000)
        
        let jsonObject = NSURLConnection.sendSynchronousRequest(requestMessage, returningResponse: nil, error: nil)
        
        if (jsonObject != nil){
            let jsonDict = NSJSONSerialization.JSONObjectWithData(jsonObject!, options: nil, error: &error) as NSDictionary
            
            var address = jsonDict.objectForKey("Address1") as String!
            
            if(address == nil){
                address = "REY"
            }
            
            println(address)
            
        }
    }
}