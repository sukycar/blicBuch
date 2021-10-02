//
//  BaseViewController.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 17.7.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import UIKit
import FirebaseAuth
import KeychainAccess

class BaseViewController: UIViewController {
    
    // MARK: - Internal Vars & Lets
    
    internal lazy var isVipController : Bool = false
    
    internal lazy var keychainServices = KeychainServices(keychain:
                                                            Keychain(service: "BlitzBuch.blitzBuch"))
    
    internal lazy var blitzBuchUserDefaults = BlitzBuchUserDefaults(userDefaults: UserDefaults.standard)
    lazy var alertService = AlertService()

//    internal lazy var userDefaultsService = UserDefaultsService(userDefaults: UserDefaults.standard)
    
    /// Array of locked books id's on server.
    /// When locked, book can't be selected from other device or user
    internal var lockedBooks = [String]()
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Public methods
    
    func handleError(error: CustomError) {
        switch error {
        case .general(let alertMessage):
            self.showAlert(alertMessage: alertMessage)
        case .unauthorized:
            self.showAlert(message: "User session token has expired. Please login again")
        case .forbidden:
            self.showAlert(message: "Forbidden, you are not allowed to call this method")
        case .internalError:
            self.showAlert(message: "Internal server error, something wrong and unhandled happened on API")
        case .validation(let alertMessage):
            self.showAlert(alertMessage: alertMessage)
        case .register(let alertMessage):
            self.showAlert(message: alertMessage.body)
        }
    }
    
    func logout() {
        self.handleForceLogout()
    }
    // MARK: - Private methods
    
    private func handleForceLogout() {
        self.keychainServices.logout()
        self.logoutUser()
//        self.userDefaultsService.logout()
        NotificationCenter.default.post(name: NSNotification.Name(Constants.userLogout),
                                        object: nil)
    }
    
    func logoutUser() {
        // call from any screen
        
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BlitzBuchLoginViewController") as! BlitzBuchLoginViewController
        vc.viewModel = BlitzBuchLoginViewModel(keychainServices: self.keychainServices)
        vc.onRegister = {
            let registerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BlitzBuchRegisterViewController") as! BlitzBuchRegisterViewController
            registerVC.viewModel = BlitzBuchRegisterViewModel(keychainServices: self.keychainServices)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.setWindow(vc: registerVC, animated: true)
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        UIView.animate(withDuration: 0.3) {
            appDelegate.setWindow(vc: vc, animated: true)
        }
    }
}
