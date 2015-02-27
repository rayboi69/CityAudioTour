//
//  DetailViewController.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 2/12/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var AttractionDetail: UITextView!
    @IBOutlet weak var UIImageAttractionImage: UIImageView!
    @IBOutlet weak var AttractionName: UILabel!
    @IBOutlet weak var WorkingHours: UILabel!
    @IBOutlet weak var AttractionAddress: UILabel!
   
    var receiveID : Int?

    var attractionImages = [AttractionImage]()
    var service = CATAzureService()

    
    //Set up UI on Detail page.
    private func setUpUI(attraction:Attraction){
        /*Right now, my code doesn't handle nil or null value.
        We can figure it out later.*/
        AttractionName.text = attraction.AttractionName
        AttractionAddress.text = attraction.AttractionAddress
        AttractionDetail.text = attraction.Detail
        WorkingHours.text = "Mon - Fri\n12:00 - 20:00\nSat-Sun\n 10:00 - 17:00"
        //AttractionImage.image = attraction.getAttractionImage()
    }
    
    private func setUpDetail(response:NSURLResponse!,data:NSData!,error:NSError!) -> Void{
        
        if data != nil{
            let attraction = Attraction()
        
            let json = JSON(data:data!)
        
            var address = json["Address"].stringValue
            var city = json["City"].stringValue
            var state = json["StateAbbreviation"].stringValue
            var zip = json["ZipCode"].stringValue
        
            attraction.setAddress(address, city: city, state: state, ZIP: zip)
            attraction.AttractionName = json["Name"].stringValue
            attraction.Detail = json["Details"].stringValue
            attraction.Content = json["TextContent"].stringValue
            
            dispatch_async(dispatch_get_main_queue(), {
                self.setUpUI(attraction)
            })
        }else{
            //Do Something when no connection.
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let handler = setUpDetail
        
        service.GetAttraction(receiveID!, MainThread: NSOperationQueue.mainQueue(), handler: handler)
        
        attractionImages = service.GetAttractionImagebyId(receiveID!);
        
        if(attractionImages.count > 0)
        {
            var firstImage = attractionImages.first
            let url = NSURL(string: firstImage!.getURLl())
            var data = NSData(contentsOfURL: url!)
            if (data != nil)
            {
                UIImageAttractionImage.image = UIImage(data: data!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "audioPage") {
            var audioViewController:AudioTourViewController = segue.destinationViewController as AudioTourViewController
            audioViewController.receiveID = self.receiveID
        }
    }
    
}
