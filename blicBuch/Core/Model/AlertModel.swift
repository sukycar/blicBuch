//
//  AlertModel.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 10.3.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation

class AlertModel {
    let titleText : String
    let bodyText : String
    let loginText : String
    let newRegistrationText : String
    let centerText : String
    
    init(titleText: String, bodyText: String, loginText: String, newRegistrationText: String, centerText: String) {
        self.titleText = titleText
        self.bodyText = bodyText
        self.loginText = loginText
        self.newRegistrationText = newRegistrationText
        self.centerText = centerText
    }
 
}
