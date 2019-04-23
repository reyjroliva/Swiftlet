//
//  ViewController.swift
//  Swiftlet
//
//  Created by Rey Oliva on 2/14/19.
//  Copyright © 2019 Rey Oliva. All rights reserved.
//

import UIKit
import HealthKit
import CoreLocation

let swiftletGreen = UIColor(red: 0.35, green: 0.8, blue: 0.1, alpha: 1.0)
let swiftletRed = UIColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 1.0)
let swiftletBlue = UIColor(red: 0.1, green: 0.5, blue: 1.0, alpha: 1.0)
let btnBuffer: CGFloat = 10
let lblBuffer: CGFloat = 30


class ViewController: UIViewController, SettingsViewContollerDelegate {
    
    let watch = Stopwatch()
    let audio = BinauralAudio()
    
    @IBOutlet weak var startPauseBtn: UIButton!
    @IBOutlet weak var endBtn: UIButton!
    @IBOutlet weak var currPaceLbl: UILabel!
    @IBOutlet weak var desPaceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var currPace: UILabel!
    @IBOutlet weak var desPace: UILabel!
    @IBOutlet weak var elapsedTime: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var settingBtn: UIButton!
    
    
    var started = false
    
    var minutes = Int(0)
    var seconds = Int(0)
    var tensOfSeconds = Int(0)
    var minHolder = Int(0)
    var secHolder = Int(0)
    var tensOfSecHolder = Int(0)
    
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.distanceFilter = 5
        return _locationManager
    }()
    
    var dist = Measurement(value: 0, unit: UnitLength.meters)
    var instantPace = 0.0
    lazy var locationList = [CLLocation]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 5
        locationManager.requestAlwaysAuthorization()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set startPauseBtn
        startPauseBtn.setTitle("Start", for: .normal)
        startPauseBtn.setTitleColor(UIColor .white, for: .normal)
        startPauseBtn.backgroundColor = swiftletGreen
        startPauseBtn.frame = CGRect(x: self.view.frame.width * 0.05, y: self.view.frame.height * 0.7, width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.1)
        startPauseBtn.layer.cornerRadius = 10
        
        //Set endBtn
        endBtn.setTitle("End", for: .normal)
        endBtn.setTitleColor(UIColor .white, for: .normal)
        endBtn.backgroundColor = swiftletRed
        endBtn.frame = CGRect(x: startPauseBtn.frame.minX, y: startPauseBtn.frame.maxY + btnBuffer, width: startPauseBtn.frame.width, height: startPauseBtn.frame.height)
        endBtn.layer.cornerRadius = 10
        
        //Set Labels
        timeLbl.text = "Time"
        timeLbl.frame = CGRect(x: startPauseBtn.frame.minX, y: startPauseBtn.frame.minY - (startPauseBtn.frame.height + lblBuffer), width: startPauseBtn.frame.width * 0.5, height: self.view.frame.height * 0.1)
        
        elapsedTime.text = "00:00.00"
        elapsedTime.textColor = UIColor .white
        elapsedTime.frame = CGRect(x: timeLbl.frame.minX + 5, y: timeLbl.frame.minY - timeLbl.frame.height, width: timeLbl.frame.width - 10, height: timeLbl.frame.height)
        elapsedTime.layer.masksToBounds = true
        elapsedTime.layer.cornerRadius = 20
        elapsedTime.backgroundColor = swiftletBlue
        
        distanceLbl.text = "Distance(mi.)"
        distanceLbl.frame = CGRect(x: timeLbl.frame.maxX, y: timeLbl.frame.minY, width: timeLbl.frame.width, height: timeLbl.frame.height)
        
        distance.text = "0.00"
        distance.textColor = UIColor .white
        distance.frame = CGRect(x: distanceLbl.frame.minX + 5, y: distanceLbl.frame.minY - distanceLbl.frame.height, width: distanceLbl.frame.width - 10, height: distanceLbl.frame.height)
        distance.layer.masksToBounds = true
        distance.layer.cornerRadius = 20
        distance.backgroundColor = swiftletBlue
        
        currPaceLbl.text = "Current\nPace (min/mi)"
        currPaceLbl.frame = CGRect(x: startPauseBtn.frame.minX, y: self.view.frame.height * 0.15, width: elapsedTime.frame.width, height: self.view.frame.height * 0.1)
        
        currPace.text = "0.00"
        currPace.textColor = UIColor .white
        currPace.frame = CGRect(x: distance.frame.minX, y: currPaceLbl.frame.minY, width: distance.frame.width, height: distance.frame.height)
        currPace.layer.masksToBounds = true
        currPace.layer.cornerRadius = 20
        currPace.backgroundColor = swiftletBlue
        
        desPaceLbl.text = "Desired\nPace"
        desPaceLbl.frame = CGRect(x: currPaceLbl.frame.minX, y: ((currPaceLbl.frame.maxY + elapsedTime.frame.minY) / 2) - (currPaceLbl.frame.height / 2), width: currPaceLbl.frame.width, height: currPaceLbl.frame.height)
        
        desPace.text = "00:00.00"
        desPace.textColor = UIColor .white
        desPace.frame = CGRect(x: currPace.frame.minX, y: desPaceLbl.frame.minY, width: currPace.frame.width, height: currPace.frame.height)
        desPace.layer.masksToBounds = true
        desPace.layer.cornerRadius = 20
        desPace.backgroundColor = UIColor .gray
        
        //Set settingsBtn
        settingBtn.setTitleColor(swiftletBlue, for: .normal)
        settingBtn.frame = CGRect(x: currPace.frame.maxX - settingBtn.frame.width, y: settingBtn.frame.height, width: settingBtn.frame.width, height: settingBtn.frame.height)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func startPauseBtnPressed(_ sender: Any) {
        if(!started) {
            started = true
            startPauseBtn.setTitle("Pause", for: .normal)
            startPauseBtn.backgroundColor = swiftletRed
            startPauseBtn.frame = CGRect(x: self.view.frame.width * 0.05, y: self.view.frame.height * 0.7, width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.2)
            endBtn.isHidden = true
            
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateElapsedTime(timer:)), userInfo: nil, repeats: true)
            
            watch.start()
            locationManager.startUpdatingLocation()
        }
        else {
            started = false
            startPauseBtn.setTitle("Start", for: .normal)
            startPauseBtn.backgroundColor = swiftletGreen
            startPauseBtn.frame = CGRect(x: self.view.frame.width * 0.05, y: self.view.frame.height * 0.7, width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.1)
            endBtn.isHidden = false
            
            watch.pause()
            audio.stopSound()
            minHolder = minutes
            secHolder = seconds
            tensOfSecHolder = tensOfSeconds
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    @IBAction func endBtnPressed(_ sender: Any) {
        watch.stop()
        elapsedTime.text = "00:00.0"
        currPace.text = "0.00"
        distance.text = "0.00"
        minHolder = 0
        secHolder = 0
        tensOfSecHolder = 0
        
        locationManager.stopUpdatingLocation()
        locationList.removeAll(keepingCapacity: false)
        dist = Measurement(value: 0, unit: UnitLength.meters)
        instantPace = 0.0
    }

    @IBAction func onSettinBtn(_ sender: Any) {
        performSegue(withIdentifier: "moveToSettings", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "moveToSettings"){
            let settingsVC = segue.destination as! SettingsViewController
            settingsVC.delegate = self
        }
    }
    
    @objc func updateElapsedTime(timer : Timer)
    {
        if watch.isRunning
        {
            minutes = Int(watch.elapsedTime/60) + minHolder
            seconds = Int(watch.elapsedTime.truncatingRemainder(dividingBy: 60)) + secHolder
            tensOfSeconds = Int((watch.elapsedTime * 10).truncatingRemainder(dividingBy: 10)) + tensOfSecHolder
            if(tensOfSeconds >= 10)
            {
                tensOfSeconds = tensOfSeconds - 10
                seconds = seconds + 1
            }
            if(seconds >= 60)
            {
                seconds = seconds - 60
                minutes = minutes + 1
            }
            elapsedTime.text = String (format: "%02d:%02d.%d", minutes, seconds, tensOfSeconds)
            
            let formattedDistance = FormatDisplay.distance(dist)
            let distanceIndex = formattedDistance.firstIndex(of: " ") ?? formattedDistance.endIndex
            let distanceMagnitude  = formattedDistance[..<distanceIndex]
            distance.text = String (format: "%.2f", (distanceMagnitude as NSString).doubleValue)

            if(seconds % 3 == 0 && tensOfSeconds == 0)
            {
                let totalSeconds = (60 * minutes) + seconds
                let formattedPace = FormatDisplay.pace(distance: dist, seconds: totalSeconds, outputUnit: UnitSpeed.minutesPerMile)
                let paceIndex = formattedPace.firstIndex(of: " ") ?? formattedPace.endIndex
                let paceMagnitude = formattedPace[..<paceIndex]
            
                currPace.text = String (format: "%.2f", (paceMagnitude as NSString).doubleValue)
                
                audio.checkPace(pace: (paceMagnitude as NSString).doubleValue)
            }
        }
        else
        {
            timer.invalidate()
        }
    }

    func updateDesPace() {
        desPace.text = String (format: "%02d:%02d", minutesPerMile, secondsPerMile)
        audio.targetPace = Double(minutesPerMile) + (Double(secondsPerMile)/60)
    }
}


extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                dist = dist + Measurement(value: delta, unit: UnitLength.meters)
            }
            locationList.append(newLocation)
        }
    }
}

