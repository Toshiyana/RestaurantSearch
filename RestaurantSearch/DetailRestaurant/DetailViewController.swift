//
//  DetailViewController.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/13.
//

import UIKit
import Kingfisher

final class DetailViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!

    @IBOutlet weak var tableViewHeightConstant: NSLayoutConstraint!

    var shop: Shop! // ListVCから値を受け取る
    private let infoName = ["住所", "交通アクセス", "ジャンル", "お店キャッチ",
                            "営業時間", "定休日", "飲み放題"]
    private var infoValue: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // print("DEBUG: shop:: \(shop)")

        infoValue = [shop.address, shop.mobileAccess!, shop.genre.name, shop.catch,
                     shop.open!, shop.close!, shop.freeDrink!]

        tableView.register(RestaurantInformationCell.nib(), forCellReuseIdentifier: RestaurantInformationCell.identifier)

        title = shop.name
        imageView.kf.setImage(with: shop.photo.mobile?.l ?? shop.photo.pc.l)
        nameLabel.text = shop.name
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newValue = change?[.newKey] {
                let newSize = newValue as! CGSize
                tableViewHeightConstant.constant = newSize.height
            }
        }
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantInformationCell.identifier, for: indexPath) as! RestaurantInformationCell

        cell.configure(infoName: infoName[indexPath.row],
                       infoValue: infoValue[indexPath.row])

        return cell
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
