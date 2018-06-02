//
//  RestaurantViewController.swift
//  AYM_Assignment
//
//  Created by Mohammad Allam on 6/2/18.
//  Copyright © 2018 Allam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RestaurantViewController: UIViewController {

    // MARK: ViewModel
    private var viewModel:RestaurantViewModel?

    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: Private
    private var disposeBag = DisposeBag()

    // MARK: Overrider
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewModel()
        configureUI()
    }

    // MARK: Binding
    func configureViewModel() {
        viewModel = RestaurantViewModel(disposeBag: disposeBag)

        let outputs = viewModel?.outputs

        outputs?.restaurants
            .debug("Binding tableview")
            .bind(to: tableView.rx.items(cellIdentifier: "RestaurantCell")) {
                [unowned self](index, restaurant: Restaurant, cell:RestaurantTableViewCell) in
                cell.configureCell(with: self.viewModel!.createCellViewModel(for: restaurant))
            }
            .disposed(by: disposeBag)

        outputs?.errorString
            .subscribe(onNext: { errorMessage in
                let alert = UIAlertController(title: "Ooops...",
                                              message: errorMessage,
                                              preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok",
                                              style: UIAlertActionStyle.default,
                                              handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }

    // MARK: UI
    func configureUI(){

        // Configuring dynamic table view cells height
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension

        // Start loading items
        viewModel?.refresh()
    }
}
