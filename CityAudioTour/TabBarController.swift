//
//  TabBarController.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 5/7/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController,UITabBarControllerDelegate {

    var tableView:ResultTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        tableView = self.viewControllers![0] as! ResultTableViewController
        
        if tableView.sectionTitle == "Route List"{
            self.tabBar.hidden = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        if viewController is AttractionMapController {
            println("TabCall")
            if tableView.dataChanged {
                let mapView = viewController as! AttractionMapController
                mapView.list = tableView.attractions
                mapView.index = 0
                mapView.CreatePinPoint()
                tableView.dataChanged = false
            }
        }
    }

}
