//
//  LocationManagerType.swift
//  AYM_Assignment
//
//  Created by Mohammad Allam on 6/2/18.
//  Copyright © 2018 Allam. All rights reserved.
//

import Foundation
import RxSwift

protocol LocationManagerType {
    // Emits a dictionary of the current location of the device
    var currentLocation: Observable<[String:String]> { get }

    /// Emits an error string once an exception happens
    var errorString: Observable<String>! { get }

    /// Start request device location
    func requestLocation()
}
