//
//  WeatherService.swift
//  AYM_Assignment
//
//  Created by Mohammad Allam on 6/2/18.
//  Copyright © 2018 Allam. All rights reserved.
//

import Foundation
import Moya
import RxSwift

struct WeatherService: WeatherServiceType {

    private var weatherAPI: MoyaProvider<WeatherAPI>

    init(weatherAPI: MoyaProvider<WeatherAPI> = MoyaProvider<WeatherAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])) {
        self.weatherAPI = weatherAPI
    }

    func todaysWeather(longitude: String, latitude: String) -> Observable<Weather> {
        return weatherAPI.rx
            .request(.todaysWeather(longitude: longitude, latitude: latitude))
            .map(Weather.self)
            .asObservable()
    }

    func fiveDaysForcast(longitude:String,latitude:String) -> Observable<[Weather]>{
        return weatherAPI.rx
            .request(.fiveDaysForcast(longitude: longitude, latitude: latitude))
            .debug("fiveDaysForcast")
            .map([Weather].self , atKeyPath:"list")
            .asObservable()
            .catchError { error in
                return .just([])
        }
    }

    func urlForIcon(withCode code:String) -> String {
        return "http://openweathermap.org/img/w/\(code).png"
    }

}

