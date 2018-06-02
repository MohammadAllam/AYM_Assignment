//
//  LocationManager.swift
//  AYM_Assignment
//
//  Created by Mohammad Allam on 6/2/18.
//  Copyright © 2018 Allam. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

class LocationManager: NSObject,LocationManagerType{

    // MARK: Public
    static let sharedInstance = LocationManager()

    // MARK: Observers
    var currentLocation: Observable<[String:String]>{
        return currentLocationProperty.asObservable()
    }
    var errorString: Observable<String>!{
        return self.errorStringProperty.asObservable()
    }

    // MARK: Private
    private let locationManager = CLLocationManager()
    private let currentLocationProperty = Variable<[String:String]>([:])
    private let errorStringProperty = Variable<String>("")

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func requestLocation(){
        locationManager.requestLocation()
    }
}

extension LocationManager:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lat = locations.last?.coordinate.latitude, let long = locations.last?.coordinate.longitude {
            print("\(lat),\(long)")
            currentLocationProperty.value = [LocationManagerConstants.KEY_LONITUDE:"\(long)",
                LocationManagerConstants.KEY_LATITUDE:"\(lat)"]
        } else {
            print("No coordinates")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorStringProperty.value = error.localizedDescription
    }
}

