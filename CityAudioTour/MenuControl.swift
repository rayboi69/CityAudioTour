//
//  MenuControl.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 2/22/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit


class MenuController: NSObject{
    
    let menuView:UIView!
    let mainView:UIView!
    let width:CGFloat!
    var animator:UIDynamicAnimator!
    //Need this constructor to create a super class (NSObject).
    override init(){
        super.init()
    }
    //Constructor for subclass
    init(MenuView:UIView, MainView:UIView){
        super.init()
        menuView = MenuView
        mainView = MainView
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
            showMenu(false)
        }else{
            showMenu(true)
        }
    }
    
    //Show and hide menu.
    func showMenu(isShowing:Bool){
        animator.removeAllBehaviors()
        
        let speed:CGFloat = (isShowing) ? 10 : -10
        let boundaryX:CGFloat = (isShowing) ? width : -width + 20
        
        let slideBehavior:UIGravityBehavior = UIGravityBehavior(items: [menuView])
        slideBehavior.gravityDirection = CGVectorMake(speed, 0)
        animator.addBehavior(slideBehavior)
        
        let StoppingPoint:UICollisionBehavior = UICollisionBehavior(items: [menuView])
        StoppingPoint.addBoundaryWithIdentifier("FlyOutMenuBoundary", fromPoint: CGPointMake(boundaryX, 0), toPoint: CGPointMake(boundaryX, mainView.frame.size.width))
        animator.addBehavior(StoppingPoint)
    }
    
}

