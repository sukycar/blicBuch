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



/// Activate alert view on click of order button
/// if user is not logged in
protocol AlertMe {
    func onClick()
}

class BookTableViewCell: TableViewCell {
    
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
    
    private var bookId: Int32?
    private var viewModel : BookCellViewModel?
    var cellDelegate: AlertMe?
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.image = nil
        self.disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.styleViews()
        self.cellDelegate?.onClick()
    }
    
    func styleViews(){
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
        self.viewModel = BookCellViewModel(model: book)
        bookId = viewModel?.id
        vipHolderImageView.image = viewModel?.vipSign
        if viewModel?.vip == true && inVipController == true{
            vipHolderImageView.isHidden = true
        } else if viewModel?.vip == true{
            vipHolderImageView.isHidden = false
        } else if viewModel?.vip == false {
            vipHolderImageView.isHidden = true
        }
        
        if let url = URL(string: (viewModel?.bookImage)!) {
            self.imgView.kf.indicatorType = .activity
            self.imgView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil)}
        self.nameLabel.text = viewModel?.bookTitle
        self.authorLabel.text = viewModel?.authorName
        self.genreLabel.text = viewModel?.genre
    }
}


