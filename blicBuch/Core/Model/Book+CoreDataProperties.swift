//
//  Book+CoreDataProperties.swift
//  
//
//  Created by Vladimir Sukanica on 15.12.20..
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var author: String?
    @NSManaged public var boxNumber: Int16
    @NSManaged public var genre: String?
    @NSManaged public var id: Int32
    @NSManaged public var imageURL: String?
    @NSManaged public var inCart: Bool
    @NSManaged public var isbn: String?
    @NSManaged public var title: String?
    @NSManaged public var vip: Bool
    @NSManaged public var weRecommend: Bool
    @NSManaged public var locked: Int16
    @NSManaged public var user: User?
}
