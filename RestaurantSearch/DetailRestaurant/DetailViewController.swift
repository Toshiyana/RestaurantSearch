//
//  DetailViewController.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/13.
//

import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!

    var shop: Shop?

    override func viewDidLoad() {
        super.viewDidLoad()

        print("DEBUG: shop:: \(shop)")
    }
}
