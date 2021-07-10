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

class LoadingViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageYConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = blitzBuchUserDefaults.set(.id, value: 0)
        _ = blitzBuchUserDefaults.set(.logedIn, value: false)
        _ = blitzBuchUserDefaults.set(.numberOfRegularBooks, value: 0)
        _ = blitzBuchUserDefaults.set(.numberOfVipBooks, value: 0)
        _ = blitzBuchUserDefaults.set(.username, value: "--")
        _ = blitzBuchUserDefaults.set(.cartItems, value: [""])
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat],
                       animations: {
                        self.imageView.alpha = 0
                       },
                       completion: nil)
        BooksService.getAll().subscribe(onNext: {(finished) in
            if finished {
//                BooksService.getAllCartStatuses().subscribe { (finished) in
//                    //finished
//                    print("Completed filling status id's")
//                } onError: { (error) in
//                    print(error)
//                } onCompleted: {
//                    //
//                } onDisposed: {
//                    //
//                }.disposed(by: self.disposeBag)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                    vc.view.alpha = 0
                    vc.loaderTest = .firstTime
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.setWindow(vc: vc, animated: false)
                    
                }
            }
        }, onError: { (error) in
            self.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
        }, onCompleted: {
            
            //
        }) {
            
        }.disposed(by: self.disposeBag)
        // Do any additional setup after loading the view.
    }
    

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.disposeBag = DisposeBag()
     }
    
}

