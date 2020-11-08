//
//  AlertViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 1/8/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func tapRegister(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapLogin(_ sender: Any) {
        dismiss(animated: true) {
            print("Login uspeo")
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == mainView {
            dismiss(animated: true, completion: nil)
        }//for dismiss of alert controller when clicked outside alert window
    }
    

}
