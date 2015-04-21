//
//  SoundManager.swift
//  SalCam
//
//  Created by Raul on 4/21/15.
//  Copyright (c) 2015 rauluranga. All rights reserved.
//

import AVFoundation

class SoundManager {
    
    let audioPlayer = AVAudioPlayer()
    
    class var sharedInstance: SoundManager {
        struct Static {
            static let instance: SoundManager = SoundManager()
        }
        return Static.instance
    }
    
    init () {
        var path:String? = NSBundle.mainBundle().pathForResource("beep", ofType: "mp3")
        var alertSound = NSURL(fileURLWithPath: path!)
        
        // Removed deprecated use of AVAudioSessionDelegate protocol
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: alertSound, error: &error)
        audioPlayer.prepareToPlay()
        audioPlayer.numberOfLoops = -1
    }
    
    func playAlarm () {
        if !audioPlayer.playing {
            audioPlayer.play();
        }
    }
    
    func stopAlarm () {
        audioPlayer.stop();
    }
}