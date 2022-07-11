//
//  ViewController.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/05.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation
import PKHUD

final class ListViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var filteringButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!

    private lazy var viewModel = ListViewModel(
        searchBarText: searchBar.rx.text.asObservable(),
        searchButtonClicked: searchBar.rx.searchButtonClicked.asObservable(),
        itemSelected: tableView.rx.itemSelected.asObservable()
    )
    private let disposeBag = DisposeBag()

    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        //        setupLocationManager()
        bindViewModel()
    }

    private func setupUI() {
        tableView.register(RestaurantTableViewCell.nib(), forCellReuseIdentifier: RestaurantTableViewCell.identifier)
    }

    //    private func setupLocationManager() {
    //        locationManager.requestWhenInUseAuthorization()
    //
    //        if CLLocationManager.locationServicesEnabled() {
    //            locationManager.delegate = self
    //            locationManager.requestLocation()
    //        }
    //    }

    private func bindViewModel() {
        viewModel.deselectRow
            .bind(to: deselectRow)
            .disposed(by: disposeBag)

        viewModel.reloadData
            .bind(to: reloadData)
            .disposed(by: disposeBag)

        viewModel.onShowLoadingHud
            .map { [weak self] in self?.setLoadingHud(visible: $0) }
            .subscribe()
            .disposed(by: disposeBag)
    }

    private func setLoadingHud(visible: Bool) {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        visible ? PKHUD.sharedHUD.show(onView: view) : PKHUD.sharedHUD.hide()
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.shops.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.identifier, for: indexPath) as! RestaurantTableViewCell

        print("DEBUG: \(viewModel.shops)")

        let shop = viewModel.shops[indexPath.row]
        cell.configure(shop: shop)
        return cell
    }
}

// MARK: - Custom Binder
extension ListViewController {
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
}

// MARK: - CLLocationManagerDelegate
// extension ListViewController: CLLocationManagerDelegate {
//    // 位置情報の認可状態が変化した際に呼び出すメソッド
//    //    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//    //        switch locationManager.authorizationStatus {
//    //        case .authorizedWhenInUse:
//    //            locationManager.delegate = self
//    //            locationManager.requestLocation()
//    //        case .notDetermined:
//    //            locationManager.requestWhenInUseAuthorization()
//    //        default:
//    //            return
//    //        }
//    //    }
//
//    // 位置情報が変化した時に呼び出すメソッド
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let locValue = locations.last else { return }
//        // 位置情報が変わるたびにQueryのlat, lngを更新する
//        let lat = locValue.coordinate.latitude
//        let lng = locValue.coordinate.longitude
//
//        QueryShareManager.shared.addQuery(key: "lat", value: "\(lat)")
//        QueryShareManager.shared.addQuery(key: "lng", value: "\(lng)")
//
//        print("DEBUG: lat: \(lat), lng: \(lng)")
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        // TODO: エラーメッセージ画面に表示
//        print(error)
//    }
// }
