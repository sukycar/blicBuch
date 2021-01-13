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
    

    private let alertService = AlertService()
    private var cartBooks: [CartBook] = [CartBook]()
    private var booksInCart: [Book] = [Book]()
    private var booksFiltered: [Book] = [Book]()
    private var fetchedBooks: [Book] = [Book]()
    private var fetchedCartStatus = CartBook()
    private let context = DataManager.shared.context
    private var idArray = [Int32]()
    var titleHolderView : UIView?
    var label : UILabel?
    var disposeBag = DisposeBag()
    let screenHeight = UIScreen.main.bounds.height
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        NotificationCenter.default.addObserver(self, selector: #selector(dismissController), name: NSNotification.Name(rawValue: "PaidTransport"), object: nil)
        combineFetches()
        let customCellName = String(describing: CustomCell.self)
        let orderCellName = String(describing: OrderTableViewCell.self)
        tableView.register(UINib(nibName: customCellName, bundle: nil), forCellReuseIdentifier: customCellName)
        tableView.register(UINib(nibName: orderCellName, bundle: nil), forCellReuseIdentifier: orderCellName)
        tableView.register(UINib(nibName: String(describing: EmptyTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: EmptyTableViewCell.self))
        self.title = "CART"
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
            return booksInCart.count
        } else {
            return 1
        }
        
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label = Label(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
//        var view = UIView()
//        view.addSubview(label)
////        view.frame.size.height = 100
////        view.frame.size.width = self.view.frame.size.width
//        label.type.type = .sideMenuTitle
//        label.text = "Cart"
//        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
//        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 20).isActive = true
//        label.textAlignment = .left
//        if section == 0 {
//            return view
//        }
//        return UIView()
//
//    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 50
//        }
//        return 0
//    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if booksInCart.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomCell.self), for: indexPath) as! CustomCell
                let book = booksInCart[indexPath.row]
                cell.set(with: book, inVipController: false)
                cell.orderButton.setImage(UIImage(named: "img_remove"), for: .normal)
                cell.orderButton.translatesAutoresizingMaskIntoConstraints = false
                cell.orderButton.imageEdgeInsets = UIEdgeInsets(top: 2.5, left: 2, bottom: 2.5, right: 2)
                cell.orderButton.clipsToBounds = true
                cell.orderButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
                cell.orderButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
                cell.orderButton.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -20).isActive = true
                cell.orderButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -20).isActive = true
                cell.orderButton.rx.tap.subscribe (onNext: {[weak self] in
                    //                    if let membership = blicBuchUserDefaults.get(.numberOfVipBooks) {
                    self?.view.startActivityIndicator()
                    self?.fetchBookCartStatus(for: book.id)
                    self?.fetchedCartStatus.inCart = false
                    self?.booksInCart.forEach { (book) in
                        if book.id == self?.fetchedCartStatus.id {
                            book.inCart = false
                            book.locked = LockStatus.unlocked.rawValue
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                BooksService.lockBook(bookId: book.id, lockStatus: .unlocked).subscribe { (unlock) in
                                    //
                                } onError: { (error) in
                                    self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                                } onCompleted: {
                                    //
                                } onDisposed: {
                                    //
                                }.disposed(by: cell.disposeBag)
                            })
                        }
                    }
                    self?.combineFetches()
                    print(self?.idArray)
                    
                    do {
                        try self?.context?.save()
                        try self?.context?.parent?.save()
                    } catch {
                        print("Not saved")
                    }
                    
                    //                    } else {
                    //                    self?.onClick(index: indexPath.row)
                    //                    }
                    
                }).disposed(by: cell.disposeBag)
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if indexPath.section == 1 {
            if booksInCart.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: (String(describing: EmptyTableViewCell.self)), for: indexPath) as! EmptyTableViewCell
                cell.set("Nema itema u korpi")
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OrderTableViewCell.self), for: indexPath) as! OrderTableViewCell
            cell.orderButton.rx.tap.subscribe(onNext: {[weak self] in
                guard let strongSelf = self else {return}
                let alert = strongSelf.alertService.get(with: .orderBooks)
                strongSelf.present(alert, animated: true, completion: nil)
                //                self?.sendEmail()
                //                _ = blicBuchUserDefaults.set(.selectedVipBooks, value: 0)
                //                _ = blicBuchUserDefaults.set(.selectedRegularBooks, value: 0)
            }).disposed(by: self.disposeBag)
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && booksInCart.count == 0 {
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
        if section == 0 && booksInCart.count > 0 {
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
    
    
    @objc func dismissController(){
        self.dismiss(animated: true) {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.booksInCart.forEach({ (book) in
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
                    //                    let request = Book.fetchRequest() as NSFetchRequest
                    ////                    request.predicate = NSPredicate(format: "id == %d", book.id)
                    //                    do {
                    //                        if let fetch = try strongSelf.context?.fetch(request) {
                    //                        strongSelf.fetchedBooks = fetch
                    //                            print(strongSelf.fetchedBooks)
                    //                        }
                    ////                        try strongSelf.context?.save()
                    //                    } catch {
                    //                        print("Not fetched")
                    //                    }
                    
                } onError: { (error) in
                    strongSelf.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                } onCompleted: {
                    //
                } onDisposed: {
                    //
                }.disposed(by: self?.disposeBag ?? DisposeBag())
            })
            strongSelf.cartBooks.forEach { (book) in
                book.inCart = false
                do {
                    try strongSelf.context?.save()
                    try strongSelf.context?.parent?.save()
                } catch {
                    print("Cart books not saved")
                }
            }
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["sukycar@gmail.com"])
            var message = ""
            for m in booksFiltered {
                message.append("\(m.title ?? "") - vip: \(m.vip) - broj police: \(m.boxNumber); ")
            }
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

extension CartTableView {
    func fetchBooks(){
        let request = CartBook.fetchRequest() as NSFetchRequest
        let predicate = NSPredicate(format: "inCart == true")
        request.predicate = predicate
        do {
            try self.cartBooks = context?.fetch(request) ?? [CartBook]()
        } catch {
            self.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
        }
    }
    
    func fetchBookCartStatus(for id: Int32){
        let request = CartBook.fetchRequest() as NSFetchRequest
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            try fetchedCartStatus = context?.fetch(request).first ?? CartBook()
        } catch {
            self.getAlert(errorString: "New cart status not fetched", errorColor: Colors.orange)
        }
    }
    
    func fetchCartBooks(){
        let request = Book.fetchRequest() as NSFetchRequest
        idArray.removeAll()
        cartBooks.forEach { (cartBook) in
            if !idArray.contains(cartBook.id) {
                idArray.append(cartBook.id)
            }
        }
        let predicate = NSPredicate(format: "id in %@", idArray)
        let sort = NSSortDescriptor(key: "title", ascending: true)
        request.predicate = predicate
        request.sortDescriptors = [sort]
        do {
            try booksInCart = context?.fetch(request) ?? [Book]()
        } catch {
            self.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.stopActivityIndicator()
        }
    }
    
    func combineFetches(){
        fetchBooks()
        fetchCartBooks()
    }
}
extension CartTableView{
    class func get() -> CartTableView {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartTableView") as! CartTableView
        vc.view.startActivityIndicator()
        return vc
    }
}

extension CartTableView: AlertMe {
    func onClick(index: Int) {
        let alertVC = alertService.alert()
        present(alertVC, animated: true)
        //        let alert = UIAlertController(title: "TEST", message: "NISTE REGISTROVANI", preferredStyle: .alert)
        //         alert.addAction(UIAlertAction(title: "LOGIN", style: .default, handler: { (action) in
        //         print("ULOGOVAN")
        //         }))
        //         alert.addAction(UIAlertAction(title: "REG", style: .default, handler: { (action) in
        //         print("REGISTROVAN")
        //         }))
        //         present(alert, animated: true)
        
        
    }
}


