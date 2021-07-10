//
//  CategoryCellViewModel.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 6.3.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import UIKit

class CategoryCellViewModel {
    
    var categoryModel : CategoryCellModel
    
    init(categoryModel : CategoryCellModel){
        self.categoryModel = categoryModel
    }
    
    var genreTitle: String {
        return self.categoryModel.genreName
    }
    
    var imageName: String {
        return self.categoryModel.imageName
    }
    
    func configureLabelWithAttributes() -> [NSAttributedString.Key: Any] {
        let titleFont = UIFont.systemFont(ofSize: 14)
        let aColor = UIColor(hexString: "#5cbcf4")
        
        let titleAttributes: [NSAttributedString.Key: Any] = {
            let attributes: [NSAttributedString.Key: Any] = [.font: titleFont, .foregroundColor: aColor]
            return attributes
        }()
        return titleAttributes
    }
    
}
