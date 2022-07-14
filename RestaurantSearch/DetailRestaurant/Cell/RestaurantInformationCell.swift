//
//  RestaurantInformationCell.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/13.
//

import UIKit

final class RestaurantInformationCell: UITableViewCell {
    static let identifier = "RestaurantInformationCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    @IBOutlet private weak var infoNameLabel: UILabel!
    @IBOutlet private weak var infoValueLabel: UILabel!

    func configure(infoName: String, infoValue: String) {
        infoNameLabel.text = infoName
        infoValueLabel.text = infoValue
    }
}
