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
    private var refreshFlag = true
    private let restaurantsProperty = Variable<[Restaurant]>([])
    private let errorStringProperty = Variable<String>("")

    // MARK: Init
    init(inputService: RestaurantServiceType = RestaurantService(),
         disposeBag:DisposeBag) {

        self.service = inputService

        self.service.nearByRestaurants(longitude: "25.077598",
                                       latitude: "55.147028")
            .subscribe(onNext: { [unowned self] requestResult in

                switch requestResult{
                case let .success(results):
                    self.restaurantsProperty.value = results
                case let .error(error):
                    switch error{
                    case .OverQueryLimit:
                        self.errorStringProperty.value = "Maximum number of queries limit has been reached..!"
                    case .InvalidRequest:
                        self.errorStringProperty.value = "Invalid request parameters..!"
                    case .RequestDenied:
                        self.errorStringProperty.value = "Request has been denied..!"
                    case .ServerSideError:
                        self.errorStringProperty.value = "Server side error..!"
                    case let .error(withMessage: message):
                        self.errorStringProperty.value = "Received error:\(message)"
                    }
                    print("err.loca")
                }
            }).disposed(by: disposeBag)
    }
}
