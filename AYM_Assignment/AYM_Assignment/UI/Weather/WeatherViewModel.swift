//
//  WeatherViewModel.swift
//  AYM_Assignment
//
//  Created by Mohammad Allam on 6/2/18.
//  Copyright © 2018 Allam. All rights reserved.
//

import RxSwift

protocol WeatherViewModelInput{
    /// Force refreshing the list according to the new location
    func refresh()
}

protocol WeatherViewModelOutput{
    /// Emits a string of city name
    var cityName: Observable<String>! { get }

    /// Emits a string of day name
    var dayName: Observable<String>! { get }

    /// Emits a string of weather description
    var weather: Observable<String>! { get }

    /// Emits a string of weather temprature
    var temprature: Observable<String>! { get }

    /// Emits a string of weather icon URL
    var tempratureIconURLString: Observable<String>! { get }

    /// Emits a string of precipitation
    var precipitation: Observable<String>! { get }

    /// Emits a string of humidity
    var humidity: Observable<String>! { get }

    /// Emits a string of wind
    var wind: Observable<String>! { get }

    /// Emits an weather forcasts
    var daysForcast: Observable<[Weather]>! { get }
}

protocol WeatherViewModelType {
    var outputs: WeatherViewModelOutput { get }
}

class WeatherViewModel: WeatherViewModelType,
WeatherViewModelOutput{

    // MARK: Inputs & Outputs
    var outputs: WeatherViewModelOutput { return self }

    // MARK: Input
    func refresh() {
        refreshFlag = true
    }

    // MARK: Output
    var cityName: Observable<String>!{
        return cityNameProperty.asObservable()
    }
    var dayName: Observable<String>!{
        return dayNameProperty.asObservable()
    }
    var weather: Observable<String>!{
        return weatherProperty.asObservable()
    }
    var temprature: Observable<String>!{
        return tempratureProperty.asObservable()
    }
    var tempratureIconURLString: Observable<String>!{
        return tempratureIconURLStringProperty.asObservable()
    }
    var precipitation: Observable<String>!{
        return precipitationProperty.asObservable()
    }
    var humidity: Observable<String>!{
        return humidityProperty.asObservable()
    }
    var wind: Observable<String>!{
        return windProperty.asObservable()
    }
    var daysForcast: Observable<[Weather]>!

    // MARKL Private
    private let cityNameProperty = Variable<String>("")
    private let dayNameProperty = Variable<String>("")
    private let weatherProperty = Variable<String>("")
    private let tempratureProperty = Variable<String>("")
    private let tempratureIconURLStringProperty = Variable<String>("")
    private let precipitationProperty = Variable<String>("")
    private let humidityProperty = Variable<String>("")
    private let windProperty = Variable<String>("")
    private let daysForcastProperty = Variable<String>("")

    // MARK: Private
    private var refreshFlag = true
    private let service: WeatherServiceType
    private let locationMan: LocationManagerType

    // MARK: Init
    init(inputService: WeatherServiceType = WeatherService(),
         inputLocManager: LocationManagerType = LocationManager.sharedInstance,
         disposeBag:DisposeBag) {

        self.service = inputService
        self.locationMan = inputLocManager

        locationMan.currentLocation
            .subscribe(onNext: { [unowned self] currentLocationDic in
                if self.refreshFlag{
                    self.refreshFlag = false
                    guard let longValue = currentLocationDic[LocationManagerConstants.KEY_LONITUDE] else{
                        return
                    }
                    guard let latValue = currentLocationDic[LocationManagerConstants.KEY_LATITUDE] else{
                        return
                    }
                    self.service.todaysWeather(longitude: longValue,
                                               latitude: latValue)
                        .subscribe(onNext: { weatherObj in

                            self.cityNameProperty.value = weatherObj.name ?? ""
                            self.weatherProperty.value = weatherObj.weatherState?.first?.description ?? ""
                            self.tempratureProperty.value = String(format: "%.0f", weatherObj.temp?.temp ?? 0)
                            self.tempratureIconURLStringProperty.value = self.service.urlForIcon(withCode: weatherObj.weatherState?.first?.icon ?? "")
                            self.precipitationProperty.value = "\(weatherObj.clouds?.percentage ?? 0)"
                            self.humidityProperty.value = "\(weatherObj.temp?.humidity ?? 0)"
                            self.windProperty.value = "\(weatherObj.wind?.speed ?? 0)"
                        }).disposed(by: disposeBag)

                    self.daysForcast = self.service.fiveDaysForcast(longitude: longValue,
                                                                    latitude: latValue)
                }
            }).disposed(by: disposeBag)
    }
}
