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
    func selectedBook(id: Int32)
}//adding action for button that is on custom cell view



class CustomCell: UITableViewCell {
    let downloader = KingfisherManager.shared.downloader
    
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    var cellDelegate: AlertMe?
    var index: IndexPath?
    var bookId: Int32?
    var book: Book?
    var cartBook: CartBook?
    var cartBooks: [CartBook]?
    var disposeBag = DisposeBag()
    
    let context = DataManager.shared.context
    
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
    @IBOutlet weak var orderButton: UIButton! {
        didSet{
            orderButton.tag = 0
        }
    }
    
    @IBOutlet weak var orderOutlet: UIButton!
    @IBAction func orderButtonAction(_ sender: Any) {
        if index?.row ?? 0 > 10 {
        cellDelegate?.onClick(index: index!.row)
        } else {
            let bookVipStatus = self.book?.vip
            let availableVipBooks = blicBuchUserDefaults.get(.numberOfVipBooks) as? Int ?? 0
            let availableRegularBooks = blicBuchUserDefaults.get(.numberOfRegularBooks) as? Int ?? 0
            guard let bookId = book?.id else {return}
            let fetchCart = CartBook.fetchRequest() as NSFetchRequest
            fetchCart.predicate = NSPredicate(format: "id == %d", bookId)
            do {
                try self.cartBooks = context?.fetch(fetchCart) ?? [CartBook]()
                cartBook = cartBooks?.first
            } catch {
                print("No data to fetch")
            }
            if cartBook?.inCart != true {
            if bookVipStatus == true && availableVipBooks > 0 {
            cartBook?.id = book?.id ?? 0
            cartBook?.inCart = true
            let newVipBooksNumber = availableVipBooks - 1
            blicBuchUserDefaults.set(.numberOfVipBooks, value: newVipBooksNumber)
            }else if bookVipStatus != true && availableRegularBooks > 0 {
                cartBook?.id = book?.id ?? 0
                cartBook?.inCart = true
                let newBooksNumber = availableRegularBooks  - 1
                blicBuchUserDefaults.set(.numberOfVipBooks, value: newBooksNumber)
            }else if bookVipStatus == true && availableVipBooks == 0 {
                print("No more vip books available")
            }else if bookVipStatus != true && availableRegularBooks == 0{
                print("No more regular books available")
            }
            } else {
                print("Book already added to cart")
            }
            
//        cellDelegate?.selectedBook(id: bookId ?? 0)
        }
        do {
            try context?.save()
            try! context?.parent?.save()
        } catch {
            print("Not saved")
        }
    }
    
    
    var booksForCell = [Book]()
    //var store = DataStore.shared
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.image = nil

    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel.font = UIFont.boldSystemFont(ofSize: 13)
        self.nameLabel.textColor = Colors.Font.blue
        self.authorLabel.font = UIFont.italicSystemFont(ofSize: 13)
        self.authorLabel.textColor = Colors.tint
        self.genreLabel.font = UIFont.systemFont(ofSize: 11)
        self.genreLabel.textColor = Colors.Font.gray
        orderOutlet.backgroundColor = .none
        orderOutlet.layer.borderWidth = 1.5
        orderOutlet.layer.borderColor = .none
        orderOutlet.layer.cornerRadius = 3.5
        orderOutlet.layer.borderColor = Colors.white.cgColor
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    func set(with book: Book) {
        //print("Autor: \(book.author)")
        bookId = book.id
        self.book = book
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

