//
//  WeatherViewController.swift
//  AYM_Assignment
//
//  Created by Mohammad Allam on 6/2/18.
//  Copyright © 2018 Allam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AlamofireImage

class WeatherViewController: UIViewController {

    // MARK: ViewModel
    private var viewModel:WeatherViewModel?

    // MARK: IBOutlets

    // MARK: Private
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewModel()
        configureUI()
    }

    // MARK: Binding
    func configureViewModel() {
        viewModel = WeatherViewModel(disposeBag: disposeBag)
    }

    // MARK: UI
    func configureUI(){
        // Start loading items
        viewModel?.refresh()
    }

}
