//
//  JSONObject.swift
//  DetailPage
//
//  Created by Pichan Vasantakitkumjorn on 2/11/15.
//  Copyright (c) 2015 Pichan Vasantakitkumjorn. All rights reserved.
//

import Foundation

class JSONObject{
    
    private let obj:NSDictionary!
    
    init(obj:NSDictionary){
        self.obj = obj
    }
    
    func getValueForKey(Key:String) -> String{
        
        var retval = obj.objectForKey(Key) as String!
        
        if (retval == nil){
            return "-"
        }else{
            return retval
        }
    }
    
    
}