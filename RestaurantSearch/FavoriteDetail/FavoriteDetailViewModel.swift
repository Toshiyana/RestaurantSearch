//
//  FavoriteDetailViewModel.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/19.
//

import Foundation
import RxSwift
import RxCocoa

final class FavoriteDetailViewModel {
    private let disposeBag = DisposeBag()

    // MARK: - Input
    let removeFavorite = PublishSubject<String>()
    let getFavoriteCondition = PublishSubject<String>()

    // MARK: - Output
    let activeFavorite = PublishSubject<Bool>()

    init() {
        removeFavorite
            .subscribe { id in
                guard let id = id.element else { return }
                RealmManager.deleteOneObject(type: ShopObject.self, id: id)
            }
            .disposed(by: disposeBag)

        getFavoriteCondition
            .subscribe { [weak self] id in
                guard let strongSelf = self, let id = id.element else { return }
                let shopObjects = RealmManager.getEntityList(type: ShopObject.self)
                for i in 0..<shopObjects.count {
                    if shopObjects[i].id == id {
                        strongSelf.activeFavorite.onNext(true)
                        return
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
