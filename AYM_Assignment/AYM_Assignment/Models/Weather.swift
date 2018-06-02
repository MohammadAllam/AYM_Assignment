//
//  Weather.swift
//  AYM_Assignment
//
//  Created by Mohammad Allam on 6/2/18.
//  Copyright © 2018 Allam. All rights reserved.
//

import Foundation

struct Weather: Codable {

    struct WeatherState: Codable{
        let main:String?
        let description:String?
        let icon:String?

        enum CodingKeys: String, CodingKey {
            case main
            case description
            case icon
        }
    }

    struct Temprature: Codable {
        let temp:Float?
        let humidity:Int?
        let tempMin:Float?
        let tempMax:Float?

        enum CodingKeys: String, CodingKey {
            case temp
            case humidity
            case tempMin = "temp_min"
            case tempMax = "temp_max"
        }
    }

    struct Cloud: Codable {
        let percentage:Int?

        enum CodingKeys: String, CodingKey {
            case percentage = "all"
        }
    }

    struct Wind: Codable{
        let speed:Float?

        enum CodingKeys: String, CodingKey {
            case speed
        }
    }

    let name:String?
    let epochTime:Int
    let weatherState:[WeatherState]?
    let temp:Temprature?
    let wind:Wind?
    let clouds:Cloud?

    enum CodingKeys: String, CodingKey {
        case name
        case epochTime = "dt"
        case weatherState = "weather"
        case temp = "main"
        case wind
        case clouds
    }
}

