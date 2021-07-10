//
//  ViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 11/17/19.
//  Copyright © 2019 sukydeveloper. All rights reserved.
//

import UIKit
import CoreData
import RxSwift
import Alamofire
import SideMenu
import Kingfisher
import RxCocoa


class HomeViewController : BaseViewController, NSFetchedResultsControllerDelegate {
    
    @IBAction func vipButton(_ sender: Any) {
        if let tabController = UIApplication.shared.windows.first?.rootViewController as? TabBarViewController {
            tabController.view.backgroundColor = Colors.defaultBackgroundColor
            if let vc = tabController.viewControllers?[2] {
                _ = tabController.tabBarController(tabController, shouldSelect: vc)
                vc.presentedViewController?.dismiss(animated: true, completion: nil)
                if let vc = vc as? UINavigationController {
                    vc.popToRootViewController(animated: true)
                }
            }
        }
    }
    @IBOutlet weak var imageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak override var tableView: UITableView! {
        didSet{
            let customCellName = String(describing: BookTableViewCell.self)
            tableView.register(UINib(nibName: customCellName, bundle: nil), forCellReuseIdentifier: customCellName)
            
            let customCell = String(describing: BlueCloudCell.self)
            tableView.register(UINib(nibName: customCell, bundle: nil), forCellReuseIdentifier: customCell)
        }
    }
    @IBAction func menuButtonAction(_ sender: Any) {
        if let vc = (UIApplication.shared.delegate as? AppDelegate)?.getSideMenu() {
            let menu = SideMenuNavigationController(rootViewController: vc)
            menu.leftSide = true
            if self.traitCollection.userInterfaceStyle == .dark {
                menu.settings.blurEffectStyle = .systemMaterialDark
            } else {
                menu.settings.blurEffectStyle = .systemMaterialLight
            }
            menu.pushStyle = .default
            menu.presentationStyle = .menuSlideIn
            menu.presentationStyle.menuOnTop = true
            menu.menuWidth = self.view.frame.size.width * 0.8
            menu.presentationStyle.presentingEndAlpha = 0.5
            menu.statusBarEndAlpha = 0
            menu.presentationStyle.onTopShadowOffset = CGSize(width: 3, height: 0)
            menu.enableSwipeToDismissGesture = true
            menu.dismissWhenBackgrounded = true
            vc.navigationController?.setNavigationBarHidden(true, animated: false)
            present(menu, animated: true, completion: nil)
        }
    }
    
    private let viewModel = HomeControllerViewModel()
    
    // properties for transition
    private var frame : CGRect?
    private var frameView : UIView?
    private var snapshot : UIImage?
    private var transition: CustomTransition?
    
