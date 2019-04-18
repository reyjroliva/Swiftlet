//
//  BinauralAudio.swift
//  Swiftlet
//
//  Created by Cale Cohee on 4/15/19.
//  Copyright © 2019 Rey Oliva. All rights reserved.
//

import Foundation
import AVFoundation

class BinauralAudio {
    var audioPlayer: AVAudioPlayer?
    var targetPace = 8.0;
    
    func checkPace(pace: Double)
    {
        let difference = targetPace - pace
        
        // Ahead desired pace
        if(difference >= 5)
        {
            playSound(index: 5)
        }
        else if(difference >= 3)
        {
            playSound(index: 3)
        }
        else if(difference >= 1)
        {
            playSound(index: 1)
        }

        // Behind desired pace
        else if(difference <= -5)
        {
            playSound(index: -5)
        }
        else if(difference <= -3)
        {
            playSound(index: -3)
        }
        else if(difference <= -1)
        {
            playSound(index: -1)
        }
        
        // Keeping target pace
        else
        {
            print("==")
        }
    }
    
    func stopSound()
    {
        if(audioPlayer!.isPlaying)
        {
            audioPlayer?.stop()
        }
    }
    
    func playSound(index: Int)
    {
        var fileURL: String?
        
        if(index < 0)
        {
            fileURL = Bundle.main.path(forResource: "back", ofType: "wav")
        }
        else
        {
            fileURL = Bundle.main.path(forResource: "front", ofType: "wav")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL!))
        } catch let error {
            print("Can't play the audio file. Failed with an error \(error)")
        }
        
        switch(abs(index))
        {
        case 5:
            audioPlayer?.volume = 0.25
        case 3:
            audioPlayer?.volume = 0.5
        case 1:
            audioPlayer?.volume = 0.75
        default:
            audioPlayer?.volume = 1
        }
        
        var vol = audioPlayer?.volume
        print("\(vol)")
        audioPlayer?.numberOfLoops = -1;
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
    }
}
