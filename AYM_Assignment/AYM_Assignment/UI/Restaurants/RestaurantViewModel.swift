//
//  RestaurantViewModel.swift
//  AYM_Assignment
//
//  Created by Mohammad Allam on 6/2/18.
//  Copyright © 2018 Allam. All rights reserved.
//

import Foundation

import RxSwift

protocol RestaurantViewModelInput{
    /// Force refreshing the list according to the new location
    func refresh()
}

protocol RestaurantViewModelOutput{
    /// Emits an array of products for the tableview
    var restaurants: Observable<[Restaurant]>! { get }

    /// Emits an error string once an exception happens
    var errorString: Observable<String>! { get }
}

protocol RestaurantViewModelType {
    var inputs: RestaurantViewModelInput { get }
    var outputs: RestaurantViewModelOutput { get }
}

class RestaurantViewModel: RestaurantViewModelType,
    RestaurantViewModelInput,
RestaurantViewModelOutput{

    // MARK: Inputs & Outputs
    var inputs: RestaurantViewModelInput { return self }
    var outputs: RestaurantViewModelOutput { return self }

    // MARK: Input
    func refresh() {
        refreshFlag = true
        locationMan.requestLocation()
    }

    // MARK: Output
    var restaurants: Observable<[Restaurant]>!{
        return self.restaurantsProperty.asObservable()
    }
    var errorString: Observable<String>!{
        return self.errorStringProperty.asObservable()
    }

    // MARK: Private
    private let service: RestaurantServiceType
    private let locationMan: LocationManagerType
    private var refreshFlag = true
    private let restaurantsProperty = Variable<[Restaurant]>([])
    private let errorStringProperty = Variable<String>("")

    // MARK: Init
    init(inputService: RestaurantServiceType = RestaurantService(),
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
                    self.service.nearByRestaurants(longitude: longValue,
                                                   latitude: latValue)
                        .subscribe(onNext: { [unowned self] requestResult in

                            switch requestResult{
                            case let .success(results):
                                self.restaurantsProperty.value = results
                            case let .error( error ):
                                switch error{
                                case .InvalidRequest:
                                    self.errorStringProperty.value = "Invalid request parameters...!"
                                case .OverQueryLimit:
                                    self.errorStringProperty.value = "Max limit of queries has been reached...!"
                                case .RequestDenied:
                                    self.errorStringProperty.value = "Request has been denied...!"
                                case .ServerSideError:
                                    self.errorStringProperty.value = "Server side error...!"
                                case let .error(withMessage: errorMessage):
                                    self.errorStringProperty.value = "Received error: \(errorMessage)"
                                }
                            }
                        }).disposed(by: disposeBag)
                }
            }).disposed(by: disposeBag)

        locationMan.errorString
            .subscribe(onNext: { errorMessage in
                self.errorStringProperty.value = "Location tracking error...!"
            }).disposed(by: disposeBag)
    }
}
