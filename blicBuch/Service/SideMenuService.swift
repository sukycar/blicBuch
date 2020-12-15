//
//  SideMenuService.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 12.12.20..
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import Foundation
import UIKit

class SideMenuService {
@objc func callMenu() -> SideMenuViewController {
    let storyBoard = UIStoryboard(name: "Main", bundle: .main)
    if #available(iOS 13.0, *) {
        let SideMenuVC = storyBoard.instantiateViewController(identifier: "SideMenuVC") as! SideMenuViewController
        SideMenuVC.modalPresentationStyle = .overFullScreen
        return SideMenuVC
    } else {
        // Fallback on earlier versions
        return SideMenuViewController()
    }
    
}
}
