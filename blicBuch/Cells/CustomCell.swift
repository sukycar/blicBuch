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

protocol AlertMe {
    func onClick(index: Int)
}//adding action for button that is on custom cell view
    
    

class CustomCell: UITableViewCell {
    let downloader = KingfisherManager.shared.downloader
    
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    var cellDelegate: AlertMe?
    var index: IndexPath?
    
    @IBOutlet var imgView: UIImageView! {
        didSet {
            downloader.trustedHosts = Set(["www.vsukanica.com"])
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
        
        cellDelegate?.onClick(index: index!.row)
       
        
    }
    

    var booksForCell = [Books]()
    //var store = DataStore.shared
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imgView.image = nil
//        self.nameLabel.isHidden = true
//        //self.imgView.isHidden = true
//        self.authorLabel.isHidden = true
//        self.genreLabel.isHidden = true
//        self.orderButton.isHidden = true
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel.font = UIFont.boldSystemFont(ofSize: 13)
        self.nameLabel.textColor = Colors.Font.blue
        self.authorLabel.font = UIFont.italicSystemFont(ofSize: 13)
        self.authorLabel.textColor = Colors.tint
        self.genreLabel.font = UIFont.systemFont(ofSize: 11)
        self.genreLabel.textColor = Colors.Font.gray
        /*store.requestBooks { (books) in
            self.booksForCell = books
        }*/
        // Initialization code
        orderOutlet.backgroundColor = .none
        orderOutlet.layer.borderWidth = 1.5
        orderOutlet.layer.borderColor = .none
        orderOutlet.layer.cornerRadius = 3.5
        
        orderOutlet.layer.borderColor = Colors.white.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    func set(with book: Books) {
        //print("Autor: \(book.author)")
        if let url = URL(string: "\(book.imageURL!)") {
        //DispatchQueue.global().async {
            //let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            //DispatchQueue.main.async {
        self.imgView.kf.indicatorType = .activity
            self.imgView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.3)), .downloader(downloader)], progressBlock: nil)}
                //self.imgView.image = UIImage(data: data!)
            //}
            
        //}
        self.nameLabel.text = book.title ?? "--"
        self.authorLabel.text = book.author ?? "--"
        self.genreLabel.text = book.genre ?? "--"
    }
  
}

