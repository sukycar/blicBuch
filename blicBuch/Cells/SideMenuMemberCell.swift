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
