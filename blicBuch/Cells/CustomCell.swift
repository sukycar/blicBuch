//
//  CustomCellTableViewCell.swift
//  CustomTableCell
//
//  Created by Vladimir Sukanica on 02/12/19.
//  Copyright © 2019 sukydeveloper. All rights reserved.
//

import UIKit
import Kingfisher
import CoreData
import RxSwift

protocol AlertMe {
    func onClick(index: Int)
}//adding action for button that is on custom cell view

class CustomCell: TableViewCell {
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var vipHolderImageView: UIImageView!
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
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    
    var cellDelegate: AlertMe?
    var index: IndexPath?
    var bookId: Int32?
    var book: Book?
    var cartBook: CartBook?
    var cartBooks: [CartBook]?
    var booksInCart: [Book]?
    var disposeBag = DisposeBag()
    private let context = DataManager.shared.context
    var booksForCell = [Book]()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.image = nil
        self.disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel.font = UIFont.boldSystemFont(ofSize: 13)
        self.nameLabel.textColor = Colors.Font.blue
        self.authorLabel.font = UIFont.italicSystemFont(ofSize: 13)
        self.authorLabel.textColor = Colors.tint
        self.genreLabel.font = UIFont.systemFont(ofSize: 11)
        self.genreLabel.textColor = Colors.Font.gray
        orderButton.backgroundColor = .none
        orderButton.layer.borderWidth = 1.5
        orderButton.layer.borderColor = .none
        orderButton.layer.cornerRadius = 3.5
        orderButton.layer.borderColor = Colors.white.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func set(with book: Book, inVipController: Bool) {
        //print("Autor: \(book.author)")
        bookId = book.id
        self.book = book
        if book.vip == true && inVipController == true{
            vipHolderImageView.isHidden = true
        } else if book.vip == true{
            vipHolderImageView.isHidden = false
            vipHolderImageView.image = UIImage(named: "img_vip_cover")
        } else if book.vip == false {
            vipHolderImageView.isHidden = true
        }
        if let imageUrl = book.imageURL{
            if let url = URL(string: imageUrl) {
                self.imgView.kf.indicatorType = .activity
                self.imgView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil)}
            self.nameLabel.text = book.title ?? "--"
            self.authorLabel.text = book.author ?? "--"
            self.genreLabel.text = book.genre ?? "--"
        }
    }
}


