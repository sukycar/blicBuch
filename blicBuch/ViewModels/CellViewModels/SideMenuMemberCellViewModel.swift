//
//  SideMenuMemberCellViewModel.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 6.3.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation

class SideMenuMemberCellViewModel {
    
    var sideMenuMemberCell : SideMenuMemberCellModel
    
    init(sideMenuMemberCell : SideMenuMemberCellModel) {
        self.sideMenuMemberCell = sideMenuMemberCell
    }
    
    var userName : String {
        return self.sideMenuMemberCell.userName
    }
}


