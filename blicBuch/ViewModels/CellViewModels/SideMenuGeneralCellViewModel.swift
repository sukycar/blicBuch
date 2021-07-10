//
//  SideMenuGeneralCellViewModel.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 8.3.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import UIKit

class SideMenuGeneralCellViewModel {
    
    var model : SideMenuGeneralCellModel
    
    init(model : SideMenuGeneralCellModel) {
        self.model = model
    }
    
    var imageName : String {
        return self.model.iconImageName
    }
    
    var cellTitle : String {
        return self.model.cellTitle
    }
    
    var counterValue : Int {
        return self.model.counterValue
    }
    
    var tintColor : UIColor {
        return self.model.tintColor
    }
}
