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
import CoreData


class SideMenuViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableHolderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    private var books = [Book]()
    private var cells = [SideMenuCellType]()
    private var transition : CustomTransition2?
    private var frame : CGRect?
    private var frameView : UIView?
    private var snapshot : UIImage?
    private var disposeBag = DisposeBag()
    private var context = DataManager.shared.context
    private var userId = blicBuchUserDefaults.get(.id) as? Int32 ?? 0
    var lockedBooks : [Int32]?//blicBuchUserDefaults.get(.cartItems) as! [String]
    var vipBooksCounter = Int()
    var regularBooksCounter = Int()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadUsername), name: NSNotification.Name(rawValue: "logedIn"), object: nil)
        self.view.layer.cornerRadius = 15
        self.view.clipsToBounds = true
        self.view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        configureTable()
        self.mainView.backgroundColor = Colors.sideMenuBackgroundColor
        self.mainView.tintColor = Colors.blueDefault
        tableView.delegate = self
        tableView.dataSource = self
        configureCells()
    }
    
    func configureTable() {
        //        imageView.image = UIImage(named: "img_side_menu_background")
        imageView.contentMode = .scaleAspectFill
        tableHolderView.clipsToBounds = true
        tableHolderView.layer.cornerRadius = CornerRadius.largest
        tableHolderView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        tableView.clipsToBounds = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = Colors.blueDefault
        self.tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UsersService.getCartBooks(userId: self.userId).subscribe { (cartArray) in
            self.lockedBooks = cartArray
            self.loadBooksInCart()
        } onError: { (error) in
            self.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
        } onCompleted: {
            //
        }.disposed(by: self.disposeBag)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.disposeBag = DisposeBag()
    }
    
    func loadBooksInCart(){
        let request = Book.fetchRequest() as NSFetchRequest
        var predicate : NSPredicate?
        guard let lockedBooks = lockedBooks else {return}
        predicate = NSPredicate(format: "id in %@", lockedBooks)
        request.predicate = predicate
        do {
            self.books = try DataManager.shared.context.fetch(request)
            regularBooksCounter = 0
            vipBooksCounter = 0
            books.forEach { (book) in
                if book.vip == false {
                    regularBooksCounter += 1
                } else {
                    vipBooksCounter += 1
                }
            }
        } catch {
            self.getAlert(errorString: "Books are not fetched", errorColor: Colors.orange)
        }
    }
    
    //    func checkForAvailableBooksNumber(){
    //        UsersService.checkForAvailableBooks(self.userId).subscribe { (vip, regular) in
    //            let vip = vip
    //            let regular = regular
    //
    //            self.numberOfAvailableRegularBooks = regular
    //            self.numberOfAvailableVipBooks = vip
    //        } onError: { (error) in
    //            self.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
    //        } onCompleted: {
    //        }.disposed(by: self.disposeBag)
    //    }
    
    
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
            return 50
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = cells[indexPath.row]
        switch type {
        case .member:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuMemberCell") as? SideMenuMemberCell {
                cell.backgroundColor = .clear
                if let loginStatus = blicBuchUserDefaults.get(.logedIn) as? Bool {
                    let username = loginStatus == true ?  blicBuchUserDefaults.get(.username) : "--"
                    cell.setCell(name: username as? String)
                } else {
                    cell.setCell(name: "--")
                }
                cell.layer.backgroundColor = UIColor.clear.cgColor
                cell.contentView.backgroundColor = .clear
                cell.backgroundColor = .clear
                cell.layer.opacity = 0
                return cell
            }
        case .general(let generalType):
            if generalType == .login {
                let logedIn = blicBuchUserDefaults.get(.logedIn) as? Bool
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuGeneralCell") as? SideMenuGeneralCell {
                    cell.sideMenuCell = generalType
                    cell.setCell(title: logedIn == false ? generalType.title : "Logout", imageName: generalType.imageName, counter: "", imageTint: generalType.imageTint)
                    cell.layer.backgroundColor = UIColor.clear.cgColor
                    cell.contentView.backgroundColor = .clear
                    cell.backgroundColor = .clear
                    cell.layer.opacity = 0
                    cell.actionButton.rx.tap.subscribe(onNext: {[weak self] in
                        if logedIn == true {
                            self?.updateBooksNumber(vip: true, removeBooks: false, numberOfBooks: self?.vipBooksCounter ?? 0, disposeBag: cell.disposeBag)
                            self?.updateBooksNumber(vip: false, removeBooks: false, numberOfBooks: self?.regularBooksCounter ?? 0, disposeBag: cell.disposeBag)
                            if let books = self?.books {
                                for book in books {
                                    BooksService.lockBook(bookId:book.id, lockStatus: .unlocked).subscribe {(unlocked) in
                                        book.locked = LockStatus.unlocked.rawValue
                                    } onError: { (error) in
                                        self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                                    } onCompleted: {
                                    }.disposed(by: cell.disposeBag)
                                }
                                try! self?.context?.save()
                                UsersService.updateCartBooks(userId: self?.userId ?? 0, bookIDs: [""]).subscribe { (updated) in
                                    //
                                } onError: { (error) in
                                    self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                                } onCompleted: {
                                    //
                                }.disposed(by: cell.disposeBag)
                            }
                            self?.getAlert(errorString: "Izlogovani ste!", errorColor: Colors.orange)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logedOut"), object: nil)
                            _ = blicBuchUserDefaults.set(.id, value: 0)
                            _ = blicBuchUserDefaults.set(.logedIn, value: false)
                            _ = blicBuchUserDefaults.set(.numberOfRegularBooks, value: 0)
                            _ = blicBuchUserDefaults.set(.numberOfVipBooks, value: 0)
                            _ = blicBuchUserDefaults.set(.username, value: "--")
                            _ = blicBuchUserDefaults.set(.cartItems, value: [""])
                            self?.reloadUsername()
                        } else {
                            let vc = LoginViewController.get()
                            self?.transition = CustomTransition2(from: self ?? SideMenuViewController(), to: vc, fromFrame: nil, snapshot: nil, viewToHide: nil)
                            vc.transitioningDelegate = self?.transition
                            vc.presentedViewController?.dismiss(animated: true, completion: nil)
                            vc.modalPresentationStyle = .custom
                            self?.present(vc, animated: true, completion: nil)
                            return
                        }
                    }).disposed(by: cell.disposeBag)
                    
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
            let lockedBooks = blicBuchUserDefaults.get(.cartItems) as? [String]
            print(lockedBooks)
            return
        case .general(type: let type):
            switch type {
            case .login:
                print("Login cell selected")
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
    
    @objc func reloadUsername(){
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)], with: .none)
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
