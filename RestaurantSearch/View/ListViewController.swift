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
    private lazy var viewModel = ListViewModel(
        searchBarText: searchBar.rx.text.asObservable(),
        searchButtonClicked: searchBar.rx.searchButtonClicked.asObservable(),
        itemSelected: tableView.rx.itemSelected.asObservable()
    )
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var filteringButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!

    private lazy var viewSpinner: UIView = {
        let view = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: view.frame.size.width,
                                        height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(RestaurantTableViewCell.nib(), forCellReuseIdentifier: RestaurantTableViewCell.identifier)
        //        setupLocationManager()
        bindViewModel()
    }

    //    private func setupLocationManager() {
    //        locationManager.requestWhenInUseAuthorization()
    //
    //        guard CLLocationManager.locationServicesEnabled() else { return }
    //        locationManager.delegate = self
    //        locationManager.requestLocation()
    //
    //        //        guard let location = locationManager.location?.coordinate else { return }
    //        //        QueryShareManager.shared.addQuery(key: "lat", value: "\(location.latitude)")
    //        //        QueryShareManager.shared.addQuery(key: "lng", value: "\(location.longitude)")
    //        //        print("DEBUG: lat: \(location.latitude), lng: \(location.longitude)")
    //
    //        //            locationManager.desiredAccuracy = kCLLocationAccuracyBest
    //        //            locationManager.startUpdatingLocation()
    //
    //    }

    private func bindViewModel() {
        viewModel.deselectRow
            .bind(to: deselectRow)
            .disposed(by: disposeBag)

        viewModel.reloadData
            .bind(to: reloadData)
            .disposed(by: disposeBag)

        viewModel.onShowLoadingHud
            .map { [weak self] in self?.setupLoadingHud(visible: $0) }
            .subscribe()
            .disposed(by: disposeBag)

        viewModel.shops
            .bind(to: tableView.rx.items) { tableView, _, shop in
                let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.identifier) as! RestaurantTableViewCell
                cell.configure(shop: shop)
                return cell
            }
            .disposed(by: disposeBag)

        viewModel.isLoadingSpinnerAvailable
            .subscribe { [weak self] isAvailable in
                guard let isAvailable = isAvailable.element,
                      let strongSelf = self else { return }
                strongSelf.tableView.tableFooterView = isAvailable ? strongSelf.viewSpinner : UIView(frame: .zero)
            }
            .disposed(by: disposeBag)

        tableView.rx.didScroll
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                let offSetY = strongSelf.tableView.contentOffset.y
                let contentHeight = strongSelf.tableView.contentSize.height

                if offSetY > (contentHeight - strongSelf.tableView.frame.size.height - 100) {
                    strongSelf.viewModel.fetchMoreDatas.onNext(())
                }
            }
            .disposed(by: disposeBag)
    }

    private func setupLoadingHud(visible: Bool) {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        visible ? PKHUD.sharedHUD.show(onView: view) : PKHUD.sharedHUD.hide()
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
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        switch locationManager.authorizationStatus {
//        case .authorizedWhenInUse:
//            locationManager.delegate = self
//            locationManager.requestLocation()
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        default:
//            return
//        }
//    }
//
//    // 位置情報が変化した時に呼び出すメソッド
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let locValue = locations.last else { return }
//        locationManager.stopUpdatingLocation()
//
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
