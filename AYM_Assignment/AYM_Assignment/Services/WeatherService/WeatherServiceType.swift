//
//  WeatherServiceType.swift
//  AYM_Assignment
//
//  Created by Mohammad Allam on 6/2/18.
//  Copyright © 2018 Allam. All rights reserved.
//

import Foundation
import RxSwift

enum TodayWeatherResult {
    case success(Weather)
    case error(WeatherError)
}

enum WeatherError: Error {
    case ServerSideError
    case error(withMessage: String)
}

protocol WeatherServiceType {
    func todaysWeather(longitude:String,latitude:String) -> Observable<Weather>
    func fiveDaysForcast(longitude:String,latitude:String) -> Observable<[Weather]>
    func urlForIcon(withCode code:String) -> String
}



