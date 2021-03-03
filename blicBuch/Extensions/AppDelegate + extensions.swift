//
//  AppDelegate + extensions.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 12.12.20..
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit
import MapKit
extension AppDelegate {
    
    private static var tosterLoader = Array<String?>()
    private static var presentingToaster = false
    
    func customizeAppearance(){
//        UIApplication.shared.statusBarStyle = .default
        
        UINavigationBar.appearance().barStyle = .default
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = Colors.black
        UINavigationBar.appearance().barTintColor =  UIColor.black
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().clipsToBounds = false
        UINavigationBar.appearance().backgroundColor = UIColor.black
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font : (UIFont(name: FontName.bold.value, size: FontSize.navigationTitle)) ?? UIFont.systemFont(ofSize: FontSize.navigationTitle), NSAttributedString.Key.foregroundColor: UIColor.black]
        let attributes = [NSAttributedString.Key.font:UIFont(name: FontName.regular.value, size: FontSize.tabBar) ?? UIFont.systemFont(ofSize: FontSize.tabBar) ] as [NSAttributedString.Key : Any]
        
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UITabBar.appearance().tintColor = Colors.blueDefault
        let backButtonImage = resizeImage(image: #imageLiteral(resourceName: "img_back"), targetSize: CGSize(width: 24, height: 44))
        let backImage = backButtonImage.withRenderingMode(.alwaysTemplate)
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -244, vertical: -5.0), for: .default)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.white
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 2.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    class func showTosterMessage(_ message:String?){
        tosterLoader.append(message)
        if !presentingToaster {
            self.presentNextToasterMessage()
        }
    }
    
    private class func presentNextToasterMessage() {
        let message = tosterLoader.first
        if let message = message {
            presentingToaster = true
            tosterLoader.remove(at: 0)
            let messageLabel = ToasterLabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
            messageLabel.attributedText = UIFont.toasterLabel(text: message)
            messageLabel.numberOfLines = 0
            messageLabel.sizeToFit()
            messageLabel.frame.size.width = UIScreen.main.bounds.width
            messageLabel.frame.origin.y = -80 + (UIApplication.shared.windows[0].windowScene?.statusBarManager?.statusBarFrame.height ?? 0)
            
            let appDelegate = UIApplication.shared.windows.first
            if let window = appDelegate {
                window.addSubview(messageLabel)
                window.bringSubviewToFront(messageLabel)
                messageLabel.translatesAutoresizingMaskIntoConstraints = false
                if messageLabel.frame.height < 80 {
                    messageLabel.frame.size.height = 80
                }
                let topAnchor = messageLabel.topAnchor.constraint(equalTo: window.topAnchor, constant: -(80 + 2 * (UIApplication.shared.windows[0].windowScene?.statusBarManager?.statusBarFrame.height ?? 0) + messageLabel.frame.height))
                topAnchor.isActive = true
                messageLabel.leftAnchor.constraint(equalTo: window.leftAnchor).isActive = true
                messageLabel.rightAnchor.constraint(equalTo: window.rightAnchor).isActive = true
                messageLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 80 + (UIApplication.shared.windows[0].windowScene?.statusBarManager?.statusBarFrame.height ?? 0)).isActive = true
                messageLabel.topInset = (UIApplication.shared.windows[0].windowScene?.statusBarManager?.statusBarFrame.height ?? 0)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                    topAnchor.constant = 0
                    UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
                        window.layoutIfNeeded()
                    }, completion: { (finished) in
                        UIView.animate(withDuration: 0.25, delay: 2.5, options: [], animations: {
                            topAnchor.constant = -messageLabel.frame.height
                            window.layoutIfNeeded()
                            
                        }, completion: { (finished) in
                            presentingToaster = false
                            presentNextToasterMessage()
                            messageLabel.removeFromSuperview()
                        })
                    })
                })
            }
        }
    }
    
}

extension UIApplication {

    class func getTopMostViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        } else {
            return nil
        }
    }
}

