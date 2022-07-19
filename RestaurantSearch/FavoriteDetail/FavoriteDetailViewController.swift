//
//  FavoriteDetailViewController.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/19.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

final class FavoriteDetailViewController: UIViewController {
    private let viewModel = FavoriteDetailViewModel()
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var favoriteButton: UIButton!

    @IBOutlet private weak var tableViewHeightConstant: NSLayoutConstraint! // ScrollView内におけるTableViewのHeightを自動調整するための変数

    var shopObject: ShopObject!

    private let infoName = ["住所", "交通アクセス", "ジャンル", "お店キャッチ",
                            "営業時間", "定休日", "禁煙席", "飲み放題"]
    private var infoValue: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()

        //        print("DEBUG: shopObject:: \(shopObject)")

        infoValue = [shopObject.address, shopObject.mobileAccess, shopObject.genre, shopObject.`catch`,
                     shopObject.open, shopObject.close, shopObject.nonSmoking, shopObject.freeDrink]

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
        favoriteButton.layer.cornerRadius = 8
        tableView.register(RestaurantInformationCell.nib(), forCellReuseIdentifier: RestaurantInformationCell.identifier)

        title = shopObject.name
        imageView.kf.setImage(with: URL(string: shopObject.photo))
        nameLabel.text = shopObject.name
    }

    private func bindViewModel() {
        favoriteButton.rx.tap
            .subscribe { [weak self] _ in
                guard let strongSelf = self,
                      strongSelf.favoriteButton.tag == 1
                else { return }

                strongSelf.viewModel.removeFavorite.onNext(strongSelf.shopObject.id)
                strongSelf.activeButton(button: strongSelf.favoriteButton)
                strongSelf.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)

        viewModel.activeFavorite
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.activeButton(button: strongSelf.favoriteButton)
            }
            .disposed(by: disposeBag)

        viewModel.getFavoriteCondition.onNext(shopObject.id)
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

extension FavoriteDetailViewController: UITableViewDataSource {
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

extension FavoriteDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
