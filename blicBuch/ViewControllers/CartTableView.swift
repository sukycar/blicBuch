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
    
    let alertService = AlertService()
    var cartBooks: [CartBook] = [CartBook]()
    var booksInCart: [Book] = [Book]()
    var booksFiltered: [Book] = [Book]()
    var fetchedCartStatus = CartBook()
    let context = DataManager.shared.context
    var fetchResults:NSFetchedResultsController<NSManagedObject>?
    var idArray = [Int32]()
    var disposeBag = DisposeBag()
    
    func fetchBooks(){
        //        cartBooks.removeAll()
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
        //        booksFiltered.removeAll()
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
        //        cartBooks.forEach { (cartBook) in
        //            if cartBook.inCart == true {
        //                booksInCart.forEach { (book) in
        //                    if cartBook.id == book.id {
        //                        booksFiltered.append(book)
        //                        booksFiltered = Array(Set(booksFiltered))
        //                        booksFiltered.sort { (book1, book2) -> Bool in
        //                            book1.title ?? "" < book2.title ?? ""
        //                        }
        //                    }
        //                }
        //            }
        //        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.stopActivityIndicator()
        }
    }
    func combineFetches(){
        fetchBooks()
        fetchCartBooks()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        combineFetches()
        let customCellName = String(describing: CustomCell.self)
        let orderCellName = String(describing: OrderTableViewCell.self)
        tableView.register(UINib(nibName: customCellName, bundle: nil), forCellReuseIdentifier: customCellName)
        tableView.register(UINib(nibName: orderCellName, bundle: nil), forCellReuseIdentifier: orderCellName)
        self.title = "CART"
    }
    
    // MARK: - Table view data source
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //        combineFetches()
    //    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return booksInCart.count
        } else {
            return 1
        }
        
    }
    
    
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
                    self?.view.startActivityIndicator()
                    self?.fetchBookCartStatus(for: book.id)
                    self?.fetchedCartStatus.inCart = false
                    self?.booksInCart.forEach { (book) in
                        if book.id == self?.fetchedCartStatus.id {
                            book.inCart = false
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
                    
                    //                        }
                    //                    }
                    
                }).disposed(by: cell.disposeBag)
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OrderTableViewCell.self), for: indexPath) as! OrderTableViewCell
            cell.orderButton.rx.tap.subscribe(onNext: {[weak self] in
                self?.sendEmail()
                _ = blicBuchUserDefaults.set(.selectedVipBooks, value: 0)
                _ = blicBuchUserDefaults.set(.selectedRegularBooks, value: 0)
            }).disposed(by: self.disposeBag)
            return cell
        }
        return UITableViewCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.disposeBag = DisposeBag()
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
        /*let alert = UIAlertController(title: "TEST", message: "NISTE REGISTROVANI", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "LOGIN", style: .default, handler: { (action) in
         print("ULOGOVAN")
         }))
         alert.addAction(UIAlertAction(title: "REG", style: .default, handler: { (action) in
         print("REGISTROVAN")
         }))
         present(alert, animated: true)
         print("Jedan test")*/
        
    }
}


