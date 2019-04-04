//
//  GPS.swift
//  Swiftlet
//
//  Created by Cale Cohee on 4/4/19.
//  Copyright © 2019 Rey Oliva. All rights reserved.
//

import Foundation
import CoreLocation

class GPS: NSObject, CLLocationManagerDelegate {
    let locationManager:CLLocationManager = CLLocationManager()
    private var locationList: [CLLocation] = []
    private var distance = Measurement(value: 0, unit: UnitLength.miles)
    
    
    func startGPS()
    {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 1
        locationManager.startUpdatingLocation()
    }
    
    func stopGPS()
    {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocation, didUpdateLocations locations: [CLLocation])
    {

        for currentLocation in locations
        {
            let howRecent = currentLocation.timestamp.timeIntervalSinceNow
//            guard currentLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let delta = currentLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.miles)
                print("\(distance)")
            }
            
            locationList.append(currentLocation)
        }
        
    }
    

}
