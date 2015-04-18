//
//  MenuControl.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 2/22/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit


class MenuController: NSObject{
    
    //Interacting UI Elements
    private var menuView:UIView!
    private var mainView:UIView!
    
    //All variables for this class
    private var width:CGFloat!
    private var detailPopController:DetailPopUp!
    private var animator:UIDynamicAnimator!
    private var isShowing = false
    
    //Constructor for subclass
    init(MenuView:UIView, MainView:UIView, PopUp:DetailPopUp){
        super.init()
        menuView = MenuView
        mainView = MainView
        detailPopController = PopUp
        width = menuView.frame.width
        self.setupMenu()
    }
    
    
    //Set up Menu. Mainly about gesture.
    private func setupMenu(){
        
        animator = UIDynamicAnimator(referenceView: mainView)
        
        let showGestureReconizer:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "isShow:")
        showGestureReconizer.direction = UISwipeGestureRecognizerDirection.Left
        menuView.addGestureRecognizer(showGestureReconizer)
        
        let hideGestureReconizer:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "isShow:")
        hideGestureReconizer.direction = UISwipeGestureRecognizerDirection.Right
        menuView.addGestureRecognizer(hideGestureReconizer)
    }
    //Call back function for SwipeGestureRecognizer's action.
    func isShow(recognizer:UISwipeGestureRecognizer){
        if recognizer.direction == UISwipeGestureRecognizerDirection.Left{
            isShowing = false
            showMenu(isShowing)
        }else if recognizer.direction == UISwipeGestureRecognizerDirection.Right{
            isShowing = true
            detailPopController.hideDetailPopUp()
            showMenu(isShowing)
        }
    }
    
    //Show and hide menu.
    private func showMenu(isShowing:Bool){
        animator.removeAllBehaviors()
        
        let speed:CGFloat = (isShowing) ? 10 : -10
        let boundaryX:CGFloat = (isShowing) ? width : -width + 20
        
        let slideBehavior:UIGravityBehavior = UIGravityBehavior(items: [menuView])
        slideBehavior.gravityDirection = CGVectorMake(speed, 0)
        animator.addBehavior(slideBehavior)
        
        let StoppingPoint:UICollisionBehavior = UICollisionBehavior(items: [menuView])
        StoppingPoint.addBoundaryWithIdentifier("FlyOutMenuBoundary", fromPoint: CGPointMake(boundaryX, 0), toPoint: CGPointMake(boundaryX, mainView.frame.height))
        animator.addBehavior(StoppingPoint)
    }
    
    //Three below functions will help menu button work properly.
    func isMenuShowing() -> Bool {
        return isShowing
    }
    
    func MenuShown() {
        isShowing = true
        showMenu(isShowing)
    }
    
    func MenuHidden() {
        isShowing = false
        showMenu(isShowing)
    }
}

