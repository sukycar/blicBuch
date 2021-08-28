//
//  KeychainServices.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 17.7.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import KeychainAccess

class KeychainServices {
    
    // MARK: - Vars & Lets
    
    private var keychain: Keychain
    
    // MARK: - Public methods
    
    func saveToken(token: String) {
        self.keychain[Constants.userDefaultsToken] = token
    }
    
    func getToken() -> String? {
        return self.keychain[Constants.userDefaultsToken]
    }
    
    func logout() {
        self.deleteTokens()
    }
    
    // MARK: - Private methods
    
    private func deleteTokens() {
        self.keychain[Constants.userDefaultsToken] = nil
    }
    
    // MARK: - Init
    
    init(keychain: Keychain) {
        self.keychain = keychain
    }
    
}
