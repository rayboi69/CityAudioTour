//
//  AttractionImage.swift
//  CityAudioTour
//
//  Created by Juan Garcia on 2/16/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import Foundation

class AttractionImage{
    private var AttractionImageID:Int = 0
    private var AttractionID:Int = 0
    private var URL:String = ""
    
    init(){}
    
    /*
    All set methods.
    */
    func setAttractionImageID(id:Int){
        self.AttractionImageID = id
    }
    
    func setAttractionID(id:Int){
        self.AttractionID = id
    }
    
    func setURL(url:String){
        self.URL = url
    }
    
    
    /*
    All get methods.
    */
    func getAttractionImageID() -> Int {
        return AttractionImageID
    }
    
    func getAttractionID() -> Int {
        return AttractionID
    }
    
    func getURLl() -> String {
        return URL
    }
    
    
}