//
//  AlertViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 1/8/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit

let RegisterNotificationName = NSNotification.Name(rawValue: "registerNotification")
let LoginNotificationName = NSNotification.Name(rawValue: "loginNotification")


class AlertViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var titleLabelView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var newRegistrationButtonOutlet: UIButton!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        styleViews()
        // Do any additional setup after loading the view.
    }
    @IBAction func tapRegister(_ sender: Any) {
        dismiss(animated: true){
            NotificationCenter.default.post(name: RegisterNotificationName, object: nil)
        }
    }
    
    @IBAction func tapLogin(_ sender: Any) {
        dismiss(animated: true) {
            NotificationCenter.default.post(name: LoginNotificationName, object: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == mainView {
            dismiss(animated: true, completion: nil)
        }//for dismiss of alert controller when clicked outside alert window
    }
    
    func styleViews(){
        newRegistrationButtonOutlet.backgroundColor = Colors.blueDefault
        newRegistrationButtonOutlet.layer.cornerRadius = CornerRadius.mediumSmall
        loginButtonOutlet.backgroundColor = Colors.blueDefault
        loginButtonOutlet.layer.cornerRadius = CornerRadius.mediumSmall
        holderView.layer.cornerRadius = CornerRadius.medium
        titleLabelView.layer.masksToBounds = true
        titleLabelView.layer.cornerRadius = CornerRadius.medium
        titleLabelView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
}
