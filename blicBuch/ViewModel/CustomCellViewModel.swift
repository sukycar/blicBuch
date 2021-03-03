//
//  CustomCellViewModel.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 23.2.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CustomCellViewModel {
    
    let id : Int32
    let authorName: String
    let bookTitle: String
    let genre: String
    let vip: Bool
    let vipSign: UIImage
    let bookImage: String
    var bookLocked: Int16
    
    init(book: Book, inVipController: Bool) {
        self.id = Int32(book.id)
        self.authorName = book.author ?? ""
        self.bookTitle = book.title ?? ""
        self.genre = book.genre ?? ""
        self.vip = book.vip
        self.bookImage = book.imageURL ?? ""
        self.bookLocked = book.locked
        
        if self.vip == true && inVipController != true{
            vipSign = UIImage(named: "img_vip_cover")!
        } else {
            vipSign = UIImage()
        }
        
    }
    
    
}
