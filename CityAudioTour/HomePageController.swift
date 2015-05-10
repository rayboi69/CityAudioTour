//
//  HomeViewController.swift
//  CityAudioTour
//
//  Created by Juan Garcia on 5/5/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController, UIScrollViewDelegate{
    
    var _imagesScrollView: UIScrollView!
    var _buttonsContentView: UIView!
    var _leftBottomView: UIView!
    var _leftTopView: UIView!
    var _rightBottomView: UIView!
    var _rightTopView: UIView!
    var _leftBottomBtn: UIButton!
    var _leftTopBtn: UIButton!
    var _rightBottomBtn: UIButton!
    var _rightTopBtn: UIButton!
    var _images = [UIImage(named: "chicagoHome"),UIImage(named: "newyorkHome")]
    var _pageControl: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(buttonsContentView)
        self.view.addSubview(imagesScrollView)
        self.buttonsContentView.addSubview(leftBottomView)
        self.buttonsContentView.addSubview(leftTopView)
        self.buttonsContentView.addSubview(rightBottomView)
        self.buttonsContentView.addSubview(rightTopView)
        self.view.addSubview(rightTopBtn)
        self.view.addSubview(rightBottomBtn)
        self.view.addSubview(leftBottomBtn)
        self.view.addSubview(leftTopBtn)
        self.view.addSubview(pageControl)
        
        self.updateViewConstraints()
        
        self.initImagesScrollView()
    }
    
    
    func initImagesScrollView()
    {
        let scrollWidth = CGRectGetWidth(self.imagesScrollView.frame)
        self.imagesScrollView.contentSize = CGSizeMake(scrollWidth * CGFloat(_images.count), self.view.bounds.height/2)
        
        for var i = 0; i < _images.count; i++
        {
            var imageView = UIImageView(image: _images[i])
            var rect = imageView.frame;
            imageView.contentMode = UIViewContentMode.ScaleToFill
            let imageWidth = CGRectGetWidth(self.imagesScrollView.frame)
            imageView.frame = CGRectMake(imageWidth * CGFloat(i), self.imagesScrollView.frame.origin.y, self.imagesScrollView.frame.width, self.imagesScrollView.frame.height);
            imageView.tag = i;
            imagesScrollView.addSubview(imageView)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        var previousPage = pageControl.currentPage;
        var pageWidth = scrollView.frame.size.width
        var fractionalPage = scrollView.contentOffset.x / pageWidth
        var page = lroundf(Float(fractionalPage))
        if (previousPage != page) {
            pageControl.currentPage = page
            
        }
        
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
    
    
    override func updateViewConstraints()
    {
        
        
        buttonsContentView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.view.snp_bottom)
            make.width.equalTo(self.view.snp_width)
            make.height.equalTo(self.view.bounds.height * 0.5)}
        
        leftTopView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(buttonsContentView.snp_top)
            make.left.equalTo(buttonsContentView.snp_left)
            make.width.equalTo(buttonsContentView.frame.width * 0.5)
            make.height.equalTo(buttonsContentView.frame.height * 0.5)
        }
        leftBottomView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(leftTopView.snp_bottom)
            make.left.equalTo(buttonsContentView.snp_left)
            make.width.equalTo(buttonsContentView.frame.width * 0.5)
            make.height.equalTo(buttonsContentView.frame.height * 0.5)
        }
        rightTopView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(buttonsContentView.snp_top)
            make.right.equalTo(buttonsContentView.snp_right)
            make.width.equalTo(buttonsContentView.frame.width * 0.5)
            make.height.equalTo(buttonsContentView.frame.height * 0.5)
        }
        
        rightBottomView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(leftTopView.snp_bottom)
            make.right.equalTo(buttonsContentView.snp_right)
            make.width.equalTo(buttonsContentView.frame.width * 0.5)
            make.height.equalTo(buttonsContentView.frame.height * 0.5)
        }
        
        rightTopBtn.snp_makeConstraints{ (make) -> Void in
            make.centerX.equalTo(rightTopView.snp_centerX)
            make.centerY.equalTo(rightTopView.snp_centerY)
            make.width.equalTo(rightTopView.snp_width)
            make.height.equalTo(rightTopView.snp_height)
        }
        
        rightBottomBtn.snp_makeConstraints{ (make) -> Void in
            make.centerX.equalTo(rightBottomView.snp_centerX)
            make.centerY.equalTo(rightBottomView.snp_centerY)
            make.width.equalTo(rightBottomView.snp_width)
            make.height.equalTo(rightBottomView.snp_height)
        }
        
        leftBottomBtn.snp_makeConstraints{ (make) -> Void in
            make.centerX.equalTo(leftBottomView.snp_centerX)
            make.centerY.equalTo(leftBottomView.snp_centerY)
            make.width.equalTo(leftBottomView.snp_width)
            make.height.equalTo(leftBottomView.snp_width)
        }
        
        leftTopBtn.snp_makeConstraints{ (make) -> Void in
            make.centerX.equalTo(leftTopView.snp_centerX)
            make.centerY.equalTo(leftTopView.snp_centerY)
            make.width.equalTo(leftTopView.snp_width)
            make.height.equalTo(leftTopView.snp_height)
        }
        
        pageControl.snp_makeConstraints{ (make) -> Void in
            make.centerX.equalTo(imagesScrollView.snp_centerX)
            make.bottom.equalTo(imagesScrollView.snp_bottom).offset(-10)
        }
        
        super.updateViewConstraints()
    }
    
    func homeButtonAction(sender:UIButton!)
    {
        var btnsendtag:UIButton = sender
        switch btnsendtag.tag
        {
        case 0:
            self.performSegueWithIdentifier("AttractionPage", sender: self)
        case 1:
            self.performSegueWithIdentifier("RoutePage", sender: self)
        case 2:
            println("Not implemented yet")
        case 3:
            self.performSegueWithIdentifier("HomeToMyRoute", sender: self)
        default:
            println("Something else")
        }
        
    }
    
    //Lazy Getters
    var buttonsContentView: UIView
        {
        get{
            if _buttonsContentView == nil
            {
                _buttonsContentView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height * 0.5))
                _buttonsContentView.backgroundColor=UIColor.greenColor()
            }
            return _buttonsContentView!
        }
    }
    
    var leftBottomView: UIView
        {
        get{
            if _leftBottomView == nil
            {
                _leftBottomView = UIView(frame: CGRectMake(0, 0, 100, 100))
                _leftBottomView.backgroundColor=CommonUtilities.RGBColor("#00CC99")
            }
            return _leftBottomView!
        }
    }
    
    var leftTopView: UIView
        {
        get{
            if _leftTopView == nil
            {
                _leftTopView = UIView(frame: CGRectMake(0, 0, 300, 300))
                _leftTopView.backgroundColor=CommonUtilities.RGBColor("#FFCC66")
            }
            return _leftTopView!
        }
    }
    
    var rightBottomView: UIView
        {
        get{
            if _rightBottomView == nil
            {
                _rightBottomView = UIView(frame: CGRectMake(0, 0, 100, 100))
                _rightBottomView.backgroundColor=CommonUtilities.RGBColor("#66CCFF")
            }
            return _rightBottomView!
        }
    }
    
    var rightTopView: UIView
        {
        get{
            if _rightTopView == nil
            {
                _rightTopView = UIView(frame: CGRectMake(0, 0, 100, 100))
                _rightTopView.backgroundColor=CommonUtilities.RGBColor("#FF9999")
            }
            return _rightTopView!
        }
    }
    
    var imagesScrollView: UIScrollView
        {
        get{
            if _imagesScrollView == nil
            {
                _imagesScrollView = UIScrollView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height/2))
                _imagesScrollView.delegate = self
                _imagesScrollView.pagingEnabled = true
                _imagesScrollView.clipsToBounds = true
                _imagesScrollView.showsHorizontalScrollIndicator = false
                _imagesScrollView.showsVerticalScrollIndicator = false
                _imagesScrollView.bounces = false
            }
            return _imagesScrollView!
        }
    }
    
    var rightTopBtn: UIButton
        {
        get
        {
            if _rightTopBtn == nil
            {
                _rightTopBtn = UIButton(frame: CGRectMake(0, 0, 120, 120))
                _rightTopBtn.setTitle("Popular", forState: UIControlState.Normal)
                _rightTopBtn.tag = 2
                _rightTopBtn.addTarget(self, action: "homeButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            }
            return _rightTopBtn
            
        }
        
    }
    
    var rightBottomBtn: UIButton
        {
        get
        {
            if _rightBottomBtn == nil
            {
                _rightBottomBtn = UIButton(frame: CGRectMake(0, 0, 120, 120))
                _rightBottomBtn.setTitle("My Route", forState: UIControlState.Normal)
                _rightBottomBtn.tag = 3
                _rightBottomBtn.addTarget(self, action: "homeButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            }
            return _rightBottomBtn
            
        }
        
    }
    
    var leftBottomBtn: UIButton
        {
        get
        {
            if _leftBottomBtn == nil
            {
                _leftBottomBtn = UIButton(frame: CGRectMake(0, 0, 120, 120))
                _leftBottomBtn.setTitle("Routes List", forState: UIControlState.Normal)
                _leftBottomBtn.tag = 1
                _leftBottomBtn.addTarget(self, action: "homeButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            }
            return _leftBottomBtn
            
        }
        
    }
    
    var leftTopBtn: UIButton
        {
        get
        {
            if _leftTopBtn == nil
            {
                _leftTopBtn = UIButton(frame: CGRectMake(0, 0, 120, 120))
                _leftTopBtn.setTitle("Search", forState: UIControlState.Normal)
                _leftTopBtn.tag = 0
                _leftTopBtn.addTarget(self, action: "homeButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                
            }
            return _leftTopBtn
            
        }
        
    }
    
    var pageControl: UIPageControl
        {
        get
        {
            if _pageControl == nil
            {
                _pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: 120, height: 100))
                _pageControl.currentPage = 0
                _pageControl.numberOfPages = _images.count
                
            }
            return _pageControl
            
        }
        
    }
    
    
}
