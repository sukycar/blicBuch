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
let disposeBag = DisposeBag()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageYConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
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
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                    vc.view.alpha = 0
                    vc.loaderTest = .firstTime
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.setWindow(vc: vc, animated: false)
                    
            }
                print("Finished")
            }
                                   }, onError: { (error) in
        print(error)
                                  }, onCompleted: {
                                    
        print("SUCESSSSSS")
                                   }) {

        }.disposed(by: self.disposeBag)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

