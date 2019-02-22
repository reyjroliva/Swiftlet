//
//  Stopwatch.swift
//  Swiftlet
//
//  Created by Rey Oliva on 2/21/19.
//  Copyright © 2019 Rey Oliva. All rights reserved.
//

import Foundation

class Stopwatch
{
    private var startTime : NSDate?;
    private var pauseTime : NSDate?;
    
    var elapsedTime: TimeInterval {
        if let startTime = self.startTime {
            return -startTime.timeIntervalSinceNow;
        }
        else {
            return 0;
        }
    }
    
    var isRunning: Bool {
        return startTime != nil;
    }
    
    func start()
    {
        if(pauseTime == nil)
        {
            startTime = NSDate();
        }
        else
        {
            startTime = pauseTime;
        }
    }
    
    func stop()
    {
        startTime = nil;
    }
    
    func pause()
    {
        pauseTime = startTime;
        startTime = nil;
    }
}
