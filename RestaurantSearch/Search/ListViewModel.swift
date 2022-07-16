//
//  ListViewModel.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/07.
//

import Foundation
import RxSwift
import RxCocoa
import PKHUD

final class ListViewModel {
    private let disposeBag = DisposeBag()

    // MARK: - Input
    let deselectRow: Observable<IndexPath>
    let reloadData: Observable<Void>
    let transitionToShopDetail: Observable<Shop>

    // MARK: - Output
    var shops: Observable<[Shop]> { return _shops.asObservable() }
    private let _shops = BehaviorRelay<[Shop]>(value: [])
    var isLoadingHudAvailable: Observable<Bool> {
        return _isLoadingHudAvailable
            .asObservable()
            .distinctUntilChanged()
    }
    private let _isLoadingHudAvailable = PublishSubject<Bool>()
    let fetchMoreData = PublishSubject<Void>()
    let isLoadingSpinnerAvailable = PublishSubject<Bool>()

    private var startIndex = 1
    private let numberOfRequestingData = 10
    private var isMoreData = true // ページネーションでデータがそれ以上存在しない時に、fetchMoreDataできないようにするためのフラグ

    init(searchBarText: Observable<String?>,
         searchButtonClicked: Observable<Void>,
         itemSelected: Observable<IndexPath>) {
        deselectRow = itemSelected.map { $0 }

        reloadData = _shops.map { _ in }

        transitionToShopDetail = itemSelected
            .withLatestFrom(_shops) { ($0, $1) }
            .flatMap { indexPath, shops -> Observable<Shop> in
                guard indexPath.row < shops.count else { return .empty() }
                return .just(shops[indexPath.row])
            }

        searchButtonClicked
            .withLatestFrom(searchBarText)
            .flatMapFirst { [weak self] text -> Observable<Event<HotPepperResponse>> in
                guard let strongSelf = self, let text = text else { return .empty() }
                strongSelf._isLoadingHudAvailable.onNext(true)
                let shared = QueryShareManager.shared
                shared.addQuery(key: "keyword", value: text)

                // startIndexを初期化
                strongSelf.startIndex = 1
                shared.addQuery(key: "start", value: "\(strongSelf.startIndex)")
                // isMoreDataを初期化
                strongSelf.isMoreData = true

                return try Repository.search(keyValue: shared.getQuery())
                    .materialize()
            }
            .subscribe { [weak self] event in
                guard let strongSelf = self else { return }
                // print("DEBUG: event:: \(event)")
                switch event.element! {
                case .next(let response):
                    print("DEBUG: search response count:: \(response.results.shop.count)")
                    // print("DEBUG: response:: \(response.results.shop)")
                    strongSelf._isLoadingHudAvailable.onNext(false)
                    strongSelf._shops.accept(response.results.shop)
                case .error(let error):
                    // TODO: アラートを表示
                    strongSelf._isLoadingHudAvailable.onNext(false)
                    print("DEBUG: \(error.localizedDescription)")
                case .completed:
                    break
                }
            }
            .disposed(by: disposeBag)

        fetchMoreData
            .flatMapFirst { [weak self] _ -> Observable<Event<HotPepperResponse>> in
                // queryにkeywordは保存されているから、searchBarTextの値はいらない。
                guard let strongSelf = self,
                      !strongSelf._shops.value.isEmpty,
                      strongSelf.isMoreData
                else { return .empty() }

                strongSelf.isLoadingSpinnerAvailable.onNext(true)

                let shared = QueryShareManager.shared

                strongSelf.startIndex += strongSelf.numberOfRequestingData
                shared.addQuery(key: "start", value: "\(strongSelf.startIndex)")

                return try Repository.search(keyValue: shared.getQuery())
                    .materialize()
            }
            .subscribe { [weak self] event in
                guard let strongSelf = self else { return }
                // print("DEBUG: event:: \(event)")
                switch event.element! {
                case .next(let response):
                    strongSelf.isLoadingSpinnerAvailable.onNext(false)
                    guard !response.results.shop.isEmpty else {
                        strongSelf.startIndex -= strongSelf.numberOfRequestingData
                        strongSelf.isMoreData = false
                        return
                    }
                    // print("DEBUG: response count:: \(response.results.shop.count)")
                    // print("DEBUG: response:: \(response.results.shop)")

                    let oldData = strongSelf._shops.value
                    strongSelf._shops.accept(oldData + response.results.shop)
                    print("DEBUG: all response count with pagination:: \(strongSelf._shops.value.count)")
                case .error(let error):
                    strongSelf.isLoadingSpinnerAvailable.onNext(false)
                    print("DEBUG: \(error.localizedDescription)")
                // TODO: アラートを表示
                case .completed:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
