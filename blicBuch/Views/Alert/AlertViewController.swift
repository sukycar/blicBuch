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
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var newRegistrationButtonOutlet: UIButton!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBAction func tapRegister(_ sender: Any) {
        dismiss(animated: true) {
            NotificationCenter.default.post(name: RegisterNotificationName, object: nil)
        }
    }
    @IBAction func tapLogin(_ sender: Any) {
        dismiss(animated: true) {
            NotificationCenter.default.post(name: LoginNotificationName, object: nil)
        }
    }
    
    private var viewModel : AlertViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AlertViewModel(model: AlertModel(titleText: AlertViewData.title, bodyText: AlertViewData.bodyText, loginText: AlertViewData.loginButtonText, newRegistrationText: AlertViewData.newRegistrationText, centerText: AlertViewData.centerText))
        configureAlertView()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == mainView {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func configureAlertView(){
        let device = self.view.getDeviceType()
        viewModel.configureAlertView(titleLabel: titleLabel, bodyTextLabel: bodyLabel, centerLabel: separatorLabel, loginButton: loginButtonOutlet, registerButton: newRegistrationButtonOutlet, holderView: holderView, titleLabelView: titleLabelView, deviceType: device)
    }
}
