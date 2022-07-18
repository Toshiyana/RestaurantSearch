//
//  ShopObject.swift
//  RestaurantSearch
//
//  Created by Toshiyana on 2022/07/18.
//

import Foundation
import RealmSwift

final class ShopObject: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var logoImageUrl: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var stationName: String = ""
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lng: Double = 0.0
    @objc dynamic var genre: String = ""
    @objc dynamic var `catch`: String = ""
    @objc dynamic var mobileAccess: String = ""
    @objc dynamic var urls: String = ""
    @objc dynamic var photo: String = ""
    @objc dynamic var open: String = ""
    @objc dynamic var close: String = ""
    @objc dynamic var freeDrink: String = ""
    @objc dynamic var nonSmoking: String = ""

    convenience init (shop: Shop) {
        self.init()
        id = shop.id
        name = shop.name
        if let logoImageUrl = shop.logoImageUrl {
            self.logoImageUrl = "\(logoImageUrl)"
        }
        address = shop.address
        stationName = shop.stationName ?? ""
        lat = shop.lat
        lng = shop.lng
        genre = shop.genre.name
        `catch` = shop.`catch`
        mobileAccess = shop.mobileAccess ?? ""
        urls = "\(shop.urls.pc)"
        if let photoUrl = shop.photo.mobile?.l {
            photo = "\(photoUrl)"
        }
        open = shop.open ?? ""
        close = shop.close ?? ""
        freeDrink = shop.freeDrink ?? ""
        nonSmoking = shop.nonSmoking ?? ""
    }

    override class func primaryKey() -> String? {
        return "id"
    }
}
