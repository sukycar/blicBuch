//
//  AlertViewModel.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 10.3.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import UIKit

class AlertViewModel {
    
    var model : AlertModel
    
    init(model : AlertModel) {
        self.model = model
    }
    
    var titleLabelText : String {
        return self.model.titleText
    }
    
    var bodyLabelText : String {
        return self.model.bodyText
    }
    
    var loginButtonText : String {
        return self.model.loginText
    }
    
    var registrationButtonText : String {
        return self.model.newRegistrationText
    }
    
    var separationLabelText : String {
        return self.model.centerText
    }
    
    func configureAlertView(titleLabel : UILabel, bodyTextLabel : UILabel, centerLabel: UILabel, loginButton : UIButton, registerButton : UIButton, holderView : UIView, titleLabelView : UIView, deviceType : DeviceType){
        titleLabel.textColor = .white
        titleLabel.text = titleLabelText
        bodyTextLabel.numberOfLines = 3
        bodyTextLabel.text = bodyLabelText
        centerLabel.text = separationLabelText
        loginButton.setTitle(loginButtonText, for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = deviceType != DeviceType.macCatalyst ? Colors.blueDefault : .clear
        loginButton.layer.cornerRadius = CornerRadius.mediumSmall
        registerButton.setTitle(registrationButtonText, for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = deviceType != DeviceType.macCatalyst ? Colors.blueDefault : .clear
        registerButton.layer.cornerRadius = CornerRadius.mediumSmall
        holderView.layer.cornerRadius = CornerRadius.medium
        titleLabelView.layer.masksToBounds = true
        titleLabelView.layer.cornerRadius = CornerRadius.medium
        titleLabelView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
}
