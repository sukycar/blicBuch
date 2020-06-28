//
//  User+CoreDataProperties.swift
//  
//
//  Created by Vladimir Sukanica on 6/20/20.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var address: String?
    @NSManaged public var city: String?
    @NSManaged public var email: String?
    @NSManaged public var id: Int32
    @NSManaged public var membershipTimer: Date?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var payment: Bool
    @NSManaged public var phoneNumber: Int64
    @NSManaged public var vipUser: Bool
    @NSManaged public var vipBooks: NSSet?

}

// MARK: Generated accessors for vipBooks
extension User {

    @objc(addVipBooksObject:)
    @NSManaged public func addToVipBooks(_ value: Books)

    @objc(removeVipBooksObject:)
    @NSManaged public func removeFromVipBooks(_ value: Books)

    @objc(addVipBooks:)
    @NSManaged public func addToVipBooks(_ values: NSSet)

    @objc(removeVipBooks:)
    @NSManaged public func removeFromVipBooks(_ values: NSSet)

}
