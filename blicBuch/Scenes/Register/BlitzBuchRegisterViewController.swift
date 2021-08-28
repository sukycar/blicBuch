//
//  BlitzBuchRegisterViewController.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 28.7.21..
//  Copyright (c) 2021 Vladimir Sukanica. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol BlitzBuchRegisterViewControllerProtocol: AnyObject {
    
}

class BlitzBuchRegisterViewController: UIViewController, BlitzBuchRegisterViewControllerProtocol {
    
    // MARK: - Vars & Lets
    
    private var customView: BlitzBuchRegisterView! {
        loadViewIfNeeded()
        return view as? BlitzBuchRegisterView
    }
    var viewModel: BlitzBuchRegisterViewModelProtocol?
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customView.setup()
        self.bindViewModel()
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        
    }
    
}
