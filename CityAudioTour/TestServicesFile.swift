//
//  TestServicesFile.swift
//  CityAudioTour
//
//  Created by Raul Rey Aso on 2/9/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import Foundation

//
//  DBConnector.swift
//  DetailPage
//
//  Created by Pichan Vasantakitkumjorn on 2/6/15.
//  Copyright (c) 2015 Pichan Vasantakitkumjorn. All rights reserved.
//

import Foundation

protocol AttractionBuilder{
    func execute()
    func getAttractionObj() -> Attraction
}

class DBConnector : AttractionBuilder{
    
    
    var URL:String = "http://cityaudiotourweb.azurewebsites.net/api/attraction/" // URL for our database
    let retval:AttractionDetail = AttractionDetail() // return value
    let ID:Int! // Attraction ID
    
    
    init(AttractionID:Int){
        ID = AttractionID
        URL = URL + String(ID)
    }
    
    internal func execute(){
        //do something with URL first before calling connectToDB method
        connectToDB()
    }
    internal func getAttractionObj() -> Attraction{
        //retval.setAddress("hello")
        return retval
    }
    
    private func connectToDB(){
        //this method will connect to database to get Attraction information
        //and set up "retval" value that will be return to UI Control class
        
        /*
        //For JSonArray.
        var error: NSError?
        var serverDNS : NSURL = NSURL(string: URL)!
        var requestMessage : NSURLRequest = NSURLRequest(URL: serverDNS, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 5000)
        
        let jsonObject = NSURLConnection.sendSynchronousRequest(requestMessage, returningResponse: nil, error: nil)
        if (jsonObject != nil){
        let jsonDict = NSJSONSerialization.JSONObjectWithData(jsonObject!, options: nil, error: &error) as [NSDictionary]
        var first = jsonDict[0].objectForKey("Name") as String!
        println(first)
        }else{
        
        }*/
        
        // For single
        var error: NSError?
        var serverDNS : NSURL = NSURL(string: URL)!
        var requestMessage : NSURLRequest = NSURLRequest(URL: serverDNS, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 5000)
        
        let jsonObject = NSURLConnection.sendSynchronousRequest(requestMessage, returningResponse: nil, error: nil)
        
        if (jsonObject != nil){
            let jsonDict = NSJSONSerialization.JSONObjectWithData(jsonObject!, options: nil, error: &error) as NSDictionary
            
            var address = jsonDict.objectForKey("Address2") as String!
            if(address == nil){
                address = ""
            }
            //let city = jsonDict.objectForKey("City") as String!
            //let zip = jsonDict.objectForKey("ZipCode") as String!
            //address = address + "\n" + city + " " + zip
            retval.setAddress(address)
            self.retval.setAddress(address)
            self.retval.setAttractionName(jsonDict.objectForKey("Name") as String!)
            self.retval.setContent(jsonDict.objectForKey("TextContent") as String!)
            self.retval.setDetail(jsonDict.objectForKey("Details") as String!)
            println(jsonDict.objectForKey("Latitude") as String!)
            println(jsonDict.objectForKey("Longitude") as String!)
        }else{
            
        }
        /** Asynchronous request doesn't wait for result. Program continues to work immediately.**/
        
        //        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
        //            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
        //            let jsonObject = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
        //
        //            if (jsonObject != nil) {
        //                var address = jsonObject!.objectForKey("Address1") as String!
        //                let city = jsonObject!.objectForKey("City") as String!
        //                let zip = jsonObject!.objectForKey("ZipCode") as String!
        //                address = address + "\n" + city + " " + zip
        //                self.retval.setAddress(address)
        //                self.retval.setAttractionName(jsonObject!.objectForKey("Name") as String!)
        //                self.retval.setContent(jsonObject!.objectForKey("TextContent") as String!)
        //                self.retval.setDetail(jsonObject!.objectForKey("Details") as String!)
        //                println(jsonObject!.objectForKey("Latitude") as String!)
        //                println(jsonObject!.objectForKey("Longitude") as String!)
        //                println(self.retval.getAttractionAddress())
        //                println(self.retval.getAttractionName())
        //
        //            }else{
        //                
        //            }
        //            })
    }
}