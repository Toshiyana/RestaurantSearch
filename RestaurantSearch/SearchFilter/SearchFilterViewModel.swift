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

    // MARK: - Input
    let getFilterSetting = PublishSubject<Void>()
    let rangeSelected = PublishSubject<Int>()
    let japaneseSakeSelected = PublishSubject<Int>()
    let cocktailSelected = PublishSubject<Int>()
    let shochuSelected = PublishSubject<Int>()
    let wineSelected = PublishSubject<Int>()
    let freeDrinkSelected = PublishSubject<Int>()

    // MARK: - Output
    let activeRange = PublishSubject<Int>()
    let activeJapaneseSake = PublishSubject<Bool>()
    let activeCocktail = PublishSubject<Bool>()
    let activeShochu = PublishSubject<Bool>()
    let activeWine = PublishSubject<Bool>()
    let activeFreeDrink = PublishSubject<Bool>()

    init() {
        getFilterSetting
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                let queries = QueryShareManager.shared.getQuery()
                print("DEBUG: queries:: \(queries)")

                if let range = queries["range"] {
                    strongSelf.activeRange.onNext(Int(range as! String)!)
                }
                if let _ = queries["sake"] {
                    strongSelf.activeJapaneseSake.onNext(true)
                }
                if let _ = queries["cocktail"] {
                    strongSelf.activeCocktail.onNext(true)
                }
                if let _ = queries["shochu"] {
                    strongSelf.activeShochu.onNext(true)
                }
                if let _ = queries["wine"] {
                    strongSelf.activeWine.onNext(true)
                }
                if let _ = queries["free_drink"] {
                    strongSelf.activeFreeDrink.onNext(true)
                }
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

        japaneseSakeSelected
            .subscribe { filterEvent in
                QueryShareManager.shared.addQuery(key: "sake", filterEvent: filterEvent)
            }
            .disposed(by: disposeBag)

        cocktailSelected
            .subscribe { filterEvent in
                QueryShareManager.shared.addQuery(key: "cocktail", filterEvent: filterEvent)
            }
            .disposed(by: disposeBag)

        shochuSelected
            .subscribe { filterEvent in
                QueryShareManager.shared.addQuery(key: "shochu", filterEvent: filterEvent)
            }
            .disposed(by: disposeBag)

        wineSelected
            .subscribe { filterEvent in
                QueryShareManager.shared.addQuery(key: "wine", filterEvent: filterEvent)
            }
            .disposed(by: disposeBag)

        freeDrinkSelected
            .subscribe { filterEvent in
                QueryShareManager.shared.addQuery(key: "free_drink", filterEvent: filterEvent)
            }
            .disposed(by: disposeBag)
    }
}
