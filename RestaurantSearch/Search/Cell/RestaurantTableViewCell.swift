//
//  RestaurantTableViewCell.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/05.
//

import UIKit
import Kingfisher

final class RestaurantTableViewCell: UITableViewCell {
    static let identifier = "RestaurantTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    @IBOutlet private weak var restaurantNameLabel: UILabel!
    @IBOutlet private weak var accessLabel: UILabel!
    @IBOutlet private weak var restaurantImageView: UIImageView!
    @IBOutlet private weak var favoriteImageView: UIImageView!

    func configure(name: String, access: String, logoImageUrl: String) {
        restaurantNameLabel.text = name
        accessLabel.text = access
        restaurantImageView.kf.setImage(with: URL(string: logoImageUrl))
    }
}
