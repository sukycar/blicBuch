//
//  CartBook+CoreDataProperties.swift
//  
//
//  Created by Vladimir Sukanica on 15.12.20..
//
//

import Foundation
import CoreData


extension CartBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartBook> {
        return NSFetchRequest<CartBook>(entityName: "CartBook")
    }

    @NSManaged public var id: Int32
    @NSManaged public var inCart: Bool
    @NSManaged public var book: Book?

}
