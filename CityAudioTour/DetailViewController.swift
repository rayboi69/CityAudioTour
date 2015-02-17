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
        //AttractionImage.image = attraction.getAttractionImage()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attraction = service.GetAttraction(receiveID!)
        
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
        
        
        if(attraction != nil){
            setUpUI(attraction!)
        }else{
            //do something if connection is failed.
        }
        //AttractionAddress.text = "201 East Randolph Street\nChicago, IL 60602"
        //AttractionName.text = "Millennium Park"
        WorkingHours.text = "Mon - Fri\n12:00 - 20:00\nSat-Sun\n 10:00 - 17:00"
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
            var audioViewController:TextToSpeechViewController = segue.destinationViewController as TextToSpeechViewController
            audioViewController.receiveID = self.receiveID
        }
    }
    
}
