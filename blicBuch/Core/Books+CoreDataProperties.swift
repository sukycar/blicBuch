//
//  Books+CoreDataProperties.swift
//  
//
//  Created by Vladimir Sukanica on 6/20/20.
//
//

import Foundation
import CoreData


extension Books {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Books> {
        return NSFetchRequest<Books>(entityName: "Books")
    }

    @NSManaged public var author: String?
    @NSManaged public var boxNumber: Int16
    @NSManaged public var genre: String?
    @NSManaged public var id: Int32
    @NSManaged public var imageURL: String?
    @NSManaged public var isbn: String?
    @NSManaged public var title: String?
    @NSManaged public var vip: Bool
    @NSManaged public var vipUser: User?

}
