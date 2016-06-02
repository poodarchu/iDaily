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
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters           //设置位移通知最小间隔
        locationManager.pausesLocationUpdatesAutomatically = true                       //当用户不再移动时自动暂停
        locationManager.headingFilter = kCLHeadingFilterNone                            //用户朝向变化的最小角度间隔
        locationManager.requestWhenInUseAuthorization()                                 //请求用户授权当app在使用时可以获取位置信息
        
        print("location right.")
        
        //查看用户是否已经授权， 如果授权，则开始获取位置
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    //CLLocationManagerDelege的方法之一
    /**
     当用户位置更新的时候，本方法就会被调用
     
     - parameter manager:
     - parameter newLocation:
     - parameter oldLocation:
     */
    func locationManager(manager: CLLocationManager,
                         didUpdateToLocation newLocation: CLLocation,
                         fromLocation oldLocation: CLLocation)
    {
        geocoder.reverseGeocodeLocation(newLocation, completionHandler: { (placemarks, error) in
            if let error = error {
                print("reverse geodcode fail: \(error.localizedDescription)")
            }
            
            //placemarks包括位置的国家，省份和地区等信息
            if let pm = placemarks {
                if pm.count > 0 {
                    let placemark = pm.first
                    self.address = placemark?.locality //city
                    
                    //向System发送位置已经更新的通知
                    NSNotificationCenter.defaultCenter().postNotificationName("DiaryLocationUpdated", object: self.address)
                }
            }
        })
    }
}
