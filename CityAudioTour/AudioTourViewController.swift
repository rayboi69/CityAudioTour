//
//  AudioTourViewController.swift
//  CityAudioTour
//
//  Created by Red_iMac on 2/27/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON

class AudioTourViewController: UIViewController, AVSpeechSynthesizerDelegate {
 
    private var service = CATAzureService()
    private var synthersizer = AVSpeechSynthesizer()
    private var utterance = AVSpeechUtterance(string: "")
    var receiveID : Int?
    //For testing purpose
    //var handler = {(response:NSURLResponse!,data:NSData!,error:NSError!) -> Void in}
    
    @IBOutlet weak var attractionLabel: UILabel!
    @IBOutlet weak var speechContent: UITextView!
    
    private func retrieveDataFromServer(response:NSURLResponse!,data:NSData!,error:NSError!) -> Void {
        if data != nil {
            var content = JSON(data: data!)
            var title = content[1]["Title"].stringValue
            var speechText = content[1]["Description"].stringValue
            
            dispatch_async(dispatch_get_main_queue(), {
                self.attractionLabel.text = title
                self.speechContent.attributedText = NSMutableAttributedString(string: speechText)
            })
        }else{
            //Connection Failed. Do something.
        }
        
    }
    
    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.synthersizer.delegate = self
        
        //Comment the below value out if we don't make unit test.
        let handler = retrieveDataFromServer
        service.GetAttractionContentByID(receiveID!, MainThread: NSOperationQueue.mainQueue(), handler: handler)
        
        //speechContent.scrollRangeToVisible(NSMakeRange(0, 0))     // Set text view to start at the top line
    }
    
    override func viewWillDisappear(animated: Bool) {
        synthersizer.stopSpeakingAtBoundary(.Word)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Audio Controller Buttons
    
    @IBAction func pauseAudio(sender: AnyObject) {
        synthersizer.pauseSpeakingAtBoundary(.Immediate)
    }
    
    @IBAction func playAudio(sender: UIButton) {
        if !synthersizer.speaking{
            utterance = AVSpeechUtterance(string: speechContent.text)
            utterance.rate = 0.1
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            synthersizer.speakUtterance(utterance)
        } else if synthersizer.paused{
            synthersizer.continueSpeaking()
        }
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        synthersizer.stopSpeakingAtBoundary(.Immediate)
    }
    
    // MARK: - Delegate
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didFinishSpeechUtterance utterance: AVSpeechUtterance!) {
        speechContent.attributedText = NSAttributedString(string: utterance.speechString)
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance!) {
        let s = (utterance.speechString as NSString).substringWithRange(characterRange)
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: characterRange)
        speechContent.attributedText = mutableAttributedString
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didCancelSpeechUtterance utterance: AVSpeechUtterance!) {
        speechContent.attributedText = NSAttributedString(string: utterance.speechString)
    }
    
    // MARK: - Navigation
    
    @IBAction func BackToMapView(sender: UIBarButtonItem) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
}
