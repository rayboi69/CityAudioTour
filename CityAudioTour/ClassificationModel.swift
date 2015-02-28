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

    var selectedCategories: NSMutableSet
    var selectedTags: NSMutableSet
    
    var categoryList: [Category]?
    var tagList: [Tag]?
    
    init() {
        //TODO - Populate with real ids from the filtering screen
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
        /*
        categoryList = self.server?.GetCategoryList()
        tagList = self.server?.GetTagList()
        */
        
        //Useing fake data
        self.getFakeData()
    }
    
    func getFakeData() {
        categoryList?.append(Category(id: 1, name: "Category: 1"))
        categoryList?.append(Category(id: 2, name: "Category: 2"))
        categoryList?.append(Category(id: 3, name: "Category: 3"))
        categoryList?.append(Category(id: 4, name: "Category: 4"))
        
        tagList?.append(Tag(id: 1, name: "Tag: 1"))
        tagList?.append(Tag(id: 2, name: "Tag: 2"))
        tagList?.append(Tag(id: 3, name: "Tag: 3"))
        tagList?.append(Tag(id: 4, name: "Tag: 4"))
        tagList?.append(Tag(id: 5, name: "Tag: 5"))
        tagList?.append(Tag(id: 6, name: "Tag: 6"))
        tagList?.append(Tag(id: 7, name: "Tag: 7"))
        tagList?.append(Tag(id: 8, name: "Tag: 8"))
        tagList?.append(Tag(id: 9, name: "Tag: 9"))
        tagList?.append(Tag(id: 10, name: "Tag: 10"))
    }

}
