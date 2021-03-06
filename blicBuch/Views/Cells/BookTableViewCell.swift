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
        }
    }
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    private var bookId: Int32?
    private var viewModel : BookCellViewModel? {
        didSet {
            viewModel?.setLayout(nameLabel: self.nameLabel, authorLabel: self.authorLabel, genreLabel: self.genreLabel, button: self.orderButton)
        }
    }
    var cellDelegate: AlertMe?
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.image = nil
        self.disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellDelegate?.onClick()
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


