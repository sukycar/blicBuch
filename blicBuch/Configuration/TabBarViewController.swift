//
//  TabBarViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 11/23/19.
//  Copyright © 2019 sukydeveloper. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    var loaderTest:Loaded = .secondTime
    @IBOutlet weak var mainTabBar: UITabBar!
    let customColor = Colors.blueDefault//custom color for various elements
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(loaderTest.itIs)
        
        delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if loaderTest.itIs == true {
            self.view.alpha = 0
            UIView.animate(withDuration: 0.3) {
                self.view.alpha = 1
            }
        }
    }

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    enum Loaded {
        case firstTime
        case secondTime
        
        var itIs: Bool {
            switch self {
            case .firstTime:
                return true
            case .secondTime:
                return false
            }
        }
    }

}
/*
extension TabBarViewController: UITabBarControllerDelegate {

  
     /*Called to allow the delegate to return a UIViewControllerAnimatedTransitioning delegate object for use during a noninteractive tab bar view controller transition.
     ref: https://developer.apple.com/documentation/uikit/uitabbarcontrollerdelegate/1621167-tabbarcontroller*/
     
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabBarAnimatedTransitioning()
    }

}


/*UIViewControllerAnimatedTransitioning.self
 A set of methods for implementing the animations for a custom view controller transition.
 ref: https://developer.apple.com/documentation/uikit/uiviewcontrolleranimatedtransitioning
 */
final class TabBarAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    /*
     Tells your animator object to perform the transition animations.
     */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destination = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }

        destination.alpha = 0.0
        destination.transform = .init(scaleX: 1.5, y: 1.5)
        transitionContext.containerView.addSubview(destination)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            destination.alpha = 1.0
            destination.transform = .identity
        }, completion: { transitionContext.completeTransition($0) })
    }

    /*
     Asks your animator object for the duration (in seconds) of the transition animation.
     */
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

}
*/
extension TabBarViewController: UITabBarControllerDelegate {

//    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return MyTransition(viewControllers: tabBarController.viewControllers)
//    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            let tabViewControllers = tabBarController.viewControllers
            let fromView = tabBarController.selectedViewController?.view
            let toView = viewController.view

            if (fromView == toView) {
                return false
            }
        if let fromView = fromView, let toView = toView, let selectedViewController = tabBarController.selectedViewController, let fromIndex = tabViewControllers?.firstIndex(of: selectedViewController), let toIndex = tabViewControllers?.firstIndex(of: viewController) {
                //        if let vcNav = viewController as? NavigationController, let vc = vcNav.viewControllers.first {
                //            if let nvBar = vcNav.navigationBar as? NavigationBar{
                //                nvBar.offset = 0
                //            }
                //            if let vc = vc as? FeaturedController{
                //                vc.tableView?.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: false)
                //            }else if let vc = vc as? WhatsNewController{
                //                vc.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0), at: .bottom, animated: false)
                //            }else if let vc = vc as? FavoriteController {
                //                vc.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0), at: .bottom, animated: false)
                //            }else if let vc = vc as? ExploreController {
                //                vc.searchYConstraint?.constant = 0
                //                vc.controllerArray.forEach({ (exploreTabController) in
                //                    if let exploreTabController = exploreTabController as? ExploreTabController{
                //                        exploreTabController.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .bottom, animated: false)
                //                    }
                //                })
                //            }
                //        }

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

class MyTransition: NSObject, UIViewControllerAnimatedTransitioning {

    var viewControllers: [UIViewController]?
    let transitionDuration: Double = 1

    init(viewControllers: [UIViewController]?) {
        self.viewControllers = viewControllers
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(transitionDuration)
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let fromView = fromVC.view,
            let fromIndex = getIndex(forViewController: fromVC),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let toView = toVC.view,
            let toIndex = getIndex(forViewController: toVC)
            else {
                transitionContext.completeTransition(false)
                return
        }

        let frame = transitionContext.initialFrame(for: fromVC)
        var fromFrameEnd = frame
        var toFrameStart = frame
        fromFrameEnd.origin.x = toIndex > fromIndex ? frame.origin.x - frame.width : frame.origin.x + frame.width
        toFrameStart.origin.x = toIndex > fromIndex ? frame.origin.x + frame.width : frame.origin.x - frame.width
        toView.frame = toFrameStart

        DispatchQueue.main.async {
            transitionContext.containerView.addSubview(toView)
            UIView.animate(withDuration: self.transitionDuration, animations: {
                fromView.frame = fromFrameEnd
                toView.frame = frame
            }, completion: {success in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(success)
            })
        }
    }

    func getIndex(forViewController vc: UIViewController) -> Int? {
        guard let vcs = self.viewControllers else { return nil }
        for (index, thisVC) in vcs.enumerated() {
            if thisVC == vc { return index }
        }
        return nil
    }
}
