//
//  blitzBuchUserDefaults.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 6.12.20..
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit

enum UserDefaultsValue:String{
    case membershipType = "membershipType"//MARK:- can be "vip", "regular" and "free"
    case numberOfRegularBooks = "numberOfRegularBooks"
    case numberOfVipBooks = "numberOfVipBooks"
    case logedIn = "logedIn"
    case id = "id"
    case username = "username"
    case cartItems = "cartItems"
}


class blitzBuchUserDefaults {
    private static let userDefaults = UserDefaults()

    class func get(_ type: UserDefaultsValue) -> Any? {
        return userDefaults.value(forKey: type.rawValue)
    }
    
    class func set(_ type: UserDefaultsValue, value: Any?) -> Any? {
        userDefaults.setValue(value, forKey: type.rawValue)
        return value
    }
    
    class func delete(_ type: UserDefaultsValue) {
        userDefaults.removeObject(forKey: type.rawValue)
    }
}
