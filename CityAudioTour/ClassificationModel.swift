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
    
    let server: CATAzureService?

    var selectedCategories: NSMutableSet?
    var selectedTags: NSMutableSet?
    
    var categoryList: [Category]?
    var tagList: [Tag]?
    
    init() {
        //TODO - Populate with real ids from the filtering screen
        server = CATAzureService()
        categoryList = [Category]()
        tagList = [Tag]()
        
        self.LoadCategoryAndTagFromServer()
        selectedCategories?.setByAddingObjectsFromArray(categoryList!)
        selectedTags?.setByAddingObjectsFromArray(tagList!)
        
    }
    
    func LoadCategoryAndTagFromServer() {
        categoryList = self.server?.GetCategoryList()
        tagList = self.server?.GetTagList()
    }
}
