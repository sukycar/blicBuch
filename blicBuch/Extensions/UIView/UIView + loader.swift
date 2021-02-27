//
//  UIView + loader.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 14.12.20..
//  Copyright © 2020 sukydeveloper. All rights reserved.
//
import UIKit

extension UIView {
    func startActivityIndicator(withBgColor color:UIColor = Colors.white.withAlphaComponent(0.2), withIndicatorColor indColor:UIColor = Colors.blueDefault) {
        let activityView = self.getActivityIndicator(withBgColor:color, withIndicatorColor: indColor)
        self.layoutIfNeeded()
        
        activityView.startSpinning()
        self.bringSubviewToFront(activityView)
    }
    
    func stopActivityIndicator() {
        let activityView = self.getActivityIndicator(withBgColor: nil)
        activityView.stopSpinning()
        
    }
    
    func getActivityIndicator(withBgColor color:UIColor?, withIndicatorColor indColor:UIColor = .gray) -> ActivityIndicatorView {
        if let subview = self.subviews.first(where: { (subview) -> Bool in
            if subview.isKind(of: ActivityIndicatorView.self) {
                return true
            }
            return false
        }), let activityView = subview as? ActivityIndicatorView{
            return activityView
        }
        let activityView = ActivityIndicatorView()
        activityView.backgroundColor = color
        activityView.addActivityIndicator(indicatorColor:indColor)
        self.insertSubviewToBounds(activityView)
        return activityView
    }
    
    func insertSubviewToBounds(_ view:UIView){
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: -self.safeAreaInsets.top).isActive = true
        if self.isKind(of: UITableView.self) {
            view.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0).isActive = true
            view.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0).isActive = true
        }else{
            _ = self.safeAreaInsets
            view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        }
        
    }
}






