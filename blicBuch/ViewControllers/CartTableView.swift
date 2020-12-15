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
    var arrayOfBookId = [Int32]()
    var cartBooks: [CartBook] = [CartBook]()
    var booksInCart: [Book] = [Book]()
    var booksFiltered: [Book] = Array(Set<Book>())
    let context = DataManager.shared.context
    var fetchResults:NSFetchedResultsController<NSManagedObject>?
    
    func fetchBooks(){
        let request = CartBook.fetchRequest() as NSFetchRequest
        let booksRequest = Book.fetchRequest() as NSFetchRequest
        let predicate = NSPredicate(format: "inCart == true")
        request.predicate = predicate
        do {
            try self.cartBooks = context?.fetch(request) ?? [CartBook]()
            try self.booksInCart = context?.fetch(booksRequest) ?? [Book]()
        } catch {
            print("No books")
        }
        
        cartBooks.forEach { (cartBook) in
            if cartBook.inCart == true {
                booksInCart.forEach { (book) in
                    if cartBook.id == book.id {
                        booksFiltered.append(book)
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.stopActivityIndicator()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(arrayOfBookId)
        let customCellName = String(describing: CustomCell.self)
        let orderCellName = String(describing: OrderTableViewCell.self)
        tableView.register(UINib(nibName: customCellName, bundle: nil), forCellReuseIdentifier: customCellName)
        tableView.register(UINib(nibName: orderCellName, bundle: nil), forCellReuseIdentifier: orderCellName)
        self.title = "CART"
    }

    // MARK: - Table view data source

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchBooks()
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1 {
            return booksFiltered.count + 1
        }
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            if indexPath.row <= booksFiltered.count - 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomCell.self), for: indexPath) as! CustomCell
                let book = booksFiltered[indexPath.row]
                cell.set(with: book)
                cell.orderButton.setImage(UIImage(named: "img_remove"), for: .normal)
                cell.orderButton.translatesAutoresizingMaskIntoConstraints = false
                cell.orderButton.imageEdgeInsets = UIEdgeInsets(top: 2.5, left: 2, bottom: 2.5, right: 2)
                cell.orderButton.clipsToBounds = true
                cell.orderButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
                cell.orderButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
                cell.orderButton.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -20).isActive = true
                cell.orderButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -20).isActive = true
                cell.orderButton.rx.tap.subscribe { (pressed) in
                    self.cartBooks.forEach { (cartBook) in
                        if cartBook.id == book.id {
                            cartBook.inCart = false
                            self.view.startActivityIndicator()
                            do {
                                try self.context?.save()
                                self.booksFiltered.removeAll()
                                self.fetchBooks()
                            } catch {
                                print("Not saved")
                            }
                        }
                    }
                } onError: { (error) in
                    print("Error while changing status")
                } onCompleted: {
                    
                } onDisposed: {
                    
                }.disposed(by: cell.disposeBag)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OrderTableViewCell.self), for: indexPath) as! OrderTableViewCell
                cell.orderButton.rx.tap.subscribe(onNext: {[weak self] in
                    self?.sendEmail()
                    blicBuchUserDefaults.set(.selectedVipBooks, value: 0)
                    blicBuchUserDefaults.set(.selectedRegularBooks, value: 0)
                }).disposed(by: cell.disposeBag)
                return cell
            }
            
        } else {
        
        return UITableViewCell()
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

extension CartTableView{
    class func get() -> CartTableView {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartTableView") as! CartTableView
        vc.view.startActivityIndicator()
        return vc
    }
}

extension CartTableView: AlertMe {
    func selectedBook(id: Int32) {
//        if arrayOfBookId.count < 5 {
//            if !arrayOfBookId.contains(id){
//                arrayOfBookId.append(id)
//            } else {
//                print("Book is already in cart")//MARK:- make new alert for this
//            }
//        
//        }
//        print(arrayOfBookId)
    }
    
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


