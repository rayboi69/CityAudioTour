//
//  MainMapViewController.swift
//  CityAudioTour
//
//  Created by Raul Rey Aso on 2/5/2015
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit
import MapKit

class MainMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mainMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var currentlat = 41.876189
        var currentlon = -87.627418

        var location = CLLocationCoordinate2D(latitude: currentlat, longitude: currentlon)
        var span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        var region = MKCoordinateRegion(center: location, span: span)
        
        self.mainMapView.setRegion(region, animated: true)
        self.mainMapView.showsUserLocation = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

