//
//  AuthToken.swift
//  CityAudioTour
//
//  Created by Juan Garcia on 4/21/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import Foundation
import JSONJoy

struct AuthToken : JSONJoy {
    var access_token: String?
    var userName: String?
    
    init() {
    }
    
    init(_ decoder: JSONDecoder) {
        access_token = decoder["access_token"].string
        userName = decoder["userName"].string
    }
}