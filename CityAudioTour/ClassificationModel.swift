//
//  ClassificationModel.swift
//  CityAudioTour
//
//  Created by Juan Garcia on 2/26/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import Foundation
class ClassificationModel {
    
    class var sharedInstance: ClassificationModel {
        struct Static {
            static var instance: ClassificationModel?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = ClassificationModel()
        }
        
        return Static.instance!
    }
    
    var SelectedCategories: [Int]
    var SelectedTags: [Int]
    
    init() {
        //TODO - Populate with real ids from the filtering screen
        SelectedCategories = [1,2,5]
        SelectedTags = [1,3,4,5,6,10,15]
    }
    
    
}
