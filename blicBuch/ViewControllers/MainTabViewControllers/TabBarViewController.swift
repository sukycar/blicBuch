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
    let customColor = Colors.blueDefault
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(loaderTest.itIs)
        self.view.backgroundColor = Colors.defaultBackgroundColor
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
