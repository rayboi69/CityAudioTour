//
//  DetailViewController.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 2/12/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailViewController: UIViewController {
    
    @IBOutlet weak var AttractionName: UILabel!
    @IBOutlet weak var UIImageAttractionImage: UIImageView!
    @IBOutlet weak var AttractionDetail: UITextView!
    @IBOutlet weak var WorkingHours: UILabel!
    @IBOutlet weak var AttractionAddress: UILabel!
    @IBOutlet weak var LoadingView: UIActivityIndicatorView!
    
    @IBOutlet weak var addCusBtn: UIButton!
    @IBOutlet weak var audioBtn: UIButton!
    
    
    //    @IBAction func addToMyRoute(sender: UIButton) {
    //        var myRoute = SelectAttractionsManager.sharedInstance
    //        myRoute.addAttraction(receiveID!)
    //    }
    
    var recvattract:Attraction!
    
    private var service = CATAzureService()
    
    @IBAction func addCustom(sender: AnyObject) {
        
        var alert: UIAlertController
        let selectAttractionsManager = SelectAttractionsManager.sharedInstance
        
        if selectAttractionsManager.isContain(recvattract.AttractionID) {
            alert = UIAlertController(title: recvattract.AttractionName + " was already added to your route.", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okey", style: UIAlertActionStyle.Default, handler: nil))
        } else {
            alert = UIAlertController(title: "Add " + recvattract.AttractionName, message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
                selectAttractionsManager.addAttraction(self.recvattract.AttractionID)
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    //Set up UI on Detail page.
    private func setUpUI(){
        
        LoadingView.opaque = true
        LoadingView.startAnimating()
        AttractionName.text = recvattract.AttractionName
        AttractionAddress.text = recvattract.addrSecForm
        AttractionDetail.text = recvattract.Detail
        //WorkingHours.text = "Mon - Fri\n12:00 - 20:00\nSat-Sun\n 10:00 - 17:00"
        
        var data:NSData!
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            if(self.recvattract.ImagesURLs.count > 0)
            {
                var firstImageURL = self.recvattract.ImagesURLs.first
                let url = NSURL(string: firstImageURL!)
                data = NSData(contentsOfURL: url!)
                
            }
            dispatch_async(dispatch_get_main_queue(),{
                if (data != nil)
                {
                    self.UIImageAttractionImage.image = UIImage(data: data!)
                    self.LoadingView.stopAnimating()
                    self.LoadingView.hidden = true
                }
            });
        });
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "audioPage") {
            var audioViewController:AudioTourViewController = segue.destinationViewController as! AudioTourViewController
            audioViewController.receiveID = recvattract.AttractionID
        }
    }
    
}
