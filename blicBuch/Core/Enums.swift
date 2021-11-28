//
//  Enums.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 5.1.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import UIKit

// MARK: - LABEL
enum LabelType{
    case none, sideMenuCounterLabel, sideMenuTitle
    var textColor:UIColor {
        switch self {
        case .none:
            return UIColor.clear
        case .sideMenuCounterLabel:
            return UIColor.white
        case .sideMenuTitle:
            return Colors.defaultFontColor
        }
    }
    
    var fontName:FontName{
        switch self {
        case .none:
            return .regular
        case .sideMenuCounterLabel:
            return .regular
        case .sideMenuTitle:
            return .regular
        }
    }
    
    var fontSize: CGFloat {
        switch self {
        case .none:
            return 0
        case .sideMenuCounterLabel:
            return 16
        case .sideMenuTitle:
            return 16
        }
    }
    
    var backgroundColor:UIColor? {
        switch self {
        case .sideMenuCounterLabel:
            return .orange
        default:
            return nil
        }
    }
    
    var zPosition: CGFloat? {
        switch self {
        case .sideMenuCounterLabel:
            return 2
        case .sideMenuTitle:
            return 2
        default:
            return 0
        }
    }
    
    var textAlignment:NSTextAlignment?{
            return nil
    }
    
    var borderSize: CGFloat? {
            return nil
    }
    
    var cornerRadius:CGFloat? {
        switch self {
        case .sideMenuCounterLabel:
            return 4
        default:
            return nil
        }
    }
    
    var borderColor:CGColor? {
            return nil
    }
    
    var edgeInsets:UIEdgeInsets?{
        switch self {
        case .sideMenuCounterLabel:
            return UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        default:
            return nil
        }
    }
}

// MARK: - FONT
enum FontName {
    case regular, bold
    var value:String {
        switch self {
        case .regular:
            return "Roboto-Regular"
        case .bold:
            return "Roboto-Bold"
        }
    }
}

// MARK: - ALERT TYPE
enum AlertType {
    case orderBooks
    case subscribe
    
    var title: String {
        switch self {
        case .orderBooks:
            return "Zavrsavanje narudzbine"
        case .subscribe:
            return "Willkommen in blic Buch"
        }
    }
        
        var bodyText: String {
            switch self {
            case .orderBooks:
                return "Postovani, kako bih potvrdili porudzbinu i placanje postarine, molimo vas da pritisnete dugme 'OK'. U suprotnom pritisnite dugme 'Cancel'"
            case .subscribe:
                return "Postovani, imate tri opcije za registraciju. Nakon mesec dana, clanstvo se obnavlja po istoj ceni, nakon vaseg odobrenja. Za informacije o pogodnostima, idite na info sekciju"
            }
        }

}

//enum for product in StoreKit
enum Product: String, CaseIterable {
    case transport = "com.temporary.transport"
}

//enum for auto - renew subscriptions
enum Subscriptions: String, CaseIterable {
    case free = "com.temporary.free"
    case regular = "com.temporary.regular"
    case vip = "com.temporary.vip"
}

// MARK: - ALERT BUTTON TYPE
enum AlertButtonType {
    case free
    case regular
    case vip
    case ok
    case cancel


var buttonText: String {

        switch self {
        case .free:
            return "Free"
        case .regular:
            return "Regular: 2.99 €"
        case .vip:
            return "Vip: 4.99 €"
        case .ok:
            return "OK"
        case .cancel:
            return "Cancel"
        }
}
    
    var actionName: String {
        switch self {
        case .cancel:
            return "cancel"
        case .free:
            return "free"
        case .regular:
            return "regular"
        case .vip:
            return "vip"
        case .ok:
            return "ok"
        }
    }
}

// MARK: - SIDE MENU

enum SideMenuCellType {
    case member,general(type:GeneralMenuCellType)
}

enum GeneralMenuCellType: CaseIterable {
    case contact, cart, logout
    var title:String{
        switch self {
        case .contact:
            return "Contact".localized()
        case .cart:
            return "Cart".localized()
        case .logout:
            return "Logout".localized()
        }
    }
    
    
    var imageName: String {
        switch self {
        case .contact:
            return "img_contact"
        case .cart:
            return "img_cart"
        case .logout:
            return "img_login"
        }
    }
    
    var imageTint: UIColor {
        switch self {
        
        case .logout:
            return Colors.blueDefault
        case .contact:
            return Colors.blueDefault
        case .cart:
            return Colors.blueDefault
        }
    }
}

// MARK: - LOCK BOOK

enum LockStatus: Int16 {
    case locked = 1
    case unlocked = 0
}

// MARK: - TYPES OF NON-RENEWABLE SUBSCRIPTION

enum SubscriptionTypeBundleId: String, CaseIterable {
    case starter = "club.blitzBuch.starter"
    case regular = "club.blitzBuch.regular"
    case vip = "club.blitzBuch.vip"
}
