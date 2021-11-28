//
//  CustomTransition2.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 12.12.20..
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit
final class CustomTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    fileprivate var interactiveDismiss = true
    fileprivate var fromFrame:CGRect?
    fileprivate var snapshot:UIImage?
    fileprivate var viewToHide:UIView?
    init(from presented: UIViewController, to presenting: UIViewController, fromFrame:CGRect?, snapshot:UIImage?, viewToHide:UIView? = nil) {
        self.fromFrame = fromFrame
        self.snapshot = snapshot
        weak var weakViewToHide = viewToHide
        self.viewToHide = weakViewToHide
        super.init()
    }
    func update(frame:CGRect){
        self.fromFrame = frame
    }
    func update(snapshot:UIImage?){
        self.snapshot = snapshot
    }
    // MARK: - UIViewControllerTransitioningDelegate
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Dismisser2(fromFrame:fromFrame, snapshot: snapshot, viewToHide: viewToHide)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let view = InteractiveModalPresentationController2(presentedViewController: presented, presenting: presenting)
        view.viewToHide = self.viewToHide
        return view
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Presenter2(fromFrame: fromFrame, viewToHide: viewToHide)
    }
    
    
}
final class InteractiveModalPresentationController2: UIPresentationController {
    private let presentedYOffset: CGFloat = 25
    private var direction: CGFloat = 0
    private var state: ModalScaleState = .interaction
    private lazy var dimmingView: UIView! = {
        guard let container = containerView else { return nil }

        let view = UIView(frame: container.bounds)
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blur.frame = container.frame
        view.addSubview(blur)
        return view
    }()
    var viewToHide:UIView?

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(pan:)))
//        presentedViewController.view.addGestureRecognizer(panGesture)
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(didEdge(edge:)))
        edgeGesture.edges = .left
        presentedViewController.view.addGestureRecognizer(edgeGesture)
        
    }
    private var _touchPositionInHeaderX:CGFloat = 0
    private var _percentage:CGFloat = 0
    private var dismissAutomatic = false
    @objc private func didEdge(edge: UIPanGestureRecognizer) {
        guard let view = edge.view, let superView = view.superview,
            let presented = presentedView, let container = containerView else { return }

        let location = edge.translation(in: superView)
        let x = edge.location(in: containerView).x

        switch edge.state {
        case .began:
            presented.frame.size.height = container.frame.height
            _touchPositionInHeaderX = edge.location(in: containerView).x
            if _touchPositionInHeaderX > 40 {
                edge.isEnabled = false
            }
        case .changed:
            let velocity = edge.velocity(in: superView)
            switch state {
            case .interaction:
                var trueOffset = x - _touchPositionInHeaderX;
                trueOffset = trueOffset/3
                if trueOffset > 50 {
                    dismissAutomatic = true
                    edge.state = .ended
                }
                if trueOffset >= presentedYOffset {
                    trueOffset = presentedYOffset
                }else if trueOffset < 0 {
                    trueOffset = 0
                }
                let percentage = 1 - (presentedYOffset - trueOffset) / presentedYOffset
                let truePercengate:CGFloat = 1 - percentage *  (0.2)
                _percentage = truePercengate
                UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    presented.transform = CGAffineTransform.init(scaleX: truePercengate, y: truePercengate)
                })
                presented.layer.cornerRadius = CGFloat.minimum(trueOffset, presentedYOffset)
            case .presentation:
                presented.frame.origin.y = location.y
            }
            direction = velocity.y
        case .ended:
            if dismissAutomatic {
                presentedViewController.dismiss(animated: true, completion: nil)
            }else if _percentage >= 0.81{
                changeScale(to: .interaction)
            }else{
                presentedViewController.dismiss(animated: true, completion: nil)
            }
            edge.isEnabled = true
        default:
            edge.isEnabled = true
            break
        }
    }
    @objc private func didPan(pan: UIPanGestureRecognizer) {
        guard let view = pan.view, let superView = view.superview,
            let presented = presentedView, let container = containerView else { return }

        let location = pan.translation(in: superView)
        let x = pan.location(in: containerView).x

        switch pan.state {
        case .began:
            presented.frame.size.height = container.frame.height
            _touchPositionInHeaderX = pan.location(in: containerView).x
            if _touchPositionInHeaderX > 40 {
                pan.isEnabled = false
            }
        case .changed:
            let velocity = pan.velocity(in: superView)
            switch state {
            case .interaction:
                var trueOffset = x - _touchPositionInHeaderX;
                trueOffset = trueOffset/3
                if trueOffset > 50 {
                    dismissAutomatic = true
                    pan.state = .ended
                }
                if trueOffset >= presentedYOffset {
                    trueOffset = presentedYOffset
                }else if trueOffset < 0 {
                    trueOffset = 0
                }
                let percentage = 1 - (presentedYOffset - trueOffset) / presentedYOffset
                let truePercengate:CGFloat = 1 - percentage *  (0.2)
                _percentage = truePercengate
                UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    presented.transform = CGAffineTransform.init(scaleX: truePercengate, y: truePercengate)
                })
                presented.layer.cornerRadius = CGFloat.minimum(trueOffset, presentedYOffset)
            case .presentation:
                presented.frame.origin.y = location.y
            }
            direction = velocity.y
        case .ended:
            if dismissAutomatic {
                presentedViewController.dismiss(animated: true, completion: nil)
            }else if _percentage >= 0.81{
                changeScale(to: .interaction)
            }else{
                presentedViewController.dismiss(animated: true, completion: nil)
            }
            pan.isEnabled = true
        default:
            pan.isEnabled = true
            break
        }
    }

    @objc func didTap(tap: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }

    func changeScale(to state: ModalScaleState) {
        guard let presented = presentedView else { return }

        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            presented.transform = CGAffineTransform.identity

            }, completion: { (isFinished) in
                self.state = state
        })
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else { return .zero }
        return CGRect(x: 0, y: 0, width: container.bounds.width, height: container.bounds.height)
    }

    override func presentationTransitionWillBegin() {
        guard let container = containerView,
            let coordinator = presentingViewController.transitionCoordinator else { return }

        dimmingView.alpha = 0
        container.addSubview(dimmingView)
        dimmingView.addSubview(presentedViewController.view)
        coordinator.animate(alongsideTransition: { [weak self] context in
            guard let `self` = self else { return }
            self.dimmingView.alpha = 1
            }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentingViewController.transitionCoordinator else { return }

        coordinator.animate(alongsideTransition: { [weak self] (context) -> Void in
            guard let `self` = self else { return }
            self.dimmingView.alpha = 0
            }, completion: nil)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.viewToHide?.alpha = 1
            dimmingView.removeFromSuperview()
        }
    }

}
private class Presenter2: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate var fromFrame:CGRect?
    fileprivate var viewToHide:UIView?

    init(fromFrame:CGRect?, viewToHide:UIView?){
        super.init()
        self.fromFrame = fromFrame
        self.viewToHide = viewToHide
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        toView.frame = fromFrame ?? .zero
        do {
            toView.layer.masksToBounds = true
            toView.layer.cornerRadius = 20
        }
        do {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
                toView.frame = container.frame
                toView.layer.cornerRadius = 0
            }) { (completed) in
                UIView.animate(withDuration: 0.1, animations: {
                }) {[weak self] (completed) in
                    self?.viewToHide?.alpha = 0
                    transitionContext.completeTransition(completed)
                }
            }
        }
    }
}

