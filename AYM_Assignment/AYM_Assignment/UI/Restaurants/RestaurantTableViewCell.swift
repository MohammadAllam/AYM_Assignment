//
//  RestaurantTableViewCell.swift
//  AYM_Assignment
//
//  Created by Mohammad Allam on 6/2/18.
//  Copyright © 2018 Allam. All rights reserved.
//

import UIKit
import Cosmos
import AlamofireImage

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var imageVIew_thumbnail: UIImageView!
    @IBOutlet weak var label_title: UILabel!
    @IBOutlet weak var label_rating: UILabel!
    @IBOutlet weak var view_rating: CosmosView!

    // MARK: Overrider
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        view_rating.settings.fillMode = .half
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        // Reset all cell controls value to make sure no data is mixed when cells are reused
        resetControls()
    }

    // MARK: Private
    private func resetControls(){

        label_title.text = ""
        label_rating.text = ""
        view_rating.rating = 0
        imageVIew_thumbnail.image = Image(named: "DefaultThumbnail")
    }

    // MARK: Public
    func configureCell(with cellViewModel:RestaurantCellViewModel){

        // Configuring the title
        label_title.text = cellViewModel.title
        // Configuring the rating text
        label_rating.text = cellViewModel.reviewAvgString
        // Configuring the starts rating view
        view_rating.rating = cellViewModel.reviewAvg
        // Configuring the thumbnail
        if let thumbnailURLString = cellViewModel.thumbnailURLString{
            imageVIew_thumbnail.af_setImage(withURL: URL(string:thumbnailURLString)!,
                                            placeholderImage:Image(named: "DefaultThumbnail"))
        }else {
            imageVIew_thumbnail.image = Image(named: "DefaultThumbnail")
        }
    }
}
