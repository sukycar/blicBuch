//
//  NavigationController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 6/20/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass
class NavigationController: UINavigationController, UIViewControllerTransitioningDelegate, UINavigationBarDelegate, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationBar.tintColor = Styles.Navigation.bar().textColor//FontAndColor.Navigation.tint().color
        self.navigationBar.barTintColor =  UIColor.clear
//        self.navigationBar.backgroundColor = Styles.Navigation.bar().backgroundColor
//        self.view.backgroundColor = UIColor.white//Styles.mainView().backgroundColor
//        let textAttributes = [NSAttributedString.Key.foregroundColor:Styles.Navigation.bar().textColor, NSAttributedString.Key.font:Styles.Navigation.bar().font]
//        navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        //self.navigationBar.barTintColor = Colors.defaultGray
        self.navigationBar.isTranslucent = false
        self.toolbar.isTranslucent = false
        //self.toolbar.barTintColor = Colors.darkGray
        self.navigationBar.shadowImage = UIImage()


    }
    
    class func startActivityIndicator(){
        UIApplication.shared.delegate?.window??.startActivityIndicator()
    }
    class func stopActivityIndicator(){
        UIApplication.shared.delegate?.window??.stopActivityIndicator()
    }
}
