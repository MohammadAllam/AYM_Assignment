//
//  RestaurantService.swift
//  AYM_Assignment
//
//  Created by Mohammad Allam on 6/2/18.
//  Copyright © 2018 Allam. All rights reserved.
//

import Foundation
import Moya
import RxSwift

struct RestaurantService: RestaurantServiceType {

    private var googleAPI: MoyaProvider<GooglePlacesAPI>

    init(googleAPI: MoyaProvider<GooglePlacesAPI> = MoyaProvider<GooglePlacesAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])) {
        self.googleAPI = googleAPI
    }

    func nearByRestaurants(longitude: String, latitude: String) -> Observable<NearByRestaurantsResult> {
        return googleAPI.rx
            .request(.nearByRestaurants(longitude: longitude, latitude: latitude))
            .map(RestaurantResponse.self)
            .asObservable()
            .map({ restaurantRsp -> NearByRestaurantsResult in

                guard let status = restaurantRsp.status else{
                    return NearByRestaurantsResult.error(.error(withMessage: "Response JSON error"))
                }
                switch status{
                case "OK":
                    guard let results = restaurantRsp.results else{
                        return NearByRestaurantsResult.success([])
                    }
                    return NearByRestaurantsResult.success(results)
                case "OVER_QUERY_LIMIT":
                    return NearByRestaurantsResult.error(.OverQueryLimit)
                case "REQUEST_DENIED":
                    return NearByRestaurantsResult.error(.RequestDenied)
                case "INVALID_REQUEST":
                    return NearByRestaurantsResult.error(.InvalidRequest)
                case "UNKNOWN_ERROR":
                    return NearByRestaurantsResult.error(.ServerSideError)
                default:
                    return NearByRestaurantsResult.success([])
                }
            })
    }

    func urlForPhoto(withReference reference:String) -> String {
        return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photoreference=\(reference)&key=\(GooglePlacesAPIConstants.API_KEY)"
    }

}
