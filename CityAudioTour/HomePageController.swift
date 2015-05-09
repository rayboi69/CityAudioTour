//
//  HomePageController.swift
//  CityAudioTour
//
//  Created by Juan Garcia on 5/5/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit

class HomePageController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch(identifier){
                
            case "RoutePage":
                let resultScene:UITabBarController = segue.destinationViewController as! UITabBarController
                let tableView = resultScene.viewControllers!.first as! ResultTableViewController
                tableView.sectionTitle = "Route List"
                
            case "AttractionPage":
    
                let resultScene:UITabBarController = segue.destinationViewController as! UITabBarController
                let tableView = resultScene.viewControllers!.first as! ResultTableViewController
                tableView.sectionTitle = "Attraction List"
            
            case "HomeToMyRoute":
                
                let selectAttractionScene = segue.destinationViewController as! SelectAttractionsTableViewController
                selectAttractionScene.identify = "My Route"
                
            default: break
            }
        }
    }
}
