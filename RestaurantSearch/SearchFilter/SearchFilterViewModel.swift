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

    init(
        rangeFirstButtonTapped: Observable<Void>,
        rangeSecondButtonTapped: Observable<Void>,
        rangeThirdButtonTapped: Observable<Void>,
        rangeFourthButtonTapped: Observable<Void>,
        rangeFifthButtonTapped: Observable<Void>
    ) {
        // MARK: - Range
        // 1 - ~300m
        rangeFirstButtonTapped
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.rangeSelected.onNext(1)
            }
            .disposed(by: disposeBag)
        // 2 - ~500m
        rangeSecondButtonTapped
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.rangeSelected.onNext(2)
            }
            .disposed(by: disposeBag)
        // 3 - ~1000m
        rangeThirdButtonTapped
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.rangeSelected.onNext(3)
            }
            .disposed(by: disposeBag)
        // 4 - ~2000m
        rangeFourthButtonTapped
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.rangeSelected.onNext(4)
            }
            .disposed(by: disposeBag)
        // 5 - ~3000m
        rangeFifthButtonTapped
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.rangeSelected.onNext(5)
            }
            .disposed(by: disposeBag)

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
