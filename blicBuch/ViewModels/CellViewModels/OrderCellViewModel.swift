//
//  OrderCellViewModel.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 6.3.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import UIKit

class OrderCellViewModel {
    
    var model : OrderCellModel
    
    init(model : OrderCellModel){
        self.model = model
    }
    
    var serviceTypeText : String {
        return self.model.serviceText
    }
    
    var priceText : String {
        return self.model.priceText
    }
    
    var orderButtonText : String {
        return self.model.orderButtonText
    }
    
    var priceLabelFont = UIFont.systemFont(ofSize: 14, weight: .bold)
    
    var serviceTypeLabelFont = UIFont.systemFont(ofSize: 14, weight: .bold)
    
    func configureButton(for button: UIButton, deviceType: DeviceType){
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        button.backgroundColor = deviceType != .macCatalyst ? Colors.blueDefault : .clear
        button.tintColor = Colors.white
    }
}
