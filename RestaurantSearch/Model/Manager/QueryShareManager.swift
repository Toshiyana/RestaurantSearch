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
    
    func resetQuery() {
        QueryShareManager.shared.queries = [:]
        
        if let location = CLLocationManager().location?.coordinate {
            QueryShareManager.shared.addQuery(key: "lat", value: "\(location.latitude)")
            QueryShareManager.shared.addQuery(key: "lng", value: "\(location.longitude)")
        }
        print("DEBUG: query by resetQuery(), \(queries)")
    }
    
    func addQuery(key: String, int: Event<Int>) {
        if let int = int.element, int == 0 {
            QueryShareManager.shared.addQuery(key: key, value: nil)
            return
        }
        QueryShareManager.shared.addQuery(key: key, value: "\(int.element ?? 0)")
    }
}
