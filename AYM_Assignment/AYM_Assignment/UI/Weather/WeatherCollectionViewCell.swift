//
//  WeatherCollectionViewCell.swift
//  AYM_Assignment
//
//  Created by Mohammad Allam on 6/2/18.
//  Copyright © 2018 Allam. All rights reserved.
//

import UIKit
import AlamofireImage

class WeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label_dayName: UILabel!
    @IBOutlet weak var imageView_icon: UIImageView!
    @IBOutlet weak var label_temp: UILabel!
    @IBOutlet weak var label_tempMin: UILabel!


    override func prepareForReuse() {
        super.prepareForReuse()

        resetControls()
    }

    func resetControls(){
        label_temp.text = ""
        label_dayName.text = ""
        imageView_icon.image = nil
    }

    func configureCell(with cellViewModel:WeatherCellViewModel){

        label_temp.text = cellViewModel.tempMax
        label_tempMin.text = cellViewModel.tempMin
        label_dayName.text = cellViewModel.dayName
        if let iconURL = URL(string: cellViewModel.iconURLString!){
            imageView_icon.af_setImage(withURL: iconURL)
        }
    }

}

