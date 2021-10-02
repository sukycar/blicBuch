//
//  blitzBuchUserDefaults.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 6.12.20..
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit

enum UserDefaultsValue: String {
    case membershipType = "membershipType" //MARK:- can be "vip", "regular" and "free"
    case numberOfRegularBooks = "numberOfRegularBooks"
    case numberOfVipBooks = "numberOfVipBooks"
    case logedIn = "logedIn"
    case id = "id"
    case username = "username"
    case cartItems = "cartItems"
}


class BlitzBuchUserDefaults {
    
    // MARK: - Vars & Lets
    
    private var userDefaults: UserDefaults
    private lazy var encoder = JSONEncoder()
    private lazy var decoder = JSONDecoder()

    func get(_ type: UserDefaultsValue) -> Any? {
        return userDefaults.value(forKey: type.rawValue)
    }
    
    func set(_ type: UserDefaultsValue, value: Any?) -> Any? {
        userDefaults.setValue(value, forKey: type.rawValue)
        return value
    }
    
    func delete(_ type: UserDefaultsValue) {
        userDefaults.removeObject(forKey: type.rawValue)
    }
    
    func saveUser(_ user: UserCodable) {
        try? encodeAndSaveObject(user, forKey: Constants.user)
    }
    
    func getUser() -> UserCodable? {
        return decodeObject(forKey: Constants.user)
    }
    
    func removeUser() {
        removeObjects(keys: [Constants.user])
    }
    
    func save(_ object: Any, forKey key: String) {
        userDefaults.set(object, forKey: key)
        userDefaults.synchronize()
    }
    
    func getObject(key: String) -> Any? {
        return userDefaults.object(forKey: key)
    }
    
    func removeObjects(keys: [String]) {
        for key in keys {
            userDefaults.removeObject(forKey: key)
        }
        userDefaults.synchronize()
    }
    
    // MARK: - Private methods
    
    private func encodeAndSaveObject<T: Encodable>(_ object: T, forKey key: String) throws {
        let encoded = try encoder.encode(object)
        save(encoded, forKey: key)
    }
    
    private func decodeObject<T: Decodable>(forKey key: String) -> T? {
        do {
            if let encoded = getObject(key: key) as? Data {
                let decoded = try decoder.decode(T.self, from: encoded)
                return decoded
            } else {
                return nil
            }
        } catch {
            debugPrint("FAILURE: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Initialization
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}
