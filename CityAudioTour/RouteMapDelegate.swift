//
//  RouteMapDelegate.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 5/7/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import Foundation
import MapKit

class RouteMapDelegate: NSObject, MKMapViewDelegate{
    
    private let textCoor_X:CGFloat = 9.5;
    private let textCoor_Y:CGFloat = 6;
    private let routeView:RouteMapViewController!
    
    init(routeView:RouteMapViewController){
        self.routeView = routeView
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        var renderer : MKPolylineRenderer! = nil
        if let overlay = overlay as? MKPolyline {
            renderer = MKPolylineRenderer(polyline:overlay)
            renderer.strokeColor = UIColor.blueColor().colorWithAlphaComponent(1)
            renderer.lineWidth = 5
        }
        return renderer
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        var selectedAnnotation = view.annotation as! pinHolder
        
        routeView.attractNameLabel.setTitle(selectedAnnotation.attraction.AttractionName, forState: UIControlState.Normal)
        routeView.addrLabel.text = selectedAnnotation.attraction.AttractionAddress
        routeView.attractIndex = selectedAnnotation.index - 1
        
        
        if(routeView.attractIndex == 0){
            routeView.prevBtn.enabled = false
            routeView.prevBtn.hidden = true
            
            if routeView.nextBtn.hidden {
                routeView.nextBtn.enabled = true
                routeView.nextBtn.hidden = false
            }
            
        }else if(routeView.attractIndex == routeView.attractList.count - 1){
            routeView.nextBtn.enabled = false
            routeView.nextBtn.hidden = true
            
            if routeView.prevBtn.hidden {
                routeView.prevBtn.enabled = true
                routeView.prevBtn.hidden = false
            }
        }else{
            routeView.nextBtn.enabled = true
            routeView.nextBtn.hidden = false
            routeView.prevBtn.enabled = true
            routeView.prevBtn.hidden = false
        }

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
}