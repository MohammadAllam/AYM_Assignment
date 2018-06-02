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
        locationMan.requestLocation()
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

    func createCellViewModel(for weatherObj: Weather) -> WeatherCellViewModel {
        var iconURLString:String?
        if let icon = weatherObj.weatherState?.first?.icon{
            iconURLString = service.urlForIcon(withCode: icon)
        }

        //Setting day name field
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let date = Date(timeIntervalSince1970: TimeInterval(weatherObj.epochTime))

        return WeatherCellViewModel(dayName: formatter.string(from: date),
                                    iconURLString: iconURLString,
                                    tempMax: String(format: "%.0f", weatherObj.temp?.tempMax ?? 0),
                                    tempMin: String(format: "%.0f", weatherObj.temp?.tempMin ?? 0))
    }

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

                            //Setting day name field
                            let formatter = DateFormatter()
                            formatter.dateFormat = "EEEE"
                            let date = Date()
                            self.dayNameProperty.value = formatter.string(from: date)
                            //Setting city name field
                            self.cityNameProperty.value = weatherObj.name ?? ""
                            //Setting weather description field
                            self.weatherProperty.value = weatherObj.weatherState?.first?.description ?? ""
                            //Setting temprature field
                            self.tempratureProperty.value = String(format: "%.0f", weatherObj.temp?.temp ?? 0)
                            //Setting temprature icon
                            self.tempratureIconURLStringProperty.value = self.service.urlForIcon(withCode: weatherObj.weatherState?.first?.icon ?? "")
                            //Setting precipitation field
                            self.precipitationProperty.value = "\(weatherObj.clouds?.percentage ?? 0)"
                            //Setting humidity field
                            self.humidityProperty.value = "\(weatherObj.temp?.humidity ?? 0)"
                            //Setting wind field
                            self.windProperty.value = "\(weatherObj.wind?.speed ?? 0)"
                        }).disposed(by: disposeBag)

                    self.daysForcast = self.service.fiveDaysForcast(longitude: longValue,
                                                                    latitude: latValue)
                }
            }).disposed(by: disposeBag)
    }
}


struct WeatherCellViewModel{
    let dayName:String?
    let iconURLString:String?
    let tempMax:String
    let tempMin:String
}

