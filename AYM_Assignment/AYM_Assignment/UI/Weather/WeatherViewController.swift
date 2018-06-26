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
    @IBOutlet weak var label_cityName: UILabel!
    @IBOutlet weak var label_dayName: UILabel!
    @IBOutlet weak var label_weatherDesc: UILabel!
    @IBOutlet weak var label_temp: UILabel!
    @IBOutlet weak var label_precipitation: UILabel!
    @IBOutlet weak var label_humidity: UILabel!
    @IBOutlet weak var label_wind: UILabel!
    @IBOutlet weak var imageView_weather: UIImageView!

    @IBOutlet weak var collectionView_forcast: UICollectionView!
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

        let outputs = viewModel?.outputs

        outputs?.generalWeather
            .map({ $0.cityName })
            .bind(to: label_cityName.rx.text)
            .disposed(by: disposeBag)

        outputs?.generalWeather
            .map({ $0.dayName })
            .bind(to: label_dayName.rx.text)
            .disposed(by: disposeBag)

        outputs?.generalWeather
            .map({ $0.weatherDescription })
            .bind(to: label_weatherDesc.rx.text)
            .disposed(by: disposeBag)

        outputs?.generalWeather
            .map({ $0.temp })
            .bind(to: label_temp.rx.text)
            .disposed(by: disposeBag)

        outputs?.generalWeather
            .map({ $0.tempIcon })
            .subscribe(onNext: { [unowned self] iconURLString in
                guard let iconURL = URL(string:iconURLString) else{
                    return
                }
                self.imageView_weather.af_setImage(withURL: iconURL)
            })
            .disposed(by: disposeBag)

        outputs?.generalWeather
            .map({ $0.precipitation })
            .bind(to: label_precipitation.rx.text)
            .disposed(by: disposeBag)

        outputs?.generalWeather
            .map({ $0.humidity })
            .bind(to: label_humidity.rx.text)
            .disposed(by: disposeBag)

        outputs?.generalWeather
            .map({ $0.wind })
            .bind(to: label_wind.rx.text)
            .disposed(by: disposeBag)

        outputs?.daysForcast
            .debug("Binding collectionView")
            .bind(to: collectionView_forcast.rx.items(cellIdentifier: "WeatherCell")){
                [unowned self](index, weatherObj: Weather, cell:WeatherCollectionViewCell) in
                cell.configureCell(with: self.viewModel!.createCellViewModel(for: weatherObj))
            }
            .disposed(by: disposeBag)

    }

    // MARK: UI
    func configureUI(){
        // Start loading items
        viewModel?.refresh()
    }
}

