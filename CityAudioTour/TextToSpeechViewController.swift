//
//  TextToSpeechViewController.swift
//  CityAudioTour
//
//  Created by Red_iMac on 2/12/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit
import AVFoundation

class TextToSpeechViewController: UIViewController {
    
    var receiveID : Int?
    var synthersizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance(string: "")
    
    @IBOutlet weak var attractionLabel: UILabel!
    @IBOutlet weak var speechContent: UITextView!
    
    @IBAction func BackToMapView(sender: UIBarButtonItem) {
        navigationController?.popToRootViewControllerAnimated(true)
    }

    @IBAction func playAudio(sender: UIButton) {
        
        if !synthersizer.speaking{
            utterance = AVSpeechUtterance(string: speechContent.text)
            utterance.rate = 0.3
            synthersizer.speakUtterance(utterance)
        } else if synthersizer.paused{
            synthersizer.continueSpeaking()
        }
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        synthersizer.stopSpeakingAtBoundary(.Immediate)
    }
    
    @IBAction func pauseAudio(sender: AnyObject) {
        synthersizer.pauseSpeakingAtBoundary(.Immediate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //synthersizer.speakUtterance(utterance)
        self.retrieveDataFromServer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        synthersizer.stopSpeakingAtBoundary(.Immediate)
    }
    
    func retrieveDataFromServer() {
        let subURL = "http://cityaudiotourweb.azurewebsites.net/api/attraction/"
        let url = NSURL(string: "\(subURL)\(receiveID!)/contents")
        var request = NSURLRequest(URL: url!)
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        if data != nil {
            var content = JSON(data: data!)
            
            var title = content[1]["Title"]
            attractionLabel.attributedText = NSAttributedString(string: "\(title)")
            
            var speechText = content[1]["Description"]
            speechContent.attributedText = NSMutableAttributedString(string: "\(speechText)")
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
