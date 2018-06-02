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
    var daysForcast: Observable<[String]>! { get }
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
    var daysForcast: Observable<[String]>!

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

    // MARK: Init
    init(disposeBag:DisposeBag) {

    }
}
