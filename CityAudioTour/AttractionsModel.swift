//
//  AttractionsModel.swift
//  CityAudioTour
//
//  Created by Juan Garcia on 2/23/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import Foundation
class AttractionsModel {
    
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
    
    func FilterAttraction() {
        println("...");
    }
}
