//
//  Enums.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 5.1.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import UIKit

//enum for labels
enum LabelType{
    case none, sideMenuCounterLabel, sideMenuTitle
    var textColor:UIColor {
        switch self {
        case .none:
            return UIColor.clear
        case .sideMenuCounterLabel:
            return UIColor.blue
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
            return UIColor.gray
        default:
            return nil
        }
    }
    var textAlignment:NSTextAlignment?{
        switch self {
        
        default:
            return nil
        }
    }
    
    var borderSize: CGFloat? {
        switch self {
        default:
            return nil
        }
    }
    
    var cornerRadius:CGFloat? {
        switch self {
            
        default:
            return nil
        }
    }
    var borderColor:CGColor? {
        switch self {
        default:
            return nil
        }
    }
    
    var edgeInsets:UIEdgeInsets?{
        switch self {
        
        default:
            return nil
        }
    }
}

//enum for fonts
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

//enum for alert type for in-app purchase
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

//enum for alert buttons
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

//enum for side menu
enum SideMenuCellType{
    case member,general(type:GeneralMenuCellType)
}

enum GeneralMenuCellType: CaseIterable{
    case login, register, contact, donate, cart
    var title:String{
        switch self {
        case .login:
            return "Einloggen".localized()
        case .register:
            return "Registrieren".localized()
        case .contact:
            return "Kontakt".localized()
        case .donate:
            return "SCHENKUNG".localized()
        case .cart:
            return "Cart".localized()
        }
    }
    
    var imageName: String {
        switch self {
        case .login:
            return "img_login"
        case .register:
            return "img_registration"
        case .contact:
            return "img_contact"
        case .donate:
            return "img_menu_donate"
        case .cart:
            return "img_cart"
        }
    }
    
    var imageTint: UIColor {
        switch self {
        
        case .login:
            return Colors.blueDefault
        case .register:
            return Colors.blueDefault
        case .contact:
            return Colors.blueDefault
        case .donate:
            return Colors.orange
        case .cart:
            return Colors.blueDefault
        }
    }
}

//enum for book lock
enum LockStatus: Int16 {
    case locked = 1
    case unlocked = 0
}
