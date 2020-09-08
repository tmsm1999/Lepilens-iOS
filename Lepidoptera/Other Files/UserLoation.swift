//
//  UserLocation.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 08/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import Foundation
import CoreLocation

class UserLocation: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var coordinates: CLLocation?
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            //coordinates = locationManager?.location
        }
    }
    
    func getUserLocation() -> CLLocation? {
        return locationManager?.location
    }
}
