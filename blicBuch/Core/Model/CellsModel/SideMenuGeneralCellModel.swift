//
//  SideMenuGeneralCellModel.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 8.3.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import UIKit


class SideMenuGeneralCellModel {
    
    let iconImageName : String
    let cellTitle : String
    let counterValue : Int
    let tintColor : UIColor
    
    init(iconImageName : String, cellTitle : String, counterValue : Int, tintColor : UIColor) {
        self.iconImageName = iconImageName
        self.cellTitle = cellTitle
        self.counterValue = counterValue
        self.tintColor = tintColor
    }
}