    private var sideMenuController: SideMenuViewController?
    lazy var alertService = AlertService()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissSideMenu), name: NSNotification.Name(rawValue: "enteredBackground"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.performLoginTransition), name: NSNotification.Name("loginHome"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentLoginView), name: LoginNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentRegisterView), name: RegisterNotificationName, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func configureTable() {
        super.configureTable()
        tableView.layer.borderColor = UIColor.gray.cgColor
        tableView.layer.borderWidth = 0.3
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        definesPresentationContext = true
    }
        
    @objc func dismissSideMenu(){
        sideMenuController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func performLoginTransition(){
        let vc = LoginViewController.get()
        let newFrame = CGRect(x: (frame?.origin.x)! + 66, y: (frame?.origin.y)!, width: 30, height: 30)
        self.transition = CustomTransition(from: self, to: vc, fromFrame: newFrame, snapshot: nil, viewToHide: nil)
        vc.transitioningDelegate = self.transition
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentLoginView(){
        let vc = LoginViewController.get()
        vc.modalPresentationStyle = .formSheet
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentRegisterView(){
        let vc = RegisterViewController.get()
        vc.modalPresentationStyle = .formSheet
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - TABLE VIEW FUNCTIONS
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.homeBooks?.count ?? 0
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BlueCloudCell.self), for: indexPath) as! BlueCloudCell
            return cell
            } else {
                let model = viewModel.homeBooks?[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BookTableViewCell.self), for: indexPath) as! BookTableViewCell
                if let item = model  {
                    cell.set(with: item, inVipController: false)
                    print(item.id)
                    cell.cellDelegate = self
                    cell.orderButton.rx.tap.subscribe(onNext: {[weak self] in
                        if let logedIn = blitzBuchUserDefaults.get(.logedIn) as? Bool{
                            var cartItems = blitzBuchUserDefaults.get(.cartItems) as? [String]
                            if logedIn == true {
                                self?.navigationController?.view.startActivityIndicator()
                                BooksService.checkLock(bookId: item.id).subscribe { (locked) in
                                    if locked == true {
                                        if !(cartItems?.contains(String(item.id)) ?? false) {
                                            self?.getAlert(errorString: "Knjiga je vec rezervisana", errorColor: Colors.orange)
                                        } else {
                                            self?.getAlert(errorString: "Knjiga se vec nalazi u korpi", errorColor: Colors.orange)
                                        }
                                    } else {
                                        if item.vip == true {
                                            guard let id = blitzBuchUserDefaults.get(.id) as? Int32 else {return}
                                            UsersService.checkForAvailableBooks(id).subscribe {(vip, regular) in
                                                let vip = vip
                                                let regular = regular
                                                if vip > 0 {
                                                    self?.updateVipBooksNumber(removeBooks: true, numberOfBooks: 1, disposeBag: cell.disposeBag)
                                                        if !(cartItems?.contains(String(item.id)) ?? false) {
                                                            _ = blitzBuchUserDefaults.set(.numberOfRegularBooks, value: regular)
                                                            self?.getAlert(errorString: "Knjiga je dodata u korpu", errorColor: Colors.blueDefault)
                                                            item.locked = LockStatus.locked.rawValue
                                                            cartItems?.append(String(item.id))
                                                            BooksService.lockBook(bookId: item.id, lockStatus: .locked).subscribe { [weak self] (finished) in
                                                                let lockedBookId = (String(item.id))
                                                                self?.lockedBooks.append(lockedBookId)
                                                                var cartBooks = blitzBuchUserDefaults.get(.cartItems) as? [String] ?? [""]
                                                                cartBooks.append(lockedBookId)
                                                                var newCartBooks = cartBooks
                                                                newCartBooks = Array(Set(newCartBooks))
                                                                let clearBooksArray = newCartBooks.filter({return $0 != ""})
                                                                _ = blitzBuchUserDefaults.set(.cartItems, value: clearBooksArray) as! [String]
                                                                UsersService.updateCartBooks(userId: id, bookIDs: clearBooksArray).subscribe { (subscribed) in
                                                                    //
                                                                } onError: { (error) in
                                                                    self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                                                                } onCompleted: {
                                                                    //
                                                                }.disposed(by: cell.disposeBag)

                                                            } onError: { (error) in
                                                                self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                                                            } onCompleted: {
                                                                //
                                                            } onDisposed: {
                                                                //
                                                            }.disposed(by: cell.disposeBag)
                                                        } else {
                                                            self?.getAlert(errorString: "Knjiga se vec nalazi u korpi", errorColor: Colors.orange)
                                                        }

                                                } else {
                                                    if (cartItems?.contains(String(item.id)) ?? false) {
                                                        self?.getAlert(errorString: "Knjiga se vec nalazi u korpi", errorColor: Colors.orange)
                                                    } else {
                                                        self?.getAlert(errorString: "Iskoristili ste limit za vip knjige", errorColor: Colors.orange)
                                                    }
                                                }

                                            } onError: { (error) in
                                                self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                                            } onCompleted: {
                                                //
                                            } onDisposed: {
                                                //
                                            }.disposed(by: cell.disposeBag)
                                        }
                                        if item.vip == false {
                                            guard let id = blitzBuchUserDefaults.get(.id) as? Int32 else {return}
                                            UsersService.checkForAvailableBooks(id).subscribe {(vip, regular) in
                                                let vip = vip
                                                let regular = regular
                                                if regular > 0 {
                                                    self?.updateBooksNumber(removeBooks: true, numberOfBooks: 1, disposeBag: cell.disposeBag)
                                                        if !(cartItems?.contains(String(item.id)) ?? false) {
                                                            _ = blitzBuchUserDefaults.set(.numberOfRegularBooks, value: regular)
                                                            self?.getAlert(errorString: "Knjiga je dodata u korpu", errorColor: Colors.blueDefault)
                                                            item.locked = LockStatus.locked.rawValue
                                                            cartItems?.append(String(item.id))
                                                            BooksService.lockBook(bookId: item.id, lockStatus: .locked).subscribe { [weak self] (finished) in
                                                                let lockedBookId = (String(item.id))
                                                                self?.lockedBooks.append(lockedBookId)
                                                                var cartBooks = blitzBuchUserDefaults.get(.cartItems) as? [String] ?? [""]
                                                                cartBooks.append(lockedBookId)
                                                                var newCartBooks = cartBooks
                                                                newCartBooks = Array(Set(newCartBooks))
                                                                let clearBooksArray = newCartBooks.filter({return $0 != ""})
                                                                _ = blitzBuchUserDefaults.set(.cartItems, value: clearBooksArray) as! [String]
                                                                UsersService.updateCartBooks(userId: id, bookIDs: clearBooksArray).subscribe { (subscribed) in
                                                                    //
                                                                } onError: { (error) in
                                                                    self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                                                                } onCompleted: {
                                                                    //
                                                                }.disposed(by: cell.disposeBag)
                                                            } onError: { (error) in
                                                                self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                                                            } onCompleted: {
                                                                //
                                                            } onDisposed: {
                                                                //
                                                            }.disposed(by: cell.disposeBag)
                                                        } else {
                                                            self?.getAlert(errorString: "Knjiga se vec nalazi u korpi", errorColor: Colors.orange)
                                                        }
                                                } else {
                                                    if (cartItems?.contains(String(item.id)) ?? false) {
                                                        self?.getAlert(errorString: "Knjiga se vec nalazi u korpi", errorColor: Colors.orange)
                                                    } else {
                                                        self?.getAlert(errorString: "Iskoristili ste limit za obicne knjige", errorColor: Colors.orange)
                                                    }
                                                }
                                            } onError: { (error) in
                                                self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                                            } onCompleted: {
                                                //
                                            } onDisposed: {
                                                //
                                            }.disposed(by: cell.disposeBag)
                                        }
                                    }
                                    self?.navigationController?.view.stopActivityIndicator()
                                } onError: { (error) in
                                    self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                                } onCompleted: {
                                    //
                                } onDisposed: {
                                    //
                                }.disposed(by: cell.disposeBag)
                                
                                do {
                                    try DataManager.shared.context.save()
                                } catch {
                                    self?.getAlert(errorString: "Error saving data", errorColor: Colors.orange)
                                }
                            } else {
                                self?.onClick()
                            }
                        }
                    }).disposed(by: cell.disposeBag)
                    
                    return cell
                }
            }
            return UITableViewCell()
    }
    
    @objc func alert () {
        let newAlert = UIAlertController(title: "NOVI", message: "FUCKING CONTROLER", preferredStyle: .alert)
        present(newAlert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()
        if indexPath.section == 0{
            height = 182
        } else {
            height = 200
        }
        return height
    }
}


extension HomeViewController: AlertMe {
    func onClick() {
        let alertVC = alertService.alert()
        present(alertVC, animated: true)
    }
    
}
