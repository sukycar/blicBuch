//
//  LoadingViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 6/20/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit
import RxSwift
import CoreData
import Alamofire
import KeychainAccess

class LoadingViewController: UIViewController {
    
    internal lazy var keychainServices = KeychainServices(keychain:
                                                            Keychain(service: "blitzBuch"))
    var disposeBag = DisposeBag()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageYConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = BlitzBuchUserDefaults(userDefaults: UserDefaults.standard)
        if let user = userDefaults.getUser() {
            user.id = 0
            user.numberOfRegularBooks = 0
            user.numberOfVipBooks = 0
            user.name = "--"
            user.cartItems = ""
            userDefaults.saveUser(user)
        }
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat],
                       animations: {
                        self.imageView.alpha = 0
                       },
                       completion: nil)
        BooksService.getAll().subscribe(onNext: {(finished) in
            if finished {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.goToLogin()
                }
            }
        }, onError: { (error) in
            self.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
        }, onCompleted: {
        }) {
        }.disposed(by: self.disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.disposeBag = DisposeBag()
    }
    
    private func goToLogin() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BlitzBuchLoginViewController") as! BlitzBuchLoginViewController
        vc.viewModel = BlitzBuchLoginViewModel(keychainServices: self.keychainServices)
        vc.onRegister = {
            let registerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BlitzBuchRegisterViewController") as! BlitzBuchRegisterViewController
            registerVC.viewModel = BlitzBuchRegisterViewModel(keychainServices: self.keychainServices)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.setWindow(vc: registerVC, animated: true)
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setWindow(vc: vc, animated: false)
    }
}
