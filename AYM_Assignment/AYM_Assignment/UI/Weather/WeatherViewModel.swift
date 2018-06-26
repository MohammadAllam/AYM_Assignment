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
    /// Emits a weather obj for all the displayed fields
    var generalWeather: Observable<DisplayedWeatherDataModel>! { get }

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
    var generalWeather: Observable<DisplayedWeatherDataModel>!{
        return generalWeatherProperty.asObservable()
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
    private let generalWeatherProperty = BehaviorSubject<DisplayedWeatherDataModel>(value: DisplayedWeatherDataModel())
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
                            let dayNamePropertyValue = formatter.string(from: date)
                            //Setting weather description field
                            let weatherPropertyValue = weatherObj.weatherState?.first?.description ?? ""
                            //Setting temprature field
                            let tempraturePropertyValue = String(format: "%.0f", weatherObj.temp?.temp ?? 0)
                            //Setting temprature icon
                            let tempratureIconURLStringPropertyValue = self.service.urlForIcon(withCode: weatherObj.weatherState?.first?.icon ?? "")

                            self.generalWeatherProperty.onNext(DisplayedWeatherDataModel(dayName: dayNamePropertyValue,
                                                                                         cityName: weatherObj.name ?? "",
                                                                                         weatherDescription: weatherPropertyValue,
                                                                                         temp: tempraturePropertyValue,
                                                                                         tempIcon: tempratureIconURLStringPropertyValue,
                                                                                         precipitation: "\(weatherObj.clouds?.percentage ?? 0)",
                                humidity: "\(weatherObj.temp?.humidity ?? 0)",
                                wind: "\(weatherObj.wind?.speed ?? 0)"))
                        }).disposed(by: disposeBag)

                    self.daysForcast = self.service.fiveDaysForcast(longitude: longValue,
                                                                    latitude: latValue)
                }
            }).disposed(by: disposeBag)
    }
}

struct DisplayedWeatherDataModel{
    var dayName:String
    var cityName:String
    var weatherDescription:String
    var temp:String
    var tempIcon:String
    var precipitation:String
    var humidity:String
    var wind:String

    init(dayName:String = "",
         cityName:String = "",
         weatherDescription:String = "",
         temp:String = "",
         tempIcon:String = "",
         precipitation:String = "",
         humidity:String = "",
         wind:String = "") {

        self.dayName = dayName
        self.cityName = cityName
        self.weatherDescription = weatherDescription
        self.temp = temp
        self.tempIcon = tempIcon
        self.precipitation = precipitation
        self.humidity = humidity
        self.wind = wind
    }
}

struct WeatherCellViewModel{
    let dayName:String?
    let iconURLString:String?
    let tempMax:String
    let tempMin:String
}

