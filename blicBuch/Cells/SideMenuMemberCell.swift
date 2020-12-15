//
//  SideMenuMemberCell.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 12.12.20..
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit
import RxSwift

class SideMenuMemberCell: TableViewCell {

    @IBOutlet weak var usernameLabel: Label!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.logoutImageButton.setImage(UIImage(named: "img_logout"), for: .normal)
//        self.logoutImageButton.setTitleColor(Colors.basicBlueColor, for: .normal)
//        self.logoutLabel.type = (.sideMenuLogoutTitle, "Logout")
//        self.showAllLines = false
//        actionButton.rx.tap.subscribe (onNext: {[weak self] (pressed) in
//            DispatchQueue.main.async {
//                self?.logout()
//            }
//            return
//        }).disposed(by: self.disposeBag)
        self.showLeftLine = false
        self.showRightLine = false
        self.showTopLine = false

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(name: String?) {
        usernameLabel.type = (.sideMenuTitle, name)
    }
    
   
}