private class Dismisser2: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate var fromFrame:CGRect?
    fileprivate var snapshot:UIImage?
    fileprivate var viewToHide:UIView?

    init(fromFrame:CGRect?, snapshot:UIImage?, viewToHide:UIView?){
        super.init()
        self.fromFrame = fromFrame
        self.snapshot = snapshot
        self.viewToHide = viewToHide
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: .from)!
        let fromViewFrame = fromView.frame
        let fakeImageView:UIImageView = UIImageView(frame: CGRect.zero)
        fakeImageView.backgroundColor = UIColor.clear
        if #available(iOS 13, *){
            let generator = UIImpactFeedbackGenerator(style: .soft)
            generator.impactOccurred()
        } else {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
        
        fakeImageView.frame = CGRect(x: fromViewFrame.origin.x, y: fromViewFrame.origin.y, width: fromViewFrame.size.width, height: fromViewFrame.size.width / 3 * 2)
        container.addSubview(fakeImageView)
        fakeImageView.image = snapshot

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {[weak self] in
            fakeImageView.frame = self?.fromFrame ?? CGRect.zero
            fromView.frame = self?.fromFrame ?? CGRect.zero
            fromView.alpha = 0
        }) { (completed) in
            UIView.animate(withDuration: 0.1, animations: {
                fromView.alpha = 0
            }) { (completed) in
                fakeImageView.removeFromSuperview()
                transitionContext.completeTransition(completed)
            }
        }
    }
}
enum ModalScaleState {
    case presentation
    case interaction
}
