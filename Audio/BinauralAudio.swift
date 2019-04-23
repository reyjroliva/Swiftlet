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
    var targetPace = Double(0.00)
    
    func checkPace(pace: Double)
    {
        let difference = pace - targetPace
        
        // Ahead desired pace
        if(difference >= 0.75)
        {
            playSound(index: 0.75)
        }
        else if(difference >= 0.5)
        {
            playSound(index: 0.5)
        }
        else if(difference >= 0.25)
        {
            playSound(index: 0.25)
        }

        // Behind desired pace
        else if(difference <= -0.75)
        {
            playSound(index: -0.75)
        }
        else if(difference <= -0.5)
        {
            playSound(index: -0.5)
        }
        else if(difference <= -0.25)
        {
            playSound(index: -0.25)
        }
        
        // Keeping target pace
        else
        {
            playSound(index: 0)
        }
    }
    
    func stopSound()
    {
        if(audioPlayer?.isPlaying ?? false)
        {
            audioPlayer?.stop()
        }
    }
    
    func playSound(index: Double)
    {
        var fileURL: String?
        
        if(index < 0)
        {
            fileURL = Bundle.main.path(forResource: "Back", ofType: "wav")
        }
        else if(index > 0)
        {
            fileURL = Bundle.main.path(forResource: "Front", ofType: "wav")
        }
        else
        {
            fileURL = Bundle.main.path(forResource: "Bell", ofType: "mp3")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL!))
        } catch let error {
            print("Can't play the audio file. Failed with an error \(error)")
        }
        
        switch(abs(index))
        {
        case 0.75:
            audioPlayer?.volume = 0.25
        case 0.5:
            audioPlayer?.volume = 0.5
        case 0.25:
            audioPlayer?.volume = 0.75
        default:
            audioPlayer?.volume = 1
        }
        
        audioPlayer?.numberOfLoops = 0;
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
    }
}
