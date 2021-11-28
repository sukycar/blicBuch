//
//  AlertService.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 1/8/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit

class AlertService {
     
    func alert() -> AlertViewController {
        let storyboard = UIStoryboard(name: "Alert", bundle: .main)
        let alertVC = storyboard.instantiateViewController(identifier: "AlertVC") as! AlertViewController
        return alertVC
    }
    
    func get(with alertType: AlertType) -> InAppPurchaseAlertViewController{
        let vc = UIStoryboard(name: "Alert", bundle: nil).instantiateViewController(identifier: "InAppPurchaseVC") as InAppPurchaseAlertViewController
        vc.alertType = alertType
        return vc
    }
    
    func alertDialog(message: String) -> DialogViewController {
        let vc = UIStoryboard(name: "Alert", bundle: nil).instantiateViewController(identifier: "DialogViewController") as DialogViewController
        vc.titleText = message
        return vc
    }
    
}
