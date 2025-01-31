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

public class Attraction{
    
    var AttractionName = ""
    var AttractionAddress = ""
    var addrSecForm = ""
    var Detail = ""
    var Content = ""
    var AttractionID = 0
    var CategoryID = 0
    var Distance = 0.0
    var AttractionImage = UIImage()
    var Latitude = 0.0
    var Longitude = 0.0
    var TagIDs: [Int] = []
    var ImagesURLs = [String]()
    
    // temp variables here
    var FlyingDistance = 0.0
    var WalkingDistance = 0.0

    init(){}
        
    func setAddress(address:String, city:String, state:String, ZIP:String){
        self.AttractionAddress = address + " " + city + "," + state + " " + ZIP
        self.addrSecForm = address + "\n" + city + "," + state + " " + ZIP
    }
    
    
}

