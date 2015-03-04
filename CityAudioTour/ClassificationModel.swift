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
    
    var categoryList: [Category]?
    var tagList: [Tag]?
    
    
    var selectedCategories: NSMutableSet
    var selectedTags: NSMutableSet
    
    init() {
        server = CATAzureService()
        categoryList = [Category]()
        tagList = [Tag]()
        selectedCategories = NSMutableSet()
        selectedTags = NSMutableSet()
        
        self.LoadCategoryAndTagFromServer()
        
        for category in categoryList! {
            selectedCategories.addObject(category.CategoryID)
        }
        for tag in tagList! {
            selectedTags.addObject(tag.TagID)
        }
    }
    
    func LoadCategoryAndTagFromServer() {
        
        categoryList = self.server?.GetCategoryList()
        tagList = self.server?.GetTagList()
      
    }
    
}
