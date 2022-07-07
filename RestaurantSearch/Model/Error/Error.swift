//
//  Error.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/07.
//

import Foundation

enum RestaurantError: Error {
    case unexpectedServerError
    var errorTitle: String? {
        switch self {
        case .unexpectedServerError:
            return "予期せぬサーバーエラーが発生しました"
        }
    }
}
