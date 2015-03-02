//
//  TextToSpeech.swift
//  CityAudioTour
//
//  Created by Red_iMac on 3/1/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import Foundation
import AVFoundation

class TextToSpeech: NSObject {
    var synthersizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance(string: "")
    
    //var delegate: AVSpeechSynthesizerDelegate?
    
    func setUtterance() {
        utterance.rate = 0.1
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
    }
    
    func play(text: String) {
        if !synthersizer.speaking{
            utterance = AVSpeechUtterance(string: text)
            self.setUtterance()
            synthersizer.speakUtterance(utterance)
        } else if synthersizer.paused{
            synthersizer.continueSpeaking()
        }
    }
    
    func pause() {
        synthersizer.pauseSpeakingAtBoundary(.Immediate)
    }
    
    func stop() {
        synthersizer.stopSpeakingAtBoundary(.Immediate)
    }
    
}
