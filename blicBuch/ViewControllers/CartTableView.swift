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

class CartTableView: UITableViewController, MFMailComposeViewControllerDelegate {

    var cartBooks: [Books] = [Books]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let customCellName = String(describing: CustomCell.self)
        let orderCellName = String(describing: OrderTableViewCell.self)
        tableView.register(UINib(nibName: customCellName, bundle: nil), forCellReuseIdentifier: customCellName)
        tableView.register(UINib(nibName: orderCellName, bundle: nil), forCellReuseIdentifier: orderCellName)
        self.title = "CART"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1 {
            return cartBooks.count + 1
        }
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            if indexPath.row <= cartBooks.count - 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomCell.self), for: indexPath) as! CustomCell
                let book = cartBooks[indexPath.row]
                cell.set(with: book)
                cell.orderButton.setImage(UIImage(named: "img_remove"), for: .normal)
                cell.orderButton.translatesAutoresizingMaskIntoConstraints = false
                cell.orderButton.imageEdgeInsets = UIEdgeInsets(top: 2.5, left: 2, bottom: 2.5, right: 2)
                cell.orderButton.clipsToBounds = true
                cell.orderButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
                cell.orderButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
                cell.orderButton.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -20).isActive = true
                cell.orderButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -20).isActive = true
     
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OrderTableViewCell.self), for: indexPath) as! OrderTableViewCell
                cell.orderButton.rx.tap.subscribe(onNext: {[weak self] in
                    self?.sendEmail()
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
            for m in cartBooks {
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


