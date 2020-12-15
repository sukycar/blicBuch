//
//  SideMenuViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 12.12.20..
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MessageUI
import NVActivityIndicatorView


class SideMenuViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
//    var collections: Results<Collection>?
//    var promotions: Results<Promotion>?
//    var categories: Results<Category>?
//    var favorites: Results<Promotion>?
//    var notifications:Results<PushNotification>?
    var selectedCellType: MenuSelectionType = .categories
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableHolderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var cells = [SideMenuCellType]()
    var transition : CustomTransition2?
    var frame : CGRect?
    var frameView : UIView?
    var snapshot : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 15
        self.view.clipsToBounds = true
        self.view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        configureTable()
        self.mainView.backgroundColor = Colors.white
        tableView.delegate = self
        tableView.dataSource = self
        configureCells()
        tableView.showsVerticalScrollIndicator = false
        tableView.reloadData()
    }
    

    func configureTable() {
        let backgroundImage = UIImageView(frame: tableHolderView.bounds)
        backgroundImage.image = UIImage(named: "sideMenuBackground")
        tableHolderView.insertSubview(backgroundImage, at: 0)
        tableHolderView.clipsToBounds = true
        tableHolderView.layer.cornerRadius = CornerRadius.largest
        tableHolderView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        tableView.clipsToBounds = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureCells()
        self.tableView.reloadData()
    }
    
    private func configureCells(){
        cells.removeAll()
        cells.append(.member)
        cells.append(.general(type: .login))
        cells.append(.general(type: .register))
        cells.append(.general(type: .contact))
        cells.append(.general(type: .donate))
        cells.append(.general(type: .cart))
    }
    
    
    
    enum MenuSelectionType{
        case collections, categories, offers
    }
    
    enum SideMenuCellType{
        case member,general(type:GeneralMenuCellType)
    }
    
    enum GeneralMenuCellType: CaseIterable{
        case login, register, contact, donate, cart
        var title:String{
            switch self {
            case .login:
                return "Einloggen".localized()
            case .register:
                return "Registrieren".localized()
            case .contact:
                return "Kontakt".localized()
            case .donate:
                return "SCHENKUNG".localized()
            case .cart:
                return "Cart".localized()
            }
        }
        
        var imageName: String {
            switch self {
            case .login:
                return "login"
            case .register:
                return "registration"
            case .contact:
                return "contact"
            case .donate:
                return "donate"
            case .cart:
                return "donate"
            }
        }
        
        var imageTint: UIColor {
            switch self {
            
            case .login:
                return Colors.blueDefault
            case .register:
                return Colors.blueDefault
            case .contact:
                return Colors.blueDefault
            case .donate:
                return Colors.orange
            case .cart:
                return Colors.blueDefault
            }
        }
    }
}

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = cells[indexPath.row]
        switch type {
        case .member:
            return 100
        default:
            return 60
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = cells[indexPath.row]
        switch type {
        case .member:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuMemberCell") as? SideMenuMemberCell {
                cell.backgroundColor = .clear
//                let firstName = eMarketUserDefaults.get(.userFirstName) ?? "null"
//                let lastName = eMarketUserDefaults.get(.userLastName) ?? "null"
                
//                var name:String? = firstName as? String
//                name = name != nil ? (name ?? "") + " " : name
//                if let lastName = lastName as? String {
//                    name = (name ?? "") + lastName
//                }
                cell.setCell(name: "Vladimir Sukanica")
                cell.layer.backgroundColor = UIColor.clear.cgColor
                cell.contentView.backgroundColor = .clear
                cell.backgroundColor = .clear
                cell.layer.opacity = 0
                return cell
            }
        case .general(let generalType):
            if generalType == .login {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuGeneralCell") as? SideMenuGeneralCell {
                    cell.sideMenuCell = generalType
                    cell.setCell(title: generalType.title, imageName: generalType.imageName, counter: "", imageTint: generalType.imageTint)
                    cell.layer.backgroundColor = UIColor.clear.cgColor
                    cell.contentView.backgroundColor = .clear
                    cell.backgroundColor = .clear
                    cell.layer.opacity = 0
                    return cell
                    
                }
            }
            if generalType == .register {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuGeneralCell") as? SideMenuGeneralCell {
                    cell.sideMenuCell = generalType
                    cell.setCell(title: generalType.title, imageName: generalType.imageName, counter: "", imageTint: generalType.imageTint)
                    cell.layer.backgroundColor = UIColor.clear.cgColor
                    cell.contentView.backgroundColor = .clear
                    cell.backgroundColor = .clear
                    cell.layer.opacity = 0
                    return cell
                    
                }
            }
            if generalType == .contact {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuGeneralCell") as? SideMenuGeneralCell {
                    cell.sideMenuCell = generalType
                    cell.setCell(title: generalType.title, imageName: generalType.imageName, counter: "", imageTint: generalType.imageTint)
                    cell.layer.backgroundColor = UIColor.clear.cgColor
                    cell.contentView.backgroundColor = .clear
                    cell.backgroundColor = .clear
                    cell.layer.opacity = 0
                    return cell
                }
            }
            if generalType == .donate {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuGeneralCell") as? SideMenuGeneralCell {
                    cell.sideMenuCell = generalType
                    cell.setCell(title: generalType.title, imageName: generalType.imageName, counter: "", imageTint: generalType.imageTint)
                    cell.layer.backgroundColor = UIColor.clear.cgColor
                    cell.contentView.backgroundColor = .clear
                    cell.backgroundColor = .clear
                    cell.layer.opacity = 0
                    return cell
                    
                }
            }
            if generalType == .cart {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuGeneralCell") as? SideMenuGeneralCell {
                    cell.sideMenuCell = generalType
                    cell.setCell(title: generalType.title, imageName: generalType.imageName, counter: "", imageTint: generalType.imageTint)
                    cell.layer.backgroundColor = UIColor.clear.cgColor
                    cell.contentView.backgroundColor = .clear
                    cell.backgroundColor = .clear
                    cell.layer.opacity = 0
                    return cell
                    
                }
            }
           
        }
        let cell = self.tableView(tableView, cellForRowAt: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = cells[indexPath.row]
        switch type {
        case .member:
            return
        case .general(type: let type):
            switch type {
            case .login:
                let vc = LoginViewController.get()
                self.transition = CustomTransition2(from: self, to: vc, fromFrame: nil, snapshot: nil, viewToHide: nil)
                vc.transitioningDelegate = self.transition
                vc.presentedViewController?.dismiss(animated: true, completion: nil)
                vc.modalPresentationStyle = .custom
                self.present(vc, animated: true, completion: nil)
                return
            case .register:
                let vc = RegisterViewController.get()
                self.transition = CustomTransition2(from: self, to: vc, fromFrame: nil, snapshot: nil, viewToHide: nil)
                vc.transitioningDelegate = self.transition
                vc.presentedViewController?.dismiss(animated: true, completion: nil)
                vc.modalPresentationStyle = .custom
                self.present(vc, animated: true, completion: nil)
                return
            case .contact:
                self.sendEmail()
                return
            case .donate:
                let vc = RegisterViewController.get()
                self.transition = CustomTransition2(from: self, to: vc, fromFrame: nil, snapshot: nil, viewToHide: nil)
                vc.transitioningDelegate = self.transition
                vc.presentedViewController?.dismiss(animated: true, completion: nil)
                vc.modalPresentationStyle = .custom
                self.present(vc, animated: true, completion: nil)
                return
            case .cart:
                let vc = CartTableView.get()
                self.transition = CustomTransition2(from: self, to: vc, fromFrame: nil, snapshot: nil, viewToHide: nil)
                vc.transitioningDelegate = self.transition
                vc.presentedViewController?.dismiss(animated: true, completion: nil)
                vc.modalPresentationStyle = .custom
                self.present(vc, animated: true, completion: nil)
                return
        }
  
    }
    
}
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["sukycar@gmail.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

            mail.setSubject("Blic Buch support")
            
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }// func for sending mail
}
