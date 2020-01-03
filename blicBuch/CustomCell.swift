//
//  CustomCellTableViewCell.swift
//  CustomTableCell
//
//  Created by Vladimir Sukanica on 02/12/19.
//  Copyright © 2019 sukydeveloper. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet var imgView: UIImageView! {
        didSet {
            imgView.contentMode = .scaleToFill
            imgView.layer.backgroundColor = UIColor.clear.cgColor
            imgView.layer.shadowColor = UIColor.gray.cgColor
            imgView.layer.masksToBounds = false
            imgView.layer.shadowRadius = 6
            imgView.layer.shadowOpacity = 1
            imgView.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowPath = UIBezierPath(rect: self.bounds.inset(by: .zero)).cgPath
        }
    }
    @IBOutlet var contentLabel: UILabel! {
        didSet {
            contentLabel.numberOfLines = 0
        }
    }
    
    
    let titleFont = UIFont.boldSystemFont(ofSize: 13)
    let authorFont = UIFont.italicSystemFont(ofSize: 13)
    let genreFont = UIFont.systemFont(ofSize: 11)
    
    lazy var titleAttributes: [NSAttributedString.Key: Any] = {
        let attributes: [NSAttributedString.Key: Any] = [.font: titleFont, .foregroundColor: UIColor.systemBlue]
        return attributes
    }()
    
    lazy var authorAttributes: [NSAttributedString.Key: Any] = {
        let attributes:[NSAttributedString.Key: Any] = [.font: authorFont]
        return attributes
    }()
    
    lazy var genereAttributes: [NSAttributedString.Key: Any] = {
        let attributes:[NSAttributedString.Key: Any] = [.font: genreFont, .foregroundColor: UIColor.gray]
        return attributes
    }()
    
    let newRow = NSAttributedString(string: "\n")

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model:Book) {
        let attributedTitle = NSMutableAttributedString(string: model.title, attributes: titleAttributes)
        let attributedAuthor = NSAttributedString(string: model.authors.joined(separator: ", "), attributes: authorAttributes)
        let attributedGenre = NSAttributedString(string: model.genre, attributes: genereAttributes)
        
        attributedTitle.append(newRow)
        attributedTitle.append(attributedAuthor)
        attributedTitle.append(newRow)
        attributedTitle.append(attributedGenre)
        contentLabel.attributedText = attributedTitle
        imgView?.image = UIImage(named: model.imageName)
    }
}
