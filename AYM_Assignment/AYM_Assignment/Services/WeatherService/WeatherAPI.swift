//
//  WeatherAPI.swift
//  AYM_Assignment
//
//  Created by Mohammad Allam on 6/2/18.
//  Copyright © 2018 Allam. All rights reserved.
//

import Foundation
import Moya

enum WeatherAPI {

    /// Get restaurants near the specified location
    case todaysWeather(
        longitude:String,
        latitude:String)

    case fiveDaysForcast(
        longitude:String,
        latitude:String)
}

extension WeatherAPI: TargetType  {
    var baseURL: URL {
        guard let url = URL(string: WeatherAPIConstants.BASE_URL) else {
            fatalError("FAILED: \(WeatherAPIConstants.BASE_URL)")
        }
        return url
    }

    var path: String {
        switch self {
        case .todaysWeather:
            return "/weather"
        case .fiveDaysForcast:
            return "/forecast"
        }
    }

    var method: Moya.Method {
        switch self {
        case .todaysWeather,
             .fiveDaysForcast:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .todaysWeather(longitude, latitude),
             let .fiveDaysForcast(longitude, latitude):

            var params: [String: Any] = [:]
            params["lat"] = "\(latitude)"
            params["lon"] = "\(longitude)"
            params["units"] = "metric"
            params["appid"] = WeatherAPIConstants.API_KEY

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
            WeatherAPIConstants.HEADER_ACCEPT_KEY: WeatherAPIConstants.HEADER_ACCEPT_VALUE
        ]
    }
}


