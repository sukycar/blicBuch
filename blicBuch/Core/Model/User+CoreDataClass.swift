//
//  User+CoreDataClass.swift
//  
//
//  Created by Vladimir Sukanica on 12.12.20..
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(User)
public class User: NSManagedObject {

    func updateForList(with json: JSON){
        self.address = json[CodingKeys.address.rawValue].string
        self.city = json[CodingKeys.city.rawValue].string
        self.email = json[CodingKeys.email.rawValue].string
        self.id = json[CodingKeys.id.rawValue].int32Value
        self.name = json[CodingKeys.name.rawValue].string
        self.password = json[CodingKeys.password.rawValue].string
        self.payment = json[CodingKeys.payment.rawValue].bool ?? false
        self.phoneNumber = json[CodingKeys.phoneNumber.rawValue].string
        self.vipUser = json[CodingKeys.vipUser.rawValue].bool ?? false
        //self.vipBooks = NSSet?
    }
}

extension User {
    enum CodingKeys: String, CodingKey {
        case address
        case city
        case email
        case id
        case name
        case password
        case payment
        case phoneNumber
        case vipUser
        //case vipBooks
    }
}

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
}

