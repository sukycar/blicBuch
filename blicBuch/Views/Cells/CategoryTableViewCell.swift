//
//  CategoryTableViewCell.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 12/22/19.
//  Copyright © 2019 sukydeveloper. All rights reserved.
//

import UIKit

class CategoryTableViewCell: TableViewCell {

    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var contentLabel: UILabel!
        
    var viewModel : CategoryCellViewModel!
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
            self.contentLabel.numberOfLines = 1
            self.contentLabel.lineBreakMode = .byTruncatingTail
        }

        
    func set(with genre: String) {
        let categoryCellModel = CategoryCellModel(genreName: genre, imageName: "chevron.right")
        self.viewModel = CategoryCellViewModel(categoryModel: categoryCellModel)
        let attributedTitle = NSMutableAttributedString(string: viewModel.genreTitle, attributes: viewModel.configureLabelWithAttributes())
        contentLabel.attributedText = attributedTitle
            /*imgView?.image = UIImage(named: model.imageName)*/
        imgView.image = UIImage(systemName: viewModel.imageName)
        imgView.contentMode = .scaleToFill
        imgView.layer.backgroundColor = UIColor.clear.cgColor
        imgView.layer.masksToBounds = false
        }
    }

