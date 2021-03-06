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

class BookCellViewModel {
    
    var model : Book
    
    init(model : Book) {
        self.model = model
    }
    
    var id : Int32 {
        return self.model.id
    }
    
    var authorName : String {
        return self.model.author ?? ""
    }
    
    var bookTitle : String {
        return self.model.title ?? ""
    }
    
    var genre : String {
        return self.model.genre ?? ""
    }
    
    var vip : Bool {
        return self.model.vip
    }
    
    var bookImage : String {
        return self.model.imageURL ?? ""
    }
    
    var bookLocked : Int16 {
        return self.model.locked
    }
    
    var vipSign : UIImage {
        return self.vip == true ? UIImage(named: "img_vip_cover")! : UIImage()
    }
    
    func setLayout(nameLabel: UILabel, authorLabel: UILabel, genreLabel: UILabel, button: UIButton) {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 13)
        nameLabel.textColor = Colors.Font.blue
        authorLabel.font = UIFont.italicSystemFont(ofSize: 13)
        authorLabel.textColor = Colors.tint
        genreLabel.font = UIFont.systemFont(ofSize: 11)
        genreLabel.textColor = Colors.Font.gray
        button.backgroundColor = .none
        button.layer.borderWidth = 1.5
        button.layer.borderColor = .none
        button.layer.cornerRadius = 3.5
        button.layer.borderColor = Colors.white.cgColor
    }
    
    
}
