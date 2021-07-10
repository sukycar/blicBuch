//
//  TabBarViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 11/23/19.
//  Copyright © 2019 sukydeveloper. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    
    @IBOutlet weak var mainTabBar: UITabBar!
    var loaderTest:Loaded = .secondTime
    
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




