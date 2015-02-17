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
            utterance.rate = 0.1
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
        self.retrieveDataFromServer()
        // Set text view to start at the top line
        speechContent.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        synthersizer.stopSpeakingAtBoundary(.Word)
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
            /* Dummy content for test
            var speechText = "Stunned, I packed my unworn clothes and fled to O'Hare. With no other seat left on the plane, I found myself seated next to an elderly man -- heavy, sick-looking, asthmatic. Humiliated at the failure of my book tour, I could hardly breathe myself. After about fifteen minutes I asked my seat mate about his work, desperate for a way to escape the silence. Slowly, over dense cumulus clouds, he began to reveal his odyssey. Starting out delivering milk on a horse-drawn wagon, he realized the need to join forces with other drivers to negotiate a fairer living wage. As one of the early Teamsters, he began to work for the union and his interest shifted to helping it grow. I was fascinated, for even though I had spent a short time as a labor negotiator for the AFL-CIO, I didn't know much -- or at least much good-- about the Teamsters.\nAs he told me in detail about his work, decade-by-decade, he grew more animated and I was hooked. But, he confessed, he was retired now and grieving for his wife who had recently died. Gone were their dreams to travel and enjoy this uncharted leisure. Listening intently, I realized that he had a second chance to share a yet untold story of the American labor movement. I took out a pen and my hotel stationery and began to write out a plan for him to do just that, advising him to contact high schools, community colleges and civic groups to hire him as a lecturer.\nStunned, I packed my unworn clothes and fled to O'Hare. With no other seat left on the plane, I found myself seated next to an elderly man -- heavy, sick-looking, asthmatic. Humiliated at the failure of my book tour, I could hardly breathe myself. After about fifteen minutes I asked my seat mate about his work, desperate for a way to escape the silence. Slowly, over dense cumulus clouds, he began to reveal his odyssey. Starting out delivering milk on a horse-drawn wagon, he realized the need to join forces with other drivers to negotiate a fairer living wage. As one of the early Teamsters, he began to work for the union and his interest shifted to helping it grow. I was fascinated, for even though I had spent a short time as a labor negotiator for the AFL-CIO, I didn't know much -- or at least much good-- about the Teamsters.\nAs he told me in detail about his work, decade-by-decade, he grew more animated and I was hooked. But, he confessed, he was retired now and grieving for his wife who had recently died. Gone were their dreams to travel and enjoy this uncharted leisure. Listening intently, I realized that he had a second chance to share a yet untold story of the American labor movement. I took out a pen and my hotel stationery and began to write out a plan for him to do just that, advising him to contact high schools, community colleges and civic groups to hire him as a lecturer."
            */
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
