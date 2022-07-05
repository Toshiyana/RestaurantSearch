//
//  ViewController.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/05.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var filteringButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(RestaurantTableViewCell.nib(), forCellReuseIdentifier: RestaurantTableViewCell.identifier)
    }
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RestaurantTableViewCell.identifier,
            for: indexPath
        ) as? RestaurantTableViewCell else {
            return UITableViewCell()
        }

        return cell
    }
}
