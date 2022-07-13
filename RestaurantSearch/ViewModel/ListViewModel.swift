//
//  ListViewModel.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/07.
//

import RxSwift
import RxCocoa
import PKHUD
import Foundation

final class ListViewModel {
    private let disposeBag = DisposeBag()

    // MARK: - Output
    var shops: Observable<[Shop]> { return _shops.asObservable() }
    private let _shops = BehaviorRelay<[Shop]>(value: [])

    let deselectRow: Observable<IndexPath>
    let reloadData: Observable<Void>
    let transitionToShopDetail: Observable<Shop>

    var onShowLoadingHud: Observable<Bool> {
        return loadInProgress
            .asObservable()
            .distinctUntilChanged()
    }
    private let loadInProgress = PublishSubject<Bool>()

    let fetchMoreDatas = PublishSubject<Void>()
    let isLoadingSpinnerAvailable = PublishSubject<Bool>()
    private var pageCounter = 1

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
                strongSelf.loadInProgress.onNext(true)
                let shared = QueryShareManager.shared
                shared.addQuery(key: "keyword", value: text)
                return try Repository.search(keyValue: shared.getQuery())
                    .materialize()
            }
            .subscribe { [weak self] event in
                guard let strongSelf = self else { return }
                // print("DEBUG: event:: \(event)")
                switch event.element! {
                case .next(let response):
                    print("DEBUG: response count:: \(response.results.shop.count)")
                    // print("DEBUG: response:: \(response.results.shop)")
                    strongSelf.loadInProgress.onNext(false)
                    strongSelf._shops.accept(response.results.shop)
                case .error(let error):
                    // TODO: アラートを表示
                    strongSelf.loadInProgress.onNext(false)
                    print("DEBUG: \(error.localizedDescription)")
                case .completed:
                    break
                }
            }
            .disposed(by: disposeBag)

        fetchMoreDatas
            .flatMapFirst { [weak self] _ -> Observable<Event<HotPepperResponse>> in
                // queryにkeywordは保存されているから、searchBarTextの値はいらない。
                guard let strongSelf = self,
                      !strongSelf._shops.value.isEmpty
                else { return .empty() }

                strongSelf.isLoadingSpinnerAvailable.onNext(true)

                let shared = QueryShareManager.shared

                strongSelf.pageCounter += 10
                shared.addQuery(key: "start", value: "\(strongSelf.pageCounter)")

                return try Repository.search(keyValue: shared.getQuery())
                    .materialize()
            }
            .subscribe { [weak self] event in
                guard let strongSelf = self else { return }
                // print("DEBUG: event:: \(event)")
                switch event.element! {
                case .next(let response):
                    strongSelf.isLoadingSpinnerAvailable.onNext(false)
                    guard !response.results.shop.isEmpty else { return }
                    print("DEBUG: response count:: \(response.results.shop.count)")
                    // print("DEBUG: response:: \(response.results.shop)")

                    let oldData = strongSelf._shops.value
                    strongSelf._shops.accept(oldData + response.results.shop)
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
