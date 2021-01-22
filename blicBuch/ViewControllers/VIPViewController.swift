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

class VIPViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var titleHolderView: UIView!
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            let customCellName = String(describing: CustomCell.self)
            tableView.register(UINib(nibName: customCellName, bundle: nil), forCellReuseIdentifier: customCellName)
        }
    }
    
    var books = [Book]()
    var booksInVip = [Book]()
    var book:Book?
    let alertService = AlertService()
    var testUser = User()
    var lockedBooks = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        
        titleHolderView.addBottomBorder(color: .gray, margins: 0, borderLineSize: 0.3)
        tableView.delegate = self
        tableView.dataSource = self
        
        for book in books {
            if book.vip == true{
                booksInVip.append(book)
            }
        }
        let customCellName = String(describing: CustomCell.self)
        tableView.register(UINib(nibName: customCellName, bundle: nil), forCellReuseIdentifier: customCellName)
    }
    
    func fetch(){
        let context = DataManager.shared.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        
        do {
            let results = try context?.fetch(fetchRequest)
            let booksCreated = results as! [Book]
            
            for _booksCreated in booksCreated {
                books.append(_booksCreated)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
}

extension VIPViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksInVip.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = booksInVip[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomCell.self), for: indexPath) as! CustomCell
        cell.set(with: item, inVipController: true)
        cell.cellDelegate = self
        cell.index = indexPath
        cell.orderButton.rx.tap.subscribe(onNext: {[weak self] in
            if let logedIn = blicBuchUserDefaults.get(.logedIn) as? Bool{
                var cartItems = blicBuchUserDefaults.get(.cartItems) as? [String]
                if logedIn == true {
                    //                    let request = CartBook.fetchRequest() as NSFetchRequest
                    //                    request.predicate = NSPredicate(format: "id == %d", item.id)
                    //                    let fetchedCartBooks = try! DataManager.shared.context.fetch(request)
                    //                    let cartBook = fetchedCartBooks.first
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
                                guard let id = blicBuchUserDefaults.get(.id) as? Int32 else {return}
                                UsersService.checkForAvailableBooks(id).subscribe {(vip, regular) in
                                    let vip = vip
                                    let regular = regular
                                    if vip > 0 {
                                        self?.updateBooksNumber(vip: true, removeBooks: true, numberOfBooks: 1, disposeBag: cell.disposeBag)
                                        if !(cartItems?.contains(String(item.id)) ?? false) {
                                            _ = blicBuchUserDefaults.set(.numberOfRegularBooks, value: regular)
                                            self?.getAlert(errorString: "Knjiga je dodata u korpu", errorColor: Colors.blueDefault)
                                            item.locked = LockStatus.locked.rawValue
                                            cartItems?.append(String(item.id))
                                            BooksService.lockBook(bookId: item.id, lockStatus: .locked).subscribe { [weak self] (finished) in
                                                let lockedBookId = (String(item.id))
                                                self?.lockedBooks.append(lockedBookId)
                                                var cartBooks = blicBuchUserDefaults.get(.cartItems) as? [String] ?? [""]
                                                cartBooks.append(lockedBookId)
                                                var newCartBooks = cartBooks
                                                newCartBooks = Array(Set(newCartBooks))
                                                let clearBooksArray = newCartBooks.filter({return $0 != ""})
                                                _ = blicBuchUserDefaults.set(.cartItems, value: clearBooksArray) as! [String]
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
                                guard let id = blicBuchUserDefaults.get(.id) as? Int32 else {return}
                                UsersService.checkForAvailableBooks(id).subscribe {(vip, regular) in
                                    let vip = vip
                                    let regular = regular
                                    if regular > 0 {
                                        self?.updateBooksNumber(vip: false, removeBooks: true, numberOfBooks: 1, disposeBag: cell.disposeBag)
                                        if !(cartItems?.contains(String(item.id)) ?? false) {
                                            _ = blicBuchUserDefaults.set(.numberOfRegularBooks, value: regular)
                                            self?.getAlert(errorString: "Knjiga je dodata u korpu", errorColor: Colors.blueDefault)
                                            item.locked = LockStatus.locked.rawValue
                                            //                                                cartBook?.inCart = true
                                            cartItems?.append(String(item.id))
                                            BooksService.lockBook(bookId: item.id, lockStatus: .locked).subscribe { [weak self] (finished) in
                                                let lockedBookId = (String(item.id))
                                                self?.lockedBooks.append(lockedBookId)
                                                var cartBooks = blicBuchUserDefaults.get(.cartItems) as? [String] ?? [""]
                                                cartBooks.append(lockedBookId)
                                                var newCartBooks = cartBooks
                                                newCartBooks = Array(Set(newCartBooks))
                                                let clearBooksArray = newCartBooks.filter({return $0 != ""})
                                                _ = blicBuchUserDefaults.set(.cartItems, value: clearBooksArray) as! [String]
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
                    self?.onClick(index: 1)
                }
            }
        }).disposed(by: cell.disposeBag)
        
        return cell
        
    }
    
    @objc func alert () {
        let newAlert = UIAlertController(title: "NOVI", message: "FUCKING CONTROLER", preferredStyle: .alert)
        present(newAlert, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()
        height = 182
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension VIPViewController: AlertMe {
    func onClick(index: Int) {
        let alertVC = alertService.alert()
        self.present(alertVC, animated: true)
    }
}
