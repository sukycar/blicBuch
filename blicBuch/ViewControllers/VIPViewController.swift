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
            let request = CartBook.fetchRequest() as NSFetchRequest
            request.predicate = NSPredicate(format: "id == %d", item.id)
            let fetchedCartBooks = try! DataManager.shared.context.fetch(request)
            let cartBook = fetchedCartBooks.first
            self?.navigationController?.view.startActivityIndicator()
            BooksService.checkLock(bookId: item.id).subscribe { (locked) in
                if locked == true {
                    if cartBook?.inCart == false {
                    self?.getAlert(errorString: "Knjiga je vec rezervisana", errorColor: Colors.orange)
                    } else {
                        self?.getAlert(errorString: "Knjiga se vec nalazi u korpi", errorColor: Colors.orange)
                    }
                } else {
                    if item.vip == true {
                        if let vipBooks = blicBuchUserDefaults.get(.numberOfVipBooks) as? Int {
                            if vipBooks > 0 {
                                if cartBook?.inCart == false {
                                    cartBook?.inCart = true
                                    _ = blicBuchUserDefaults.set(.numberOfVipBooks, value: vipBooks - 1)
                                    self?.getAlert(errorString: "Knjiga je dodata u korpu", errorColor: Colors.blueDefault)
                                    item.locked = LockStatus.locked.rawValue
                                    BooksService.lockBook(bookId: item.id, lockStatus: .locked).subscribe { [weak self] (finished) in
                                        print(finished.description)
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
                                if cartBook?.inCart == true {
                                    self?.getAlert(errorString: "Knjiga se vec nalazi u korpi", errorColor: Colors.orange)
                                } else {
                                    self?.getAlert(errorString: "Iskoristili ste limit za VIP knjige", errorColor: Colors.orange)
                                }
                            }
                        }
                    }
                    if item.vip == false {
                        if let books = blicBuchUserDefaults.get(.numberOfRegularBooks) as? Int {
                            if books > 0 {
                                if cartBook?.inCart == false {
                                    cartBook?.inCart = true
                                    _ = blicBuchUserDefaults.set(.numberOfRegularBooks, value: books - 1)
                                    self?.getAlert(errorString: "Knjiga je dodata u korpu", errorColor: Colors.blueDefault)
                                    item.locked = LockStatus.locked.rawValue
                                    BooksService.lockBook(bookId: item.id, lockStatus: .locked).subscribe { [weak self] (finished) in
                                        print(finished.description)
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
                                if cartBook?.inCart == true {
                                    self?.getAlert(errorString: "Knjiga se vec nalazi u korpi", errorColor: Colors.orange)
                                } else {
                                    self?.getAlert(errorString: "Iskoristili ste limit za obicne knjige", errorColor: Colors.orange)
                                }
                            }
                        }
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
        //        let availableBooks = blicBuchUserDefaults.get(.numberOfVipBooks)
        //        let selectedVipBooks = blicBuchUserDefaults.get(.selectedVipBooks)
        //        let selectedBooksString = selectedVipBooks as? String
        //        let availableBooksString = availableBooks as? String
        //        let selectedBooks = Int(selectedBooksString ?? "0") ?? 0
        //        let availableVipBooks = Int(availableBooksString ?? "0") ?? 0
        //        if selectedBooks >= availableVipBooks {
        //            print("Previse izabrano")
        //            print(selectedBooks.description)
        //            let alertController = UIAlertController.init(title: "PREKORACEN LIMIT", message: "Prekoracili ste limit za VIP knjige. Kontaktirajte nas klub.", preferredStyle: .alert)
        //            alertController.addAction(.init(title: "OK", style: .default, handler: { (action) in
        //                print("Closed")
        //            }))
        //            self.present(alertController, animated: true, completion: nil)
        ////        let alertVC = alertService.alert()
        ////        present(alertVC, animated: true)
        //        } else {
        //            let addedValue = String(selectedBooks + 1)
        //            _ = blicBuchUserDefaults.set(.selectedVipBooks, value: addedValue)
        //            print(selectedBooks)
        //            print("Ovde ubaciti funkciju za popunjavanje cart-a")
        //        }
    }//alert for table cell button
    
}
