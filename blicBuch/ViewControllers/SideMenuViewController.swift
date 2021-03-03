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
import NVActivityIndicatorView
import CoreData


class SideMenuViewController: UIViewController{
    
    
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
    
    var lockedBooks : [Int32]?
    var vipBooksCounter = Int()
    var regularBooksCounter = Int()
    var cartItems = blicBuchUserDefaults.get(.cartItems) as? [String]
    var cartItemsCount = Int(){
        didSet{
            if cartItems == [""] {
                cartItemsCount = 0
            }
            self.tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .none)
        }
    }
    let mailHandler = MailHandler()
    var device : DeviceType?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.device = self.view.getDeviceType()
//        NotificationCenter.default.addObserver(self, selector: #selector(reloadUsername), name: NSNotification.Name(rawValue: "logedIn"), object: nil)
        self.view.layer.cornerRadius = 15
        self.view.clipsToBounds = true
        self.view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        self.mainView.backgroundColor = Colors.sideMenuBackgroundColor
        self.mainView.tintColor = Colors.blueDefault
        tableView.delegate = self
        tableView.dataSource = self
        configureTable()
        configureCells()
    }
    
    func configureTable() {
        imageView.contentMode = .scaleAspectFill
        tableHolderView.clipsToBounds = true
        tableHolderView.layer.cornerRadius = CornerRadius.largest
        tableHolderView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        tableView.clipsToBounds = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = device != .macCatalyst ? .singleLine : .none
        tableView.separatorColor = device != .macCatalyst ? Colors.blueDefault : .none
        self.tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mainView.isAccessibilityElement = true
        self.mainView.accessibilityIdentifier = "mainView"
        self.cartItemsCount = self.cartItems?.count ?? 0
        UsersService.getCartBooks(userId: self.userId).subscribe { [weak self](cartArray) in
            self?.lockedBooks = cartArray
            self?.loadBooksInCart()
        } onError: { (error) in
            self.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
        } onCompleted: {
        }.disposed(by: self.disposeBag)
    }
    
    func count() -> Int{
        let x = 4 + 5
        return x
    }
    
    private func configureCells(){
        cells.removeAll()
        cells.append(.member)
        cells.append(.general(type: .login))
        cells.append(.general(type: .register))
        cells.append(.general(type: .contact))
        cells.append(.general(type: .cart))
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
            }//: LOOP
        } catch {
            self.getAlert(errorString: "Books are not fetched", errorColor: Colors.orange)
        }//: DO-CATCH
    }
    
    @objc func reloadUsername(){
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)], with: .none)
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
                    cell.setCell(title: logedIn == false ? generalType.title : "Logout", imageName: generalType.imageName, counter: 0, imageTint: generalType.imageTint)
                    cell.isAccessibilityElement = true
                    cell.accessibilityIdentifier = "sideMenuLoginCell"
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
                                        try! self?.context?.save()
                                    } onError: { (error) in
                                        self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                                    } onCompleted: {
                                    }.disposed(by: cell.disposeBag)
                                }
                                UsersService.updateCartBooks(userId: self?.userId ?? 0, bookIDs: [""]).subscribe { (updated) in
                                        self?.cartItemsCount = 0
                                        self?.dismiss(animated: true, completion: nil)
                                } onError: { (error) in
                                    self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                                } onCompleted: {
                                }.disposed(by: cell.disposeBag)
                            }
                            self?.getAlert(errorString: "Izlogovani ste!", errorColor: Colors.orange)
                            _ = blicBuchUserDefaults.set(.id, value: 0)
                            _ = blicBuchUserDefaults.set(.logedIn, value: false)
                            _ = blicBuchUserDefaults.set(.numberOfRegularBooks, value: 0)
                            _ = blicBuchUserDefaults.set(.numberOfVipBooks, value: 0)
                            _ = blicBuchUserDefaults.set(.username, value: "--")
                            _ = blicBuchUserDefaults.set(.cartItems, value: [""])
                            self?.reloadUsername()
                        } else {
                            let vc = LoginViewController.get()
                            let nav = UINavigationController(rootViewController: vc)
                            self?.transition = CustomTransition2(from: self ?? SideMenuViewController(), to: vc, fromFrame: nil, snapshot: nil, viewToHide: nil)
                            nav.transitioningDelegate = self?.transition
                            nav.presentedViewController?.dismiss(animated: true, completion: nil)
                            nav.modalPresentationStyle = .custom
                            let attributes = [NSAttributedString.Key.font:UIFont(name: FontName.regular.value, size: FontSize.navigationTitle) ?? UIFont.systemFont(ofSize: FontSize.navigationTitle), NSAttributedString.Key.foregroundColor : Colors.blueDefault] as [NSAttributedString.Key : Any]
                            nav.navigationBar.titleTextAttributes = attributes
                            self?.present(nav, animated: true, completion: nil)
                            return
                        }
                    }).disposed(by: cell.disposeBag)
                    return cell
                }
                
            }
            if generalType == .register {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuGeneralCell") as? SideMenuGeneralCell {
                    cell.sideMenuCell = generalType
                    cell.setCell(title: generalType.title, imageName: generalType.imageName, counter: 0, imageTint: generalType.imageTint)
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
                    cell.setCell(title: generalType.title, imageName: generalType.imageName, counter: 0, imageTint: generalType.imageTint)
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
                    cell.setCell(title: generalType.title, imageName: generalType.imageName, counter: cartItemsCount, imageTint: generalType.imageTint)
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
                return
            case .register:
                let vc = RegisterViewController.get()
                let nav = UINavigationController(rootViewController: vc)
                self.transition = CustomTransition2(from: self, to: vc, fromFrame: nil, snapshot: nil, viewToHide: nil)
                nav.transitioningDelegate = self.transition
                nav.presentedViewController?.dismiss(animated: true, completion: nil)
                nav.modalPresentationStyle = .custom
                let attributes = [NSAttributedString.Key.font:UIFont(name: FontName.regular.value, size: FontSize.navigationTitle) ?? UIFont.systemFont(ofSize: FontSize.navigationTitle), NSAttributedString.Key.foregroundColor : Colors.blueDefault] as [NSAttributedString.Key : Any]
                nav.navigationBar.titleTextAttributes = attributes
                self.present(nav, animated: true, completion: nil)
                return
            case .contact:
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.mailHandler.sendEmail(presentedFrom: strongSelf)
                }
                return
            case .cart:
                let vc = CartViewController.get()
                self.transition = CustomTransition2(from: self, to: vc, fromFrame: nil, snapshot: nil, viewToHide: nil)
                let nav = UINavigationController(rootViewController: vc)
                nav.transitioningDelegate = self.transition
                nav.presentedViewController?.dismiss(animated: true, completion: nil)
                vc.cartCountObserver.subscribe(onNext: {number in
                    self.cartItemsCount = number
                }).disposed(by: self.disposeBag)
                let attributes = [NSAttributedString.Key.font:UIFont(name: FontName.regular.value, size: FontSize.navigationTitle) ?? UIFont.systemFont(ofSize: FontSize.navigationTitle), NSAttributedString.Key.foregroundColor : Colors.blueDefault] as [NSAttributedString.Key : Any]
                nav.navigationBar.titleTextAttributes = attributes
                nav.modalPresentationStyle = .custom
                self.present(nav, animated: true, completion: nil)
                return
            }
            
        }
        
    }
    
    
    
    
}
