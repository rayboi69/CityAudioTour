//
//  DetailPopUp.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 4/8/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit

class DetailPopUp: NSObject {
    
    //Interacting UI Elements
    private var popUpView:UIView!
    private var mainView:UIView!
    private var animator:UIDynamicAnimator!
    //All variables for this class
    private var isShowing:Bool = false
    private var showBoundary:CGFloat!
    private var hideBoundary:CGFloat!
    
    //Need this constructor to create a super class (NSObject).
    
    init(popUpView:UIView,mainView:UIView){
        super.init()
        self.popUpView = popUpView
        self.mainView = mainView
        showBoundary = mainView.frame.size.height - popUpView.frame.height
        hideBoundary = popUpView.frame.origin.y + popUpView.frame.height
        self.setupPopup()
    }
    
    //Set up Detail Pop up and gesture.
    private func setupPopup(){
        animator = UIDynamicAnimator(referenceView: mainView)
        
        let hideGestureReconizer:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "isShow:")
        hideGestureReconizer.direction = UISwipeGestureRecognizerDirection.Down
        popUpView.addGestureRecognizer(hideGestureReconizer)
        let showGestureReconizer:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "isShow:")
        showGestureReconizer.direction = UISwipeGestureRecognizerDirection.Up
        popUpView.addGestureRecognizer(showGestureReconizer)
        
    }

    //Call back function for SwipeGestureRecognizer's action.
    func isShow(recognizer:UISwipeGestureRecognizer){
        if recognizer.direction == UISwipeGestureRecognizerDirection.Down{
            isShowing = false
            showPopUp(isShowing)
        }else if recognizer.direction == UISwipeGestureRecognizerDirection.Up{
            isShowing = true
            showPopUp(isShowing)
        }
    }
    
    //Show and hide menu.
    private func showPopUp(isShowing:Bool){
        animator.removeAllBehaviors()
        
        let speed:CGFloat = (isShowing) ? -10 : 10
        let boundaryY:CGFloat = (isShowing) ? showBoundary : hideBoundary
        
        let slideBehavior:UIGravityBehavior = UIGravityBehavior(items: [popUpView])
        slideBehavior.gravityDirection = CGVectorMake(0, speed)
        animator.addBehavior(slideBehavior)
        
        let StoppingPoint:UICollisionBehavior = UICollisionBehavior(items: [popUpView])
        StoppingPoint.addBoundaryWithIdentifier("DetailPopUpBoundary", fromPoint: CGPointMake(0, boundaryY), toPoint: CGPointMake(mainView.frame.size.width,boundaryY))
        animator.addBehavior(StoppingPoint)
    }

//    func showDetailPopUp(){
//        if !isShowing {
//            isShowing = true
//            showPopUp(isShowing)
//        }
//    }
//    
//    func hideDetailPopUp(){
//        if isShowing{
//            isShowing = false
//            showPopUp(isShowing)
//        }
//    }
    
}
