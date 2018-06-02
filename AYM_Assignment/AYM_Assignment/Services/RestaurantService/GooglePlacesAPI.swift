//
//  GooglePlacesAPI.swift
//  AYM_Assignment
//
//  Created by Mohammad Allam on 6/2/18.
//  Copyright © 2018 Allam. All rights reserved.
//

import Foundation
import Moya

enum GooglePlacesAPI {

    /// Get restaurants near the specified location
    case nearByRestaurants(
        longitude:String,
        latitude:String)
}

extension GooglePlacesAPI: TargetType  {
    var baseURL: URL {
        guard let url = URL(string: GooglePlacesAPIConstants.BASE_URL) else {
            fatalError("FAILED: \(GooglePlacesAPIConstants.BASE_URL)")
        }
        return url
    }

    var path: String {
        switch self {
        case .nearByRestaurants:
            return "/nearbysearch/json"
        }
    }

    var method: Moya.Method {
        switch self {
        case .nearByRestaurants:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .nearByRestaurants(longitude, latitude):

            var params: [String: Any] = [:]
            params["location"] = "\(latitude),\(longitude)"
            params["radius"] = 50000
            params["type"] = "restaurant"
            params["rankby"] = "prominence"
            params["key"] = GooglePlacesAPIConstants.API_KEY

            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default)
        }
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String : String]? {
        return [
            GooglePlacesAPIConstants.HEADER_ACCEPT_KEY: GooglePlacesAPIConstants.HEADER_ACCEPT_VALUE
        ]
    }
}
