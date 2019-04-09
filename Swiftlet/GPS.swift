//
//  GPS.swift
//  Swiftlet
//
//  Created by Cale Cohee on 4/4/19.
//  Copyright © 2019 Rey Oliva. All rights reserved.
//

import CoreLocation

class GPS: NSObject, CLLocationManagerDelegate {
    private let locationManager = LocationManager.shared
    private var distance = Measurement(value: 0, unit: UnitLength.miles)
    private var locationList: [CLLocation] = []

    
    func start()
    {
        locationManager.delegate = self
        locationManager.distanceFilter = 1
        locationManager.startUpdatingLocation()
    }
    
    func stop()
    {
        locationManager.stopUpdatingLocation()
    }
    
    func getDistance()->Measurement<UnitLength>
    {
        return distance
    }
    
    private func locationManager(_ manager: CLLocation, didUpdateLocations locations: [CLLocation])
    {
        for currentLocation in locations
        {
//            let howRecent = currentLocation.timestamp.timeIntervalSinceNow
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
