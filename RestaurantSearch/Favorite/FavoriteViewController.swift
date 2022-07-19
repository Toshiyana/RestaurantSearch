//
//  FavoriteViewController.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/16.
//

import UIKit
import RxSwift
import RxCocoa

final class FavoriteViewController: UIViewController {
    private lazy var viewModel = FavoriteViewModel(
        itemSelected: tableView.rx.itemSelected.asObservable()
    )
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(RestaurantTableViewCell.nib(), forCellReuseIdentifier: RestaurantTableViewCell.identifier)
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateFavorite.onNext(Void())
    }

    private func bindViewModel() {
        viewModel.deselectRow
            .bind(to: deselectRow)
            .disposed(by: disposeBag)

        viewModel.reloadData
            .bind(to: reloadData)
            .disposed(by: disposeBag)

        viewModel.transitionToShopObjectDetail
            .bind(to: transitionToShopObjectDetail)
            .disposed(by: disposeBag)

        viewModel.shops
            .bind(to: tableView.rx.items) { tableView, _, shopObject in
                let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.identifier) as! RestaurantTableViewCell
                cell.configure(name: shopObject.name, access: shopObject.mobileAccess, logoImageUrl: shopObject.logoImageUrl)
                return cell
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Custom Binder
extension FavoriteViewController {
    private var deselectRow: Binder<IndexPath> {
        return Binder(self) { vc, indexPath in
            vc.tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    private var reloadData: Binder<Void> {
        return Binder(self) { vc, _ in
            vc.tableView.reloadData()
        }
    }

    private var transitionToShopObjectDetail: Binder<ShopObject> {
        return Binder(self) { vc, shopObject in
            let detailVC = UIStoryboard(name: "FavoriteDetailViewController", bundle: nil).instantiateInitialViewController() as! FavoriteDetailViewController
            detailVC.shopObject = shopObject
            vc.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
