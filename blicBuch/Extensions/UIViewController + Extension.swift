//
//  UIViewController + Extension.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 17.12.20..
//  Copyright © 2020 sukydeveloper. All rights reserved.
//
import Foundation
import UIKit
import RxSwift

extension UIViewController {
    
    func getAlert(errorString: String, errorColor: UIColor) {
        let label = ToasterLabel()
        if #available(iOS 13.0, *){
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate, let window = sceneDelegate.window{
                label.translatesAutoresizingMaskIntoConstraints = false
                window.addSubview(label)
                label.centerXAnchor.constraint(equalTo: window.centerXAnchor, constant: 0).isActive = true
                if let self = self as? UINavigationController {
                    label.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -self.toolbar.frame.height - 40).isActive = true
                }else{
                    label.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -40).isActive = true
                }
                label.leadingAnchor.constraint(greaterThanOrEqualTo: window.leadingAnchor, constant: 20).isActive = true
                label.trailingAnchor.constraint(lessThanOrEqualTo: window.trailingAnchor, constant: -20).isActive = true
                //            label.trailingAnchor.constraint(greaterThanOrEqualTo: window.trailingAnchor, constant: -20).isActive = true
                label.backgroundColor = errorColor
                label.clipsToBounds = true
                label.layer.cornerRadius = 20
                label.numberOfLines = 0
                label.font = UIFont.systemFont(ofSize: 14)
                label.textColor = Colors.white
                label.textAlignment = .center
                label.text = errorString
                label.alpha = 0
                
                UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseIn, animations: {[weak label] in
                    label?.alpha = 1
                }) { (finished) in
                    UIView.animate(withDuration: 0.7, delay: 2, options: .curveEaseIn, animations: {[weak label] in
                        label?.alpha = 0
                    }) {[weak label] (finished) in
                        label?.removeFromSuperview()
                    }
                    
                }
            }
        }
    }
    
    /// Function for updating books number in userDefaults and on API side
    /// - Parameters:
    ///   - vip: boolean that tells is book in vip section
    ///   - removeBooks: does the function remove book from API or add it
    ///   - numberOfBooks: how much books function adds or removes from API
    public func updateBooksNumber(vip: Bool, removeBooks: Bool, numberOfBooks: Int, disposeBag: DisposeBag){
        let userDefaultsBooks = vip == true ? blicBuchUserDefaults.get(.numberOfVipBooks) as! Int : blicBuchUserDefaults.get(.numberOfRegularBooks) as! Int
        var newUserDefaultsBooks = Int()
        if numberOfBooks != 0 {
            if removeBooks == true && numberOfBooks <= userDefaultsBooks {
                newUserDefaultsBooks = userDefaultsBooks - numberOfBooks
                _ = vip == true ? blicBuchUserDefaults.set(.numberOfVipBooks, value: newUserDefaultsBooks) : blicBuchUserDefaults.set(.numberOfRegularBooks, value: newUserDefaultsBooks)
            } else if removeBooks == false {
                newUserDefaultsBooks = userDefaultsBooks + numberOfBooks
                _ = vip == true ? blicBuchUserDefaults.set(.numberOfVipBooks, value: newUserDefaultsBooks) : blicBuchUserDefaults.set(.numberOfRegularBooks, value: newUserDefaultsBooks)
            }
            let updatedUserDefaults = vip == true ? blicBuchUserDefaults.get(.numberOfVipBooks) as! Int : blicBuchUserDefaults.get(.numberOfRegularBooks) as! Int
            let userId = blicBuchUserDefaults.get(.id) as? Int32 ?? 0
            UsersService.changeNumberOfBooks(vip: vip, userId: userId, numberOfBooks: updatedUserDefaults).subscribe { (updated) in
            } onError: { (error) in
                self.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
            } onCompleted: {
            }.disposed(by: disposeBag)
        }
    }
}
