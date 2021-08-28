//
//  LoginViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 11/27/19.
//  Copyright © 2019 sukydeveloper. All rights reserved.
//

import UIKit
import RxSwift

protocol LoadName {
    func changeName(name: String)
}

class LoginViewController: UIViewController {
    
    private var deviceType : DeviceType?
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var email: UITextField!
    private var emailText = String()
    @IBOutlet weak var password: UITextField!
    private var passwordText = String()
    @IBAction func loginButton(_ sender: Any) {
        guard let emailText = email.text else { return }
        guard let passwordText = password.text else { return }
    }
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleViews()
    }
    
    func styleViews(){
        deviceType = self.view.getDeviceType()
        self.title = "Einloggen"
        loginButtonOutlet.layer.cornerRadius = CornerRadius.medium
        loginButtonOutlet.backgroundColor = deviceType != .macCatalyst ? Colors.blueDefault : .clear
        loginButtonOutlet.setTitle("Einloggen", for: .normal)
        loginButtonOutlet.setTitleColor(deviceType != .macCatalyst ? Colors.white : Colors.defaultFontColor, for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.disposeBag = DisposeBag()
    }
    
}

extension LoginViewController{
    class func get() -> LoginViewController {
        return  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    }
}

