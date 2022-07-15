//
//  SearchFilterViewController.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/14.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchFilterViewController: UIViewController {
    private lazy var viewModel = SearchFilterViewModel()
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var closeBarButton: UIBarButtonItem!
    @IBOutlet private weak var decideBarButton: UIBarButtonItem!

    @IBOutlet private weak var rangeFirstButton: UIButton! // ~300m
    @IBOutlet private weak var rangeSecondButton: UIButton! // ~500m
    @IBOutlet private weak var rangeThirdButton: UIButton! // ~1000m
    @IBOutlet private weak var rangeFourthButton: UIButton! // ~2000m
    @IBOutlet private weak var rangeFifthButton: UIButton! // ~3000m

    @IBOutlet private weak var japaneseSakeButton: UIButton!
    @IBOutlet private weak var cocktailButton: UIButton!
    @IBOutlet private weak var shochuButton: UIButton!
    @IBOutlet private weak var wineButton: UIButton!
    @IBOutlet private weak var freeDrinkButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        rangeFirstButton.layer.cornerRadius = rangeFirstButton.frame.height / 2
        rangeSecondButton.layer.cornerRadius = rangeSecondButton.frame.height / 2
        rangeThirdButton.layer.cornerRadius = rangeThirdButton.frame.height / 2
        rangeFourthButton.layer.cornerRadius = rangeFourthButton.frame.height / 2
        rangeFifthButton.layer.cornerRadius = rangeFifthButton.frame.height / 2

        japaneseSakeButton.layer.cornerRadius = japaneseSakeButton.frame.height / 2
        cocktailButton.layer.cornerRadius = cocktailButton.frame.height / 2
        shochuButton.layer.cornerRadius = shochuButton.frame.height / 2
        wineButton.layer.cornerRadius = wineButton.frame.height / 2
        freeDrinkButton.layer.cornerRadius = freeDrinkButton.frame.height / 2
    }

    private func bindViewModel() {
        closeBarButton.rx.tap
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        // MARK: - Range
        // 1 - ~300m
        rangeFirstButton.rx.tap
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.rangeSelected.onNext(1)
            }
            .disposed(by: disposeBag)
        // 2 - ~500m
        rangeSecondButton.rx.tap
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.rangeSelected.onNext(2)
            }
            .disposed(by: disposeBag)
        // 3 - ~1000m
        rangeThirdButton.rx.tap
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.rangeSelected.onNext(3)
            }
            .disposed(by: disposeBag)
        // 4 - ~2000m
        rangeFourthButton.rx.tap
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.rangeSelected.onNext(4)
            }
            .disposed(by: disposeBag)
        // 5 - ~3000m
        rangeFifthButton.rx.tap
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.rangeSelected.onNext(5)
            }
            .disposed(by: disposeBag)

        viewModel.activeRange
            .subscribe { [weak self] rangeNumber in
                guard let strongSelf = self else { return }
                let buttons = [strongSelf.rangeFirstButton,
                               strongSelf.rangeSecondButton,
                               strongSelf.rangeThirdButton,
                               strongSelf.rangeFourthButton,
                               strongSelf.rangeFifthButton]
                for i in 0...(buttons.count - 1) {
                    if i + 1 == rangeNumber.element! {
                        strongSelf.activeRange(button: buttons[i]!, active: true)
                    } else {
                        strongSelf.activeRange(button: buttons[i]!, active: false)
                    }
                }
            }
            .disposed(by: disposeBag)

        viewModel.getFilterSetting.onNext(Void())
    }

    private func activeRange(button: UIButton, active: Bool) {
        if active {
            button.backgroundColor = .systemIndigo
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .systemGray5
            button.setTitleColor(.black, for: .normal)
        }
    }
}
