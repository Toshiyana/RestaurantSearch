//
//  Repository.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/06.
//

// import Foundation
import Moya
import RxSwift

final class Repository {
    private static let apiProvider = MoyaProvider<RestaurantAPI>()
}

extension Repository {
    static func search(keyValue: [String: Any]) throws -> Observable<HotPepperResponse> {
        return apiProvider.rx.request(.search(keyValue: keyValue))
            .map { response in
                try APIResponseStatusCodeHandler.handleStatusCode(response)
                return try JSONDecoder()
                    .decode(HotPepperResponse.self, from: response.data)
            }.asObservable()
    }
}
