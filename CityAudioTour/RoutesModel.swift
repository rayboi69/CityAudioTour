//
//  RoutesModel.swift
//  CityAudioTour
//
//  Created by Juan Garcia on 2/26/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import Foundation
class RoutesModel {
    
    class var sharedInstance: RoutesModel {
        struct Static {
            static var instance: RoutesModel?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = RoutesModel()
        }
        
        return Static.instance!
    }
    
    private var _service: CATAzureService?
    private var _routesList: [Route]?
    private var _selectRoutesIndexes: [Int]?

    
    init() {
        _service = CATAzureService()
        self.LoadRoutesList()
    }
    
    //
    // Initializes the _routesList with the data from the server
    //
    func LoadRoutesList()
    {
        _routesList = _service?.GetRoutes()
    }
    
    //
    //
    //
    func GetRouteBy(id:Int) -> Route
    {
        let routesResult = _routesList?.filter({ m in
            m.RouteID == id
        })
        return routesResult!.first as AnyObject as Route
    }
    
    
    //
    // TODO - Implement method to Get Attractions By Route ID
    //
    
    
    //
    //Lazy Getters
    //
    var routesList: [Route]
        {
        get {
            return _routesList!
        }
    }
    
    
}
