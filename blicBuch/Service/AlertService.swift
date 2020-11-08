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
}
