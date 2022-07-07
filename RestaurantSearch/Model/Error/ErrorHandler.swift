//
//  ErrorHandler.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/07.
//

import Moya
import RxSwift

final class APIResponseStatusCodeHandler {
    // ステータスコードハンドリング共通メソッド
    static func handleStatusCode(_ response: PrimitiveSequence<SingleTrait, Response>.Element) throws {
        print("handleStatusCode: \(response.statusCode)")
        switch response.statusCode {
        case 200...399:
            break
        default:
            throw RestaurantError.unexpectedServerError
        }
    }
}
