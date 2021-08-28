//
//  ActivityIndicatorView.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 14.12.20..
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ActivityIndicatorView: UIView {
    var counter = 0
    var activityIndicator:NVActivityIndicatorView!
    private lazy var blurVibrancy:UIVisualEffectView = {
        if #available(iOS 13.0, *) {
            return UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        } else {
            return UIVisualEffectView(effect: UIBlurEffect(style: .light))
        }
    }()

    
    func addActivityIndicator(indicatorColor indColor:UIColor) {
        let holderView = UIView()
        self.addSubview(blurVibrancy)
        blurVibrancy.translatesAutoresizingMaskIntoConstraints = false
        blurVibrancy.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        blurVibrancy.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        blurVibrancy.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        blurVibrancy.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.addSubview(holderView)
        holderView.backgroundColor = UIColor.white
        holderView.translatesAutoresizingMaskIntoConstraints = false
        holderView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        holderView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        holderView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        holderView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        self.style(Styles.ActivityIndicator.activityIndicatorBg())
        let processingLabel = UILabel()
        processingLabel.textAlignment = .center
        processingLabel.text = NSLocalizedString("Processing...", comment: "")
//        processingLabel.style(Styles.ActivityIndicator.activityIndicator())
        holderView.addSubview(processingLabel)
        processingLabel.translatesAutoresizingMaskIntoConstraints = false
        processingLabel.leftAnchor.constraint(equalTo: holderView.leftAnchor, constant: 5).isActive = true
        processingLabel.rightAnchor.constraint(equalTo: holderView.rightAnchor, constant: -5).isActive = true
        processingLabel.topAnchor.constraint(equalTo: holderView.topAnchor, constant: 15).isActive = true

        self.activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 90, height: 50), type: NVActivityIndicatorType.audioEqualizer, color: indColor, padding: nil)
        
        holderView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: processingLabel.bottomAnchor, constant: 0).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: holderView.bottomAnchor, constant: -15).isActive = true
        activityIndicator.startAnimating()
    }
    
    func startSpinning() {
        counter += 1
        if counter == 1 {
            UIView.animate(withDuration: 0.3, delay: 0, options:[] /*.transitionCrossDissolve*/, animations: {
                self.alpha = 1
            }) { (finished) in
                self.activityIndicator?.startAnimating()
            }
        }
    }
    
    func stopSpinning() {
        counter = counter > 0 ? counter - 1 : counter
        if counter <= 0 {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, delay: 0, options: []/*.transitionCrossDissolve*/, animations: {
                    self.alpha = 0
                }) {(finished) in
                    self.activityIndicator?.stopAnimating()
                }
            }
        }
    }

}
