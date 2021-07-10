//
//  CartTableView.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 7/12/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit
import CoreData
import MessageUI
import RxSwift
import RxCocoa

class CartViewController: BaseViewController, MFMailComposeViewControllerDelegate, NSFetchedResultsControllerDelegate {
    
    func fetchBooks(){
        let fetchRequest = Book.fetchRequest() as NSFetchRequest
        idArray = blitzBuchUserDefaults.get(.cartItems) as? [String] ?? [""]
        var idArraySequence = [Int32]()
        idArray.forEach { (string) in
            idArraySequence.append(Int32(string) ?? 0)
        }
        let predicate = NSPredicate(format: "id IN %@", idArraySequence)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        fetchRequest.predicate = predicate
        do {
            self.booksInCart = try context?.fetch(fetchRequest)
        } catch {
            self.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.stopActivityIndicator()
        }
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    lazy var alertService = AlertService()
    var booksInCart: [Book]?
    //    private var booksFiltered: [Book] = [Book]()
    private let context = DataManager.shared.context
    private var idArray = [String]()
    private let userId = blitzBuchUserDefaults.get(.id) as? Int32 ?? 0
    
    var cartItemsNumber = Int()
    var cartCountObserver = PublishSubject<Int>()
    var titleHolderView : UIView?
    var label : UILabel?
    var disposeBag = DisposeBag()
    let screenHeight = UIScreen.main.bounds.height
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(dismissController), name: NSNotification.Name(rawValue: "paidTransport"), object: nil)
        self.fetchBooks()
        self.cartItemsNumber = booksInCart?.count ?? 0
        self.title = "Cart"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchBooks()
        self.tableView?.reloadData()
    }
    
    
    override func configureTable(){
        let customCellName = String(describing: BookTableViewCell.self)
        let orderCellName = String(describing: OrderTableViewCell.self)
        tableView?.register(UINib(nibName: customCellName, bundle: nil), forCellReuseIdentifier: customCellName)
        tableView?.register(UINib(nibName: orderCellName, bundle: nil), forCellReuseIdentifier: orderCellName)
        tableView?.register(UINib(nibName: String(describing: EmptyTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: EmptyTableViewCell.self))
        self.tableView?.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return booksInCart?.count ?? 1
        } else {
            return 1
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if booksInCart?.count ?? 0 > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BookTableViewCell.self), for: indexPath) as! BookTableViewCell
                let book = booksInCart?[indexPath.row]
                cell.set(with: book ?? Book(), inVipController: false)
                cell.orderButton.setImage(UIImage(named: "img_remove"), for: .normal)
                cell.orderButton.translatesAutoresizingMaskIntoConstraints = false
                cell.orderButton.imageEdgeInsets = UIEdgeInsets(top: 2.5, left: 2, bottom: 2.5, right: 2)
                cell.orderButton.clipsToBounds = true
                cell.orderButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
                cell.orderButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
                cell.orderButton.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -20).isActive = true
                cell.orderButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -20).isActive = true
                cell.orderButton.rx.tap.subscribe (onNext: {[weak self] in
                    self?.view.startActivityIndicator()
                    self?.cartItemsNumber -= 1
                    self?.cartCountObserver.onNext(self?.cartItemsNumber ?? 0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                        guard let id = blitzBuchUserDefaults.get(.id) as? Int32 else {return}
                        UsersService.checkForAvailableBooks(id).subscribe {(vip, regular) in
                            let vip = vip
                            let regular = regular
                            let id = blitzBuchUserDefaults.get(.id)
                            
                            //function for updating number of available books
                            let vipStatus = book?.vip
                            if vipStatus == true {
                            self?.updateVipBooksNumber(removeBooks: false, numberOfBooks: 1, disposeBag: cell.disposeBag)
                            } else {
                                self?.updateBooksNumber(removeBooks: false, numberOfBooks: 1, disposeBag: cell.disposeBag)
                            }
                        } onError: { (error) in
                            self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                        } onCompleted: {
                            //
                        } onDisposed: {
                            //
                        }.disposed(by: cell.disposeBag)
                        BooksService.lockBook(bookId: book?.id ?? 0, lockStatus: .unlocked).subscribe { (subscribed) in
                            //
                        } onError: { (error) in
                            self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                        } onCompleted: {
                            //
                        }.disposed(by: cell.disposeBag)
                    }
                    
                    self?.idArray.forEach({ (bookId) in
                        if bookId == String(book?.id ?? 0){
                            self?.idArray.removeAll(where: { (string) -> Bool in
                                string == bookId
                            })
                            _ = blitzBuchUserDefaults.set(.cartItems, value: self?.idArray)
                            self?.fetchBooks()
                        }
                    })
                    UsersService.updateCartBooks(userId: self?.userId ?? 0, bookIDs: self?.idArray ?? [""]).subscribe { (updated) in
                        //
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                        self?.view.stopActivityIndicator()
                        
                    } onError: { (error) in
                        self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                    } onCompleted: {
                        //
                    }.disposed(by: cell.disposeBag)
                    
                }).disposed(by: cell.disposeBag)
                return cell
            } else {
                return UITableViewCell()
            }
        } else if indexPath.section == 1 {
            if booksInCart?.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: (String(describing: EmptyTableViewCell.self)), for: indexPath) as! EmptyTableViewCell
                cell.set("Nema itema u korpi")
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OrderTableViewCell.self), for: indexPath) as! OrderTableViewCell
            cell.orderButton.rx.tap.subscribe(onNext: {[weak self] in
                guard let strongSelf = self else {return}
                let alert = strongSelf.alertService.get(with: .orderBooks)
                strongSelf.present(alert, animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && booksInCart?.count == 0 {
            return self.view.frame.size.height
        }
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = Colors.defaultBackgroundColor
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if booksInCart?.count ?? 0 > 0 {
                return self.view.safeAreaInsets.top
            } else {
                return 0
            }
        }
        return 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.disposeBag = DisposeBag()
    }
    
    @objc func dismissController(){
        self.dismiss(animated: true) {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.booksInCart?.forEach({ (book) in
                BooksService.deleteBook(bookId: Int(book.id)).subscribe { (finished) in
                    if finished {
                        BooksService.getAll().subscribe { (finished) in
                            if finished {
                                print("Books refreshed")
                            }
                        } onError: { (error) in
                            strongSelf.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                        } onCompleted: {
                            //
                        } onDisposed: {
                            //
                        }.disposed(by: self?.disposeBag ?? DisposeBag())
                    }
                } onError: { (error) in
                    strongSelf.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                } onCompleted: {
                    //
                } onDisposed: {
                    //
                }.disposed(by: self?.disposeBag ?? DisposeBag())
            })
        }
    }
}

extension CartViewController{
    class func get() -> CartViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartTableView") as! CartViewController
        vc.view.startActivityIndicator()
        return vc
    }
}


