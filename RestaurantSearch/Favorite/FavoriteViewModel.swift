//
//  FavoriteViewModel.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/19.
//

import Foundation
import RxSwift
import RxCocoa

final class FavoriteViewModel {
    private let disposeBag = DisposeBag()

    // MARK: - Input
    let deselectRow: Observable<IndexPath>
    let reloadData: Observable<Void>
    let transitionToShopObjectDetail: Observable<ShopObject>

    // MARK: - Output
    var shops: Observable<[ShopObject]> { return _shops.asObservable() }
    //    var shops: [ShopObject] { return _shops.value }
    private let _shops = BehaviorRelay<[ShopObject]>(value: [])
    let updateFavorite = PublishSubject<Void>()

    init(itemSelected: Observable<IndexPath>) {
        deselectRow = itemSelected.map { $0 }

        reloadData = _shops.map { _ in }

        transitionToShopObjectDetail = itemSelected
            .withLatestFrom(_shops) { ($0, $1) }
            .flatMap { indexPath, shops -> Observable<ShopObject> in
                guard indexPath.row < shops.count else { return .empty() }
                return .just(shops[indexPath.row])
            }

        updateFavorite
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                let objects = RealmManager.getEntityList(type: ShopObject.self)
                var objArray: [ShopObject] = []
                for obj in objects {
                    objArray.append(obj)
                }
                strongSelf._shops.accept(objArray)
            }
            .disposed(by: disposeBag)
    }
}
