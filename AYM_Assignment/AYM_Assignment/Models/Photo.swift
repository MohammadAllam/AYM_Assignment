//
//  Photo.swift
//  AYM_Assignment
//
//  Created by Mohammad Allam on 6/2/18.
//  Copyright © 2018 Allam. All rights reserved.
//

import Foundation

struct Photo: Codable {
    let photo_reference:String?
    let height:Int?
    let width:Int?

    enum CodingKeys: String, CodingKey {
        case photo_reference
        case height
        case width
    }
}

