//
//  TabBarViewController + extensions.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 8.3.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import UIKit

extension TabBarViewController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            let tabViewControllers = tabBarController.viewControllers
            let fromView = tabBarController.selectedViewController?.view
            let toView = viewController.view

            if (fromView == toView) {
                return false
            }
        if let fromView = fromView, let toView = toView, let selectedViewController = tabBarController.selectedViewController, let fromIndex = tabViewControllers?.firstIndex(of: selectedViewController), let toIndex = tabViewControllers?.firstIndex(of: viewController) {

                let offScreenRight = CGAffineTransform(translationX: toView.frame.width, y: 0)
                let offScreenLeft = CGAffineTransform(translationX: -toView.frame.width, y: 0)

                // start the toView to the right of the screen
                if (toIndex < fromIndex) {
                    toView.transform = offScreenLeft
                    fromView.transform = offScreenRight
                } else {
                    toView.transform = offScreenRight
                    fromView.transform = offScreenLeft
                }

                fromView.tag = 124
                toView.addSubview(fromView)
                let oldClipsToBounds = toView.clipsToBounds
                toView.clipsToBounds = false
                self.view.isUserInteractionEnabled = false
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
    //                fromView.transform = .identity
                    if (toIndex < fromIndex) {
                        toView.transform = offScreenLeft
                        fromView.transform = offScreenRight
                    } else {
                        toView.transform = offScreenRight
                        fromView.transform = offScreenLeft
                    }
                    toView.transform = CGAffineTransform.identity

                }, completion: { finished in
                    toView.clipsToBounds = oldClipsToBounds
                    let subViews = toView.subviews
                    for subview in subViews{
                        if (subview.tag == 124) {
                            subview.removeFromSuperview()
                        }
                    }
                    viewController.view.layoutIfNeeded()
                    tabBarController.selectedIndex = toIndex
                    self.view.isUserInteractionEnabled = true

                })
            }

            return true
        }
}
