//
//  UserLocation.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 08/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import Foundation
import CoreLocation

///Class that manages userLocation in the app. Calls location request banner when app is lauched.
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
        if status == .authorizedWhenInUse {}
    }
    
    func getUserLocation() -> CLLocation? {
        return locationManager?.location
    }
}
