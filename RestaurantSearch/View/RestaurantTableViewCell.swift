//
//  RestaurantTableViewCell.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/05.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    static let identifier = "RestaurantTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    @IBOutlet private weak var restaurantNameLabel: UILabel!
    @IBOutlet private weak var valueRangeLabel: UILabel!
    @IBOutlet private weak var accessLabel: UILabel!
    @IBOutlet private weak var restaurantImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
