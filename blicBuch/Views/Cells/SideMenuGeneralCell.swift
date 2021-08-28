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
    
    var sideMenuCell : GeneralMenuCellType = .contact
    var disposeBag = DisposeBag()
    private var viewModel : SideMenuGeneralCellViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }

    
    func setCell(title: String, imageName: String, counter: Int, imageTint: UIColor) {
        let model = SideMenuGeneralCellModel(iconImageName: imageName, cellTitle: title, counterValue: counter, tintColor: imageTint)
        viewModel = SideMenuGeneralCellViewModel(model: model)
        self.imageHolderView.layer.zPosition = 2
        self.imageHolderView.image = UIImage(named: viewModel.imageName)
        self.imageHolderView.tintColor = viewModel.tintColor
        self.titleLabel.type = (.sideMenuTitle, viewModel.cellTitle)
        if sideMenuCell == .cart {
            self.counterLabel.type = (.sideMenuCounterLabel, String(viewModel.counterValue))
        }
        self.counterLabel.layer.masksToBounds = true
        self.counterLabel.isHidden = counter != 0 ? false : true
    }
    
    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }

}
