//
//  PDLocationHelper.swift
//  iDaily
//
//  Created by P. Chu on 6/1/16.
//  Copyright © 2016 Poodar. All rights reserved.
//

import CoreLocation

class PDLocationHelper: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var address: String?
    var geocoder = CLGeocoder()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.headingFilter = kCLHeadingFilterNone
        locationManager.requestWhenInUseAuthorization()
        
        print("location right.")
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager,
                         didUpdateToLocation newLocation: CLLocation,
                         fromLocation oldLocation: CLLocation)
    {
        geocoder.reverseGeocodeLocation(newLocation, completionHandler: { (placemarks, error) in
            if let error = error {
                print("reverse geodcode fail: \(error.localizedDescription)")
            }
            
            if let pm = placemarks {
                if pm.count > 0 {
                    let placemark = pm.first
                    self.address = placemark?.locality
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("DiaryLocationUpdated", object: self.address)
                }
            }
            
        })
    }
}
