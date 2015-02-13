//
//  Attraction.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 2/12/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

//
//  AttractionDetail.swift
//  DetailPage
//
//  Created by Pichan Vasantakitkumjorn on 2/6/15.
//  Copyright (c) 2015 Pichan Vasantakitkumjorn. All rights reserved.
//

import UIKit

//Concrete Object
class Attraction{
    
    private var AttractionName:String!
    private var AttractionAddress:String!
    private var detail:String!
    private var contect:String!
    //private var contentID:Int!
    private var AttractionID:Int = 0
    private var AttractionImage:UIImage?
    
    init(){}
    /*
    All set methods.
    */
    func setAttractionName(name:String){
        self.AttractionName = name
    }
    
    func setAddress(address:String, city:String, state:String, ZIP:String){
        self.AttractionAddress = address + "\n" + city + "," + state + " " + ZIP
    }
    
    func setDetail(detail:String){
        self.detail = detail
    }
    
    func setContent(content:String){
        self.contect = content
    }
    
    //    func setContentID(contentID:Int){
    //        self.contentID = contentID
    //    }
    
    func setAttractionImage(Image:UIImage){
        self.AttractionImage = Image
    }
    
    /*
    All get methods.
    */
    func getAttractionName() -> String {
        return AttractionName
    }
    
    func getAttractionAddress() -> String {
        return AttractionAddress
    }
    
    func getDetail() -> String {
        return detail
    }
    
    func getContent() -> String {
        return contect
    }
    
    //    func getContentID() -> Int {
    //        return contentID
    //    }
    
    func getAttractionID() -> Int {
        return AttractionID
    }
    
    func getAttractionImage() -> UIImage {
        return AttractionImage!
    }
}

