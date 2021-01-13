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
    
    var sideMenuCell : GeneralMenuCellType = .login
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(title: String, imageName: String, counter: String, imageTint: UIColor) {
        self.imageHolderView.image = UIImage(named: imageName)
        self.imageHolderView.tintColor = imageTint
        switch sideMenuCell {
        case .donate:
            self.titleLabel.type = (.sideMenuTitle, title)
            self.counterLabel.type = (.sideMenuCounterLabel, counter)
        default:
            self.titleLabel.type = (.sideMenuTitle, title)
            self.counterLabel.type = (.sideMenuCounterLabel, counter)
        }
    }
    
    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }

}
