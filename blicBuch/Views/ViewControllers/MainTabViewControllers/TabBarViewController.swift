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
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        // Home VC
        let newHomeVC = storyBoard.instantiateViewController(identifier: "BlitzBuchHomeViewController") as? BlitzBuchHomeViewController
        newHomeVC?.viewModel = BlitzBuchHomeViewModel()
        self.viewControllers?[0] = newHomeVC!
        
        // Library VC
        let libraryVC = storyBoard.instantiateViewController(identifier: "BlitzBuchLibraryViewController") as? BlitzBuchLibraryViewController
        libraryVC?.viewModel = BlitzBuchLibraryViewModel()
        self.viewControllers?[1] = libraryVC!
        
        // VIP VC
        let vipVC = storyBoard.instantiateViewController(identifier: "BlitzBuchVipViewController") as? BlitzBuchVipViewController
        vipVC?.viewModel = BlitzBuchVipViewModel()
        self.viewControllers?[2] = vipVC!
        
        // Info VC
        let infoVC = storyBoard.instantiateViewController(identifier: "BlitzBuchInfoViewController") as? BlitzBuchInfoViewController
        infoVC?.viewModel = BlitzBuchInfoViewModel()
        self.viewControllers?[3] = infoVC!
        
        // Search VC
        let searchVC = storyBoard.instantiateViewController(identifier: "BlitzBuchSearchViewController") as? BlitzBuchSearchViewController
        searchVC?.viewModel = BlitzBuchSearchViewModel()
        self.viewControllers?[4] = searchVC!
        
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




