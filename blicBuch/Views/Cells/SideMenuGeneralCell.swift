//
//  SideMenuGeneralCell.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 12.12.20..
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SideMenuGeneralCell: TableViewCell {

    @IBOutlet weak var imageHolderView: UIImageView!
    @IBOutlet weak var titleLabel: Label!
    @IBOutlet weak var counterLabel: Label!
    @IBOutlet weak var actionButton: UIButton!
    
    var sideMenuCell : GeneralMenuCellType = .login
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }

    
    func setCell(title: String, imageName: String, counter: Int, imageTint: UIColor) {
        if sideMenuCell != .login {
            actionButton.isUserInteractionEnabled = false
        }
        self.imageHolderView.layer.zPosition = 2
        self.imageHolderView.image = UIImage(named: imageName)
        self.imageHolderView.tintColor = imageTint
        self.titleLabel.type = (.sideMenuTitle, title)
        if sideMenuCell == .cart {
        self.counterLabel.type = (.sideMenuCounterLabel, String(counter))
        }
        self.counterLabel.layer.masksToBounds = true
        self.counterLabel.isHidden = counter != 0 ? false : true
    }
    
    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }

}
