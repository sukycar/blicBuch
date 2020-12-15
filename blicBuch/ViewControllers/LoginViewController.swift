//
//  LoginViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 11/27/19.
//  Copyright © 2019 sukydeveloper. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func loginButton(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

}

extension LoginViewController{
    class func get() -> LoginViewController {
        return  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    }
}

