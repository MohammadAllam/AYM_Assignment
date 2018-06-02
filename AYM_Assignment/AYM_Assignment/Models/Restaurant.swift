//
//  Restaurant.swift
//  AYM_Assignment
//
//  Created by Mohammad Allam on 6/2/18.
//  Copyright © 2018 Allam. All rights reserved.
//

import Foundation

struct RestaurantResponse: Codable {
    let results:[Restaurant]?
    let status:String?

    enum CodingKeys: String, CodingKey {
        case results
        case status
    }
}

struct Restaurant: Codable {
    let id:String?
    let place_id:String?
    let name:String?
    let rating:Double?
    let vicinity:String?
    let types:[String]?
    let photos:[Photo]?

    enum CodingKeys: String, CodingKey {
        case id
        case place_id
        case name
        case rating
        case vicinity
        case types
        case photos
    }
}

