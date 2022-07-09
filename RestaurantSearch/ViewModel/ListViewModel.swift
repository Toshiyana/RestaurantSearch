//
//  ListViewModel.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/07.
//

import RxSwift
import RxCocoa
import PKHUD

protocol ListViewModelInputs {
    func didSearch(query: String)
}

protocol ListViewModelOutputs {
    //    var hud: Driver<HUDContentType> { get }
    var shops: Driver<[Shop]> { get }
}

protocol ListViewModelType {
    var inputs: ListViewModelInputs { get }
    var outputs: ListViewModelOutputs { get }
}

final class ListViewModel: ListViewModelInputs, ListViewModelOutputs {
    init() {
        shops = didSearchSubject.asObservable()
            .filter { $0.count > 2 }
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { text -> Observable<HotPepperResponse> in
                let shared = QueryShareManager.shared
                shared.addQuery(key: "keyword", value: text)
                return try Repository.search(keyValue: QueryShareManager.shared.getQuery())
            }
            .map { response -> [Shop] in
                return response.results.shop
            }
            .asDriver(onErrorJustReturn: [])
    }

    // MARK: - ListViewModelInputs
    private let didSearchSubject = PublishSubject<String>()
    func didSearch(query: String) {
        didSearchSubject.onNext(query)
    }

    // MARK: - ListViewModelOutputs
    //    var hud: Driver<HUDContentType>
    var shops: Driver<[Shop]>
}

extension ListViewModel: ListViewModelType {
    var inputs: ListViewModelInputs { return self }
    var outputs: ListViewModelOutputs { return self }
}
