//
//  AttractionMapDelegate.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 5/7/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import MapKit

class AttractionMapDelegate: NSObject,MKMapViewDelegate{
    
    private let textCoor_X:CGFloat = 9.5;
    private let textCoor_Y:CGFloat = 6;
    private let mapController:AttractionMapController
    
    init(controller:AttractionMapController){
        mapController = controller
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        var number = (annotation as! pinHolder).index
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            pinView!.canShowCallout = true
            pinView!.animatesDrop = false
            
            if number > 9 {
                pinView!.image = addTextinUIImage(NSString(string: String(number)), image: UIImage(named: "PinPoint")!, atPoint: CGPointMake(textCoor_X - 3, textCoor_Y))
            }else{
                pinView!.image = addTextinUIImage(NSString(string: String(number)), image: UIImage(named: "PinPoint")!, atPoint: CGPointMake(textCoor_X, textCoor_Y))
            }
            pinView!.calloutOffset = CGPointMake(pinView!.calloutOffset.x + 8, pinView!.calloutOffset.y)
            
        }else{
            pinView!.annotation = annotation
            pinView!.image = addTextinUIImage(NSString(string: String((annotation as! pinHolder).index)), image: UIImage(named: "PinPoint")!, atPoint: CGPointMake(textCoor_X, textCoor_Y))
        }
        
        return pinView
        
    }
    
    func addTextinUIImage(drawtext:NSString,image:UIImage,atPoint:CGPoint) -> UIImage!{
        
        // Setup the font specific variables
        let Color:UIColor = UIColor.blackColor()
        let Font:UIFont = UIFont(name: "Helvetica Bold", size: 10)!
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(image.size)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName:Font,
            NSForegroundColorAttributeName: Color
        ]
        //Put the image into a rectangle as large as the original image.
        image.drawInRect(CGRectMake(0, 0, image.size.width , image.size.height))
        // Creating a point within the space that is as bit as the image.
        let rect:CGRect = CGRectMake(atPoint.x, atPoint.y,image.size.width, image.size.height)
        //Now Draw the text into an image.
        drawtext.drawInRect(rect, withAttributes: textFontAttributes)
        // Create a new image out of the images we have created
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        var selectedAnnotation = view.annotation as! pinHolder
        
        mapController.NameLabel.text = selectedAnnotation.attraction.AttractionName
        mapController.addrLabel.text = selectedAnnotation.attraction.AttractionAddress
        mapController.distanceLabel.text = "\(selectedAnnotation.attraction.Distance) miles"
        mapController.index = selectedAnnotation.index - 1
        
        
        if(mapController.index == 0){
            mapController.prevBtn.enabled = false
            mapController.prevBtn.hidden = true
            
            if mapController.nextBtn.hidden {
                mapController.nextBtn.enabled = true
                mapController.nextBtn.hidden = false
            }
            
        }else if(mapController.index == mapController.list.count - 1){
            mapController.nextBtn.enabled = false
            mapController.nextBtn.hidden = true
            
            if mapController.prevBtn.hidden {
                mapController.prevBtn.enabled = true
                mapController.prevBtn.hidden = false
            }
        }else{
            mapController.nextBtn.enabled = true
            mapController.nextBtn.hidden = false
            mapController.prevBtn.enabled = true
            mapController.prevBtn.hidden = false
        }
    }
    
}

class pinHolder:MKPointAnnotation{
    let attraction:Attraction
    let index:Int
    
    init(attraction:Attraction,index:Int){
        self.attraction = attraction
        self.index = index
    }
    
}

