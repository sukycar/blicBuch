//
//  User+CoreDataProperties.swift
//  
//
//  Created by Vladimir Sukanica on 12.12.20..
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
    @NSManaged public var logedIn: Bool
    @NSManaged public var books: NSSet?

}

// MARK: Generated accessors for books
extension User {

    @objc(addBooksObject:)
    @NSManaged public func addToBooks(_ value: Book)

    @objc(removeBooksObject:)
    @NSManaged public func removeFromBooks(_ value: Book)

    @objc(addBooks:)
    @NSManaged public func addToBooks(_ values: NSSet)

    @objc(removeBooks:)
    @NSManaged public func removeFromBooks(_ values: NSSet)

}
