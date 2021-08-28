//
//  FirebaseError.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 28.8.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import FirebaseAuth

extension AuthErrorCode {
    func returnLocalizedString() -> String? {
        switch self {
        case .wrongPassword:
            return "Wrong password. Try again.".localized()
        case .invalidEmail:
            return "Wrong email. Try again.".localized()
        case .userNotFound:
            return "User with given email doesn't exist.\nPlease try again.".localized()
        case .userDisabled:
            return "User is temporarily disabled.\nPlease try again later or contact app owner.".localized()
        case .emailAlreadyInUse:
            return "Please use different email.\nThis email is already in use.".localized()
        case .invalidUserToken:
            return "Token expired. Please sign in again.".localized()
        default:
            return "Something went wrong. Please try again.".localized()
        }
    }
}
