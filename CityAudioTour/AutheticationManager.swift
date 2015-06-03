//
//  AutheticationManager.swift
//  CityAudioTour
//
//  Created by Juan Garcia on 4/15/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import Foundation
class AuthenticationManager
{
    //
    //Singleton Pattern
    //
    class var sharedInstance: AuthenticationManager
    {
        
        struct Static {
            static var instance: AuthenticationManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = AuthenticationManager()
        }
        
        return Static.instance!
    }
    
    private var _service: CATAzureService?
    
    init()
    {
        _service = CATAzureService()
    }
    
    func Login(email: String, pass: String)
    {
        //TODO - Uncomment when JSONJoy code has been removed
       /* _service?.AuthenticateUser(email, password: pass){(succeeded: Bool, msg: String, result: User) -> () in
            println("After logging \(msg)")
        }*/
        
    }
    
    
}