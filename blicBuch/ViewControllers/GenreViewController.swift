//
//  GenreTableViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 12/24/19.
//  Copyright © 2019 sukydeveloper. All rights reserved.
//

import UIKit
import CoreData
import RxSwift


class GenreViewController: BaseViewController, NSFetchedResultsControllerDelegate {
    
    private let alertService = AlertService()
    private var book : Book?
    private var booksInGenre = [Book]()
    var genre: Book.Genre = .avantura
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var genreLabel: UIButton!
    @IBAction func back(_ sender: Any) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentLoginView), name: LoginNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentRegisterView), name: RegisterNotificationName, object: nil)
        fetchBooks()
        pictureView.contentMode = .scaleAspectFit
        pictureView.addBottomBorder(color: .gray, margins: 0, borderLineSize: 0.3)
        genreLabel.setTitle(genre.title, for: .normal)
    }
    
    override func configureTable(){
        let customCellName = String(describing: BookTableViewCell.self)
        tableView.register(UINib(nibName: customCellName, bundle: nil), forCellReuseIdentifier: customCellName)
        tableView.tableFooterView = UIView()
    }
    
    func fetchBooks(){
        let context = DataManager.shared.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        let predicate = NSPredicate(format: "genre == %@", genre.title)
        fetchRequest.predicate = predicate
        do {
            let results = try context?.fetch(fetchRequest)
            booksInGenre = results as! [Book]
        } catch let err as NSError {
            print(err.debugDescription)
        }
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksInGenre.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BookTableViewCell.self), for:indexPath) as! BookTableViewCell
        let item = booksInGenre[indexPath.row]
        cell.set(with: item, inVipController: false)
        cell.index = indexPath
        cell.cellDelegate = self
        cell.orderButton.rx.tap.subscribe(onNext: {[weak self] in
            if let logedIn = blicBuchUserDefaults.get(.logedIn) as? Bool{
                var cartItems = blicBuchUserDefaults.get(.cartItems) as? [String]
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
                    self?.onClick()
                }
            }
        }).disposed(by: cell.disposeBag)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()
        height = 182
        return height
    }
}


extension GenreViewController: AlertMe {
    func onClick() {
        let alertVC = alertService.alert()
        self.present(alertVC, animated: true)
    }
}
