//
//  RestaurantServiceType.swift
//  AYM_Assignment
//
//  Created by Mohammad Allam on 6/2/18.
//  Copyright © 2018 Allam. All rights reserved.
//

import Foundation
import RxSwift

enum NearByRestaurantsResult {
    case success([Restaurant])
    case error(RestaurantError)
}

enum RestaurantError: Error {
    case OverQueryLimit
    case RequestDenied
    case InvalidRequest
    case ServerSideError
    case error(withMessage: String)
}

protocol RestaurantServiceType {
    func nearByRestaurants(longitude:String,latitude:String) -> Observable<NearByRestaurantsResult>
    func urlForPhoto(withReference reference:String) -> String
}
