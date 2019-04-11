//
//  ViewController.swift
//  Swiftlet
//
//  Created by Rey Oliva on 2/14/19.
//  Copyright © 2019 Rey Oliva. All rights reserved.
//

import UIKit
import CoreLocation

let swiftletGreen = UIColor(red: 0.35, green: 0.8, blue: 0.1, alpha: 1.0)
let swiftletRed = UIColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 1.0)
let swiftletBlue = UIColor(red: 0.1, green: 0.5, blue: 1.0, alpha: 1.0)
let btnBuffer: CGFloat = 10
let lblBuffer: CGFloat = 30


class ViewController: UIViewController, SettingsViewContollerDelegate {
    
    let watch = Stopwatch()
    
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
    
    private let locationManager = LocationManager.shared
    private var dist = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    
    
    var started = false
    
    var minutes = Int(0)
    var seconds = Int(0)
    var tensOfSeconds = Int(0)
    var minHolder = Int(0)
    var secHolder = Int(0)
    var tensOfSecHolder = Int(0)
    
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
        
        currPaceLbl.text = "Current\nPace"
        currPaceLbl.frame = CGRect(x: startPauseBtn.frame.minX, y: self.view.frame.height * 0.15, width: elapsedTime.frame.width, height: self.view.frame.height * 0.1)
        
        currPace.text = "0.0000 m/s"
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
            
            locationManager.delegate = self
            // locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
        else {
            started = false
            startPauseBtn.setTitle("Start", for: .normal)
            startPauseBtn.backgroundColor = swiftletGreen
            startPauseBtn.frame = CGRect(x: self.view.frame.width * 0.05, y: self.view.frame.height * 0.7, width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.1)
            endBtn.isHidden = false
            
            watch.pause()
            minHolder = minutes
            secHolder = seconds
            tensOfSecHolder = tensOfSeconds
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    @IBAction func endBtnPressed(_ sender: Any) {
        watch.stop()
        elapsedTime.text = "00:00.0"
        minHolder = 0
        secHolder = 0
        tensOfSecHolder = 0
        
        locationManager.stopUpdatingLocation()
        locationList.removeAll()
        dist = Measurement(value: 0, unit: UnitLength.meters)
        currPace.text = "0.0000 m/s"
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
            elapsedTime.text = String (format: "%02d:%02d.%d", minutes, seconds, tensOfSeconds)
        }
        else
        {
            timer.invalidate()
        }
    }
    
    func updateDesPace() {
        desPace.text = String (format: "%02d:%02d", minutesPerMile, secondsPerMile)
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 1 else { continue }

            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                dist = dist + Measurement(value: delta, unit: UnitLength.meters)
                
                let speedMagnitude = seconds != 0 ? dist.value / Double(seconds) : 0
                let speed = Measurement(value: speedMagnitude, unit: UnitSpeed.metersPerSecond)
                
                let truncSpeed = Double(floor(10000*speed.value)/10000)
                print("\(truncSpeed)")
                
                currPace.text = String(format: "%.4f m/s", truncSpeed)
            }

            locationList.append(newLocation)
        }
    }
}

