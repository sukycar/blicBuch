//
//  VIPViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 1/2/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit
import MessageUI
import CoreData
import RxSwift
import Alamofire

class VIPViewController: BaseViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleHolderView: UIView!

    private let vipViewModel = VipViewControllerViewModel()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        self.isVipController = true
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentLoginView), name: LoginNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentRegisterView), name: RegisterNotificationName, object: nil)
    }
    
    

//    func configureTable() {
//        let customCellName = String(describing: BookTableViewCell.self)
//        tableView.register(UINib(nibName: customCellName, bundle: nil), forCellReuseIdentifier: customCellName)
//    }
    
    func styleViews() {

    }

    
    // MARK: - TABLE VIEW
    
    
    @objc func alert () {
        let newAlert = UIAlertController(title: "NOVI", message: "FUCKING CONTROLER", preferredStyle: .alert)
        present(newAlert, animated: true)
    }
    

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension VIPViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vipViewModel.vipBooks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let item = vipViewModel.vipBooks?[indexPath.row] {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BookTableViewCell.self), for: indexPath) as! BookTableViewCell
            cell.set(with: item, inVipController: true)
        cell.cellDelegate = self
        cell.orderButton.rx.tap.subscribe(onNext: {[weak self] in
            if let logedIn = blitzBuchUserDefaults.get(.logedIn) as? Bool{
                var cartItems = blitzBuchUserDefaults.get(.cartItems) as? [String]
                if logedIn == true {
                    //                    let request = CartBook.fetchRequest() as NSFetchRequest
                    //                    request.predicate = NSPredicate(format: "id == %d", item.id)
                    //                    let fetchedCartBooks = try! DataManager.shared.context.fetch(request)
                    //                    let cartBook = fetchedCartBooks.first
                    self?.navigationController?.view.startActivityIndicator()
                    BooksService.checkLock(bookId: item.id).subscribe { (locked) in
                        if locked == true {
                            if !(cartItems?.contains(String(item.id)) ?? false) {
                                self?.getAlert(errorString: NSLocalizedString("Book is already reserved", comment: ""), errorColor: Colors.orange)
                            } else {
                                self?.getAlert(errorString: NSLocalizedString("Book is already in cart", comment: ""), errorColor: Colors.orange)
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
                                            self?.getAlert(errorString: NSLocalizedString("Book is added to cart", comment: ""), errorColor: Colors.blueDefault)
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
                                            self?.getAlert(errorString: NSLocalizedString("Book is already in cart", comment: ""), errorColor: Colors.orange)
                                        }
                                        
                                    } else {
                                        if (cartItems?.contains(String(item.id)) ?? false) {
                                            self?.getAlert(errorString: NSLocalizedString("Book is already in cart", comment: ""), errorColor: Colors.orange)
                                        } else {
                                            self?.getAlert(errorString: NSLocalizedString("You have used the limit for vip books", comment: ""), errorColor: Colors.orange)
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
                                            self?.getAlert(errorString: NSLocalizedString("Book is added to cart", comment: ""), errorColor: Colors.blueDefault)
                                            item.locked = LockStatus.locked.rawValue
                                            //                                                cartBook?.inCart = true
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
                                            self?.getAlert(errorString: NSLocalizedString("Book is already in cart", comment: ""), errorColor: Colors.orange)
                                        }
                                        
                                    } else {
                                        if (cartItems?.contains(String(item.id)) ?? false) {
                                            self?.getAlert(errorString: NSLocalizedString("Book is already in cart", comment: ""), errorColor: Colors.orange)
                                        } else {
                                            self?.getAlert(errorString: NSLocalizedString("You have used the limit for regular books", comment: ""), errorColor: Colors.orange)
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
        } else {
            return UITableViewCell()
        }
        
    }
    

}

extension VIPViewController{
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
}

extension VIPViewController: AlertMe {
    func onClick() {
    }
    
    func onLoggedOutClick() {
        let alertVC = self.alertService.alert()
        self.present(alertVC, animated: true)
    }
}
