//
//  CategoryTableViewCell.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 12/22/19.
//  Copyright © 2019 sukydeveloper. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    
    @IBOutlet var imgView: UIImageView! {
            didSet {
                imgView.contentMode = .scaleToFill
                imgView.layer.backgroundColor = UIColor.clear.cgColor
                
                imgView.layer.masksToBounds = false
                
               
            }
        }
        @IBOutlet var contentLabel: UILabel! {
            didSet {
                contentLabel.numberOfLines = 0
            }
        }
        
        
        let titleFont = UIFont.boldSystemFont(ofSize: 20)
        
        
        lazy var titleAttributes: [NSAttributedString.Key: Any] = {
            let attributes: [NSAttributedString.Key: Any] = [.font: titleFont, .foregroundColor: UIColor.systemBlue]
            return attributes
        }()
        
        
        
        let newRow = NSAttributedString(string: "\n")

        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            if selected {
                backgroundColor = .none
            }
        }
        
        func configure(with model:Genre) {
            let attributedTitle = NSMutableAttributedString(string: model.title, attributes: titleAttributes)
           
            
            
            
            
            contentLabel.attributedText = attributedTitle
            imgView?.image = UIImage(named: model.imageName)
            
        }
    }

