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
        
        
    let titleFont = UIFont.systemFont(ofSize: 14)
        let aColor = UIColor(hexString: "#5cbcf4")//custom text color
        
        lazy var titleAttributes: [NSAttributedString.Key: Any] = {
            let attributes: [NSAttributedString.Key: Any] = [.font: titleFont, .foregroundColor: aColor]
            return attributes
        }()
        
        
        
        let newRow = NSAttributedString(string: "\n")

        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
            self.contentLabel.numberOfLines = 1
            self.contentLabel.lineBreakMode = .byTruncatingTail
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            if selected {
                backgroundColor = .none
            }
        }
        
    func set(with model:Books) {
        let attributedTitle = NSMutableAttributedString(string: model.genre!, attributes: titleAttributes)
            
            
            contentLabel.attributedText = attributedTitle
            /*imgView?.image = UIImage(named: model.imageName)*/
            
        }
    }

