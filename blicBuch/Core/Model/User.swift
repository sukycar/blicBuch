//
//  User.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 2.10.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation

class UserCodable: Codable {
    var id: Int32?
    var address: String?
    var city: String?
    var email: String?
    var uid: String?
    var name: String?
    var password: String?
    var payment: Bool?
    var phoneNumber: String?
    var vipUser: Bool?
    var numberOfVipBooks: Int?
    var numberOfRegularBooks: Int?
    var cartItems: String?
    var orderedItems: String?
    var expireDate: Int?
}
