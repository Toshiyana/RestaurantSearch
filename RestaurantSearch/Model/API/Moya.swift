//
//  API.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/05.
//

import Moya

enum RestaurantAPI {
    case search(keyValue: [String: Any])
}

extension RestaurantAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://webservice.recruit.co.jp/")!
    }

    var path: String {
        switch self {
        case .search:
            return "hotpepper/gourmet/v1/"
        }
    }

    var method: Method {
        switch self {
        case .search:
            return .get
        }
    }

    var parameters: [String: Any] {
        var parameter = [
            "key": APIKey.hotpepperApiKey,
            "format": "json",
            "count": 10
        ] as [String: Any]

        switch self {
        case .search(let keyValue):
            keyValue.forEach({key, value in
                parameter[key] = value
            })
            return parameter
        }
    }

    var parameterEncoding: ParameterEncoding {
        switch self {
        case .search:
            return Moya.URLEncoding.queryString
        }
    }

    var task: Task {
        switch self {
        case .search:
            print("DEBUG: parameters:: \(parameters)")
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
