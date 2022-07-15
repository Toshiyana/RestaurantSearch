//
//  SearchFilterViewModel.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/14.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchFilterViewModel {
    private let disposeBag = DisposeBag()

    let rangeSelected = PublishSubject<Int>()
    let activeRange = PublishSubject<Int>()
    let getFilterSetting = PublishSubject<Void>()

    init() {
        // Range: 1-300m ~ 5-3000m
        rangeSelected
            .subscribe { [weak self] rangeNumber in
                guard let strongSelf = self, let rangeNumber = rangeNumber.element else { return }
                strongSelf.activeRange.onNext(rangeNumber)
                QueryShareManager.shared.addQuery(key: "range", value: "\(rangeNumber)")
            }
            .disposed(by: disposeBag)

        getFilterSetting
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                let queries = QueryShareManager.shared.getQuery()
                print("DEBUG: queries:: \(queries)")
                if let range = queries["range"] {
                    strongSelf.activeRange.onNext(Int(range as! String)!)
                }
            }
            .disposed(by: disposeBag)
    }
}
