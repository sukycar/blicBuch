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

class CartTableView: UITableViewController, MFMailComposeViewControllerDelegate, NSFetchedResultsControllerDelegate {
    

//    lazy var booksFetch: NSFetchedResultsController<Book> = {
//        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
//        idArray = blicBuchUserDefaults.get(.cartItems) as? [String] ?? [""]
//        var idArraySequence = [Int32]()
//        idArray.forEach { (string) in
//            idArraySequence.append(Int32(string) ?? 0)
//        }
//        let predicate = NSPredicate(format: "id IN %@", idArraySequence)
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        fetchRequest.predicate = predicate
//        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataManager.shared.context, sectionNameKeyPath: nil, cacheName: nil)
//        fetchedResultsController.delegate = self
//        //        booksInCart = fetchedResultsController.fetchedObjects
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//            self.view.stopActivityIndicator()
//        }
//        
//        return fetchedResultsController
//    }()
    func fetchBooks(){
        let fetchRequest = Book.fetchRequest() as NSFetchRequest
        idArray = blicBuchUserDefaults.get(.cartItems) as? [String] ?? [""]
        var idArraySequence = [Int32]()
        idArray.forEach { (string) in
            idArraySequence.append(Int32(string) ?? 0)
        }
        let predicate = NSPredicate(format: "id IN %@", idArraySequence)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        fetchRequest.predicate = predicate
        do {
            booksInCart = try context?.fetch(fetchRequest)
        } catch {
            self.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.stopActivityIndicator()
        }
    }
    private let alertService = AlertService()
    var booksInCart: [Book]?
    //    private var booksFiltered: [Book] = [Book]()
    private let context = DataManager.shared.context
    private var idArray = [String]()
    private let userId = blicBuchUserDefaults.get(.id) as? Int32 ?? 0
    
    var titleHolderView : UIView?
    var label : UILabel?
    var disposeBag = DisposeBag()
    let screenHeight = UIScreen.main.bounds.height
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(dismissController), name: NSNotification.Name(rawValue: "paidTransport"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logedOut), name: NSNotification.Name(rawValue: "logedOut"), object: nil)
        tableView.delegate = self
        tableView.dataSource = self
        self.fetchBooks()
        configureTable()
        let customCellName = String(describing: CustomCell.self)
        let orderCellName = String(describing: OrderTableViewCell.self)
        tableView.register(UINib(nibName: customCellName, bundle: nil), forCellReuseIdentifier: customCellName)
        tableView.register(UINib(nibName: orderCellName, bundle: nil), forCellReuseIdentifier: orderCellName)
        tableView.register(UINib(nibName: String(describing: EmptyTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: EmptyTableViewCell.self))
        self.title = "CART"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchBooks()
        self.tableView.reloadData()
        
        
    }
    // MARK: - Table view data source
    
    func configureTable(){
        self.tableView.tableFooterView = UIView()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
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
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomCell.self), for: indexPath) as! CustomCell
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
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                        guard let id = blicBuchUserDefaults.get(.id) as? Int32 else {return}
                        UsersService.checkForAvailableBooks(id).subscribe {(vip, regular) in
                            let vip = vip
                            let regular = regular
                            let id = blicBuchUserDefaults.get(.id)
                            
                            //function for updating number of available books
                            let vipStatus = book?.vip
                            self?.updateBooksNumber(vip: vipStatus ?? false, removeBooks: false, numberOfBooks: 1, disposeBag: cell.disposeBag)
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
                            _ = blicBuchUserDefaults.set(.cartItems, value: self?.idArray)
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && booksInCart?.count == 0 {
            return self.view.frame.size.height
        }
        return tableView.estimatedRowHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        titleHolderView = UIView()
        label = UILabel(frame: CGRect(x: 20, y: screenHeight > 800 ? 60 : 50, width: self.view.frame.size.width, height: 50))
        titleHolderView?.tintColor = Colors.defaultFontColor
        titleHolderView?.backgroundColor = .systemBackground
        titleHolderView?.addSubview(label ?? UILabel())
        let attributes = [NSAttributedString.Key.font:UIFont(name: FontName.regular.value, size: FontSize.navigationTitle) ?? UIFont.systemFont(ofSize: FontSize.navigationTitle) ] as [NSAttributedString.Key : Any]
        let attributedString = NSAttributedString(string: "Cart", attributes: attributes)
        label?.attributedText = NSAttributedString(attributedString: attributedString)
        titleHolderView?.addBottomBorder(color: .gray, margins: 0, borderLineSize: 0.3)
        if section == 0 {
            return titleHolderView
        }
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && booksInCart?.count ?? 0 > 0 {
            if screenHeight > 800 {
                return 100
            } else {
                return 90
            }
        }
        return 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.disposeBag = DisposeBag()
    }
    
    @objc func logedOut(){
        //        cartBooks.forEach { (cartBook) in
        //            cartBook.inCart = false
        //        }
        //        booksInCart.forEach { (book) in
        //            if book.id == self.fetchedCartStatus.id {
        //
        //                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {[weak self] in
        //                    BooksService.lockBook(bookId: book.id, lockStatus: .unlocked).subscribe { (unlock) in
        //                            book.inCart = false
        //                            book.locked = LockStatus.unlocked.rawValue
        //                            try! self?.context?.save()
        //                    } onError: { (error) in
        //                        self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
        //                    } onCompleted: {
        //                        //
        //                    } onDisposed: {
        //                        //
        //                    }.disposed(by: self?.disposeBag ?? DisposeBag())
        //                })
        //            }
        //
        //        }
        
        
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
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["sukycar@gmail.com"])
            var message = ""
            //            for m in booksFiltered {
            //                message.append("\(m.title ?? "") - vip: \(m.vip) - broj police: \(m.boxNumber); ")
            //            }
            mail.setMessageBody("Ordered books in attachment", isHTML: true)
            mail.setSubject("Order books")
            
            let joinedString = message
            print(joinedString)
            if let data = (joinedString).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)){
                //Attach File
                mail.addAttachmentData(data, mimeType: "text/plain", fileName: "Books")
                present(mail, animated: true)
            }
        } else {
            // show failure alert
            print("Failed to send mail")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension CartTableView{
    class func get() -> CartTableView {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartTableView") as! CartTableView
        vc.view.startActivityIndicator()
        return vc
    }
}


