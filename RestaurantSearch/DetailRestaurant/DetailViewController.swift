//
//  DetailViewController.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/13.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

final class DetailViewController: UIViewController {
    private let viewModel = DetailViewModel()
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var favoriteButton: UIButton!

    @IBOutlet private weak var tableViewHeightConstant: NSLayoutConstraint! // ScrollView内におけるTableViewのHeightを自動調整するための変数

    var shop: Shop! // ListVCから値を受け取る
    private let infoName = ["住所", "交通アクセス", "ジャンル", "お店キャッチ",
                            "営業時間", "定休日", "禁煙席", "飲み放題"]
    private var infoValue: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // print("DEBUG: shop:: \(shop)")

        infoValue = [shop.address, shop.mobileAccess!, shop.genre.name, shop.catch,
                     shop.open!, shop.close!, shop.nonSmoking!, shop.freeDrink!]

        setupUI()
        bindViewModel()
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

    private func setupUI() {
        tableView.register(RestaurantInformationCell.nib(), forCellReuseIdentifier: RestaurantInformationCell.identifier)

        title = shop.name
        imageView.kf.setImage(with: shop.photo.mobile?.l ?? shop.photo.pc.l)
        nameLabel.text = shop.name
    }

    private func bindViewModel() {
        favoriteButton.rx.tap
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }

                if strongSelf.favoriteButton.tag == 0 {
                    strongSelf.viewModel.addFavorite.onNext(strongSelf.shop)
                } else {
                    strongSelf.viewModel.removeFavorite.onNext(strongSelf.shop.id)
                }
                strongSelf.activeButton(button: strongSelf.favoriteButton)
            }
            .disposed(by: disposeBag)

        viewModel.activeFavorite
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.activeButton(button: strongSelf.favoriteButton)
            }
            .disposed(by: disposeBag)

        viewModel.getFavoriteCondition.onNext(shop.id)
    }

    private func activeButton(button: UIButton) {
        if button.tag == 0 {
            button.tag = 1
            button.backgroundColor = .systemOrange
            button.setTitle("お気に入りから削除", for: .normal)
            button.setTitleColor(.white, for: .normal)
        } else {
            button.tag = 0
            button.backgroundColor = .systemGray5
            button.setTitle("お気に入りに追加", for: .normal)
            button.setTitleColor(.black, for: .normal)
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
