//
//  QueryManager.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/08.
//

import RxSwift
import CoreLocation

final class QueryShareManager {
    private var queries: [String: Any] = [:]
    static let shared = QueryShareManager()

    func addQuery(key: String, value: String?) {
        if value != nil {
            QueryShareManager.shared.queries[key] = value
        } else {
            QueryShareManager.shared.queries[key] = nil
        }
    }

    func getQuery() -> [String: Any] {
        return QueryShareManager.shared.queries
    }

    func addQuery(key: String, filterEvent: Event<Int>) {
        guard let filterValue = filterEvent.element else { return }
        if filterValue == 0 {
            QueryShareManager.shared.addQuery(key: key, value: nil)
            return
        } else {
            QueryShareManager.shared.addQuery(key: key, value: "\(filterValue)")
        }
    }
}
