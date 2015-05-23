//
//  ClassificationManager.swift
//  CityAudioTour
//
//  Created by Juan Garcia on 2/26/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import Foundation
class ClassificationManager {
    
    class var sharedInstance: ClassificationManager {
        struct Static {
            static var instance: ClassificationManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = ClassificationManager()
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
    
    func GetCategoryBy(id:Int) -> String {
        let result = categoryList!.filter({ m in
            m.CategoryID == id
        })
        return result.first!.Name
    }
    
    func GetTagBy(id:Int) -> String {
        let result = tagList!.filter({ m in
            m.TagID == id
        })
        return result.first!.Name
    }
}
