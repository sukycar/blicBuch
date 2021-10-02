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


class SideMenuViewController: BaseViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableHolderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    private var books = [Book]()
    private var cells = [SideMenuCellType]()
    private var transition : CustomTransition?
    private var frame : CGRect?
    private var frameView : UIView?
    private var snapshot : UIImage?
    private var disposeBag = DisposeBag()
    private var context = DataManager.shared.context
    private var userId: Int32?
    
    var lockedServerBooks : [Int32]?
    var vipBooksCounter = Int()
    var regularBooksCounter = Int()
    var cartItems: [String]?
    var cartItemsCount = Int(){
        didSet{
            if cartItems == [""] {
                cartItemsCount = 0
            }
            self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
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
        self.userId = blitzBuchUserDefaults.getUser()?.id
        self.cartItems = blitzBuchUserDefaults.getUser()?.cartItems?.components(separatedBy: ",")
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
        UsersService.getCartBooks(userId: self.userId ?? 0).subscribe { [weak self](cartArray) in
            self?.lockedServerBooks = cartArray
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
        cells.append(.general(type: .contact))
        cells.append(.general(type: .cart))
        cells.append(.general(type: .logout))
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
        guard let lockedBooks = lockedServerBooks else {return}
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
            self.getAlert(errorString: NSLocalizedString("Books are not fetched", comment: ""), errorColor: Colors.orange)
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
                if let username = BlitzBuchUserDefaults(userDefaults: UserDefaults.standard).getUser()?.name {
                    cell.setCell(name: username)
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
            if generalType == .logout {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuGeneralCell") as? SideMenuGeneralCell {
                    cell.sideMenuCell = generalType
                    cell.setCell(title: generalType.title, imageName: generalType.imageName, counter: 0, imageTint: generalType.imageTint)
                    cell.isAccessibilityElement = true
                    cell.accessibilityIdentifier = "sideMenuLoginCell"
                    cell.layer.backgroundColor = UIColor.clear.cgColor
                    cell.contentView.backgroundColor = .clear
                    cell.backgroundColor = .clear
                    cell.layer.opacity = 0
                    cell.actionButton.rx.tap.subscribe(onNext: {[weak self] in
                            self?.getAlert(errorString: NSLocalizedString("You have been logged out!", comment: ""), errorColor: Colors.orange)
                            if let user = self?.blitzBuchUserDefaults.getUser() {
                                user.id = 0
                                user.numberOfRegularBooks = 0
                                user.numberOfVipBooks = 0
                                user.name = "--"
                                user.cartItems = ""
                                _ = self?.blitzBuchUserDefaults.saveUser(user)
                            }
                            self?.cartItemsCount = 0
                            self?.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
                            self?.reloadUsername()
                            self?.logoutUser()
                    }).disposed(by: cell.disposeBag)
                    return cell
                }
                
            }
            if generalType == .contact {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuGeneralCell") as? SideMenuGeneralCell {
                    cell.actionButton.isUserInteractionEnabled = false
                    cell.sideMenuCell = generalType
                    cell.setCell(title: generalType.title, imageName: generalType.imageName, counter: 0, imageTint: generalType.imageTint)
                    cell.layer.backgroundColor = UIColor.clear.cgColor
                    cell.contentView.backgroundColor = .clear
                    cell.backgroundColor = .clear
                    cell.layer.opacity = 0
                    cell.isUserInteractionEnabled = true
                    return cell
                }
            }
            if generalType == .cart {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuGeneralCell") as? SideMenuGeneralCell {
                    cell.actionButton.isUserInteractionEnabled = false
                    cell.sideMenuCell = generalType
                    cell.setCell(title: generalType.title, imageName: generalType.imageName, counter: cartItemsCount, imageTint: generalType.imageTint)
                    cell.layer.backgroundColor = UIColor.clear.cgColor
                    cell.contentView.backgroundColor = .clear
                    cell.backgroundColor = .clear
                    cell.layer.opacity = 0
                    cell.isUserInteractionEnabled = true
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
            case .logout:
                return
            case .contact:
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.mailHandler.sendEmail(presentedFrom: strongSelf)
                }
                return
            case .cart:
                print(indexPath)
                let vc = BlitzBuchCartViewController.get()
                vc.delegate = self
                vc.navigationController?.navigationBar.isHidden = true
                self.transition = CustomTransition(from: self, to: vc, fromFrame: nil, snapshot: nil, viewToHide: nil)
                let nav = UINavigationController(rootViewController: vc)
                nav.transitioningDelegate = self.transition
                nav.presentedViewController?.dismiss(animated: true, completion: nil)
                let attributes = [NSAttributedString.Key.font:UIFont(name: FontName.regular.value, size: FontSize.navigationTitle) ?? UIFont.systemFont(ofSize: FontSize.navigationTitle), NSAttributedString.Key.foregroundColor : Colors.blueDefault] as [NSAttributedString.Key : Any]
                nav.navigationBar.titleTextAttributes = attributes
                nav.modalPresentationStyle = .custom
                self.present(nav, animated: true, completion: nil)
                return
            }
        }
    }
    
}

// MARK: - CartCounterDelegate

extension SideMenuViewController: BlitzBuchCartVCDelegate {
    func reloadCartCounter() {
        if let cartItems = BlitzBuchUserDefaults(userDefaults: UserDefaults.standard).getUser()?.cartItems {
            var newCartItemsArray = [String]()
            if cartItems.contains(",") {
                cartItems.components(separatedBy: ",").forEach { bookId in
                    newCartItemsArray.append(bookId)
                }
            } else {
                newCartItemsArray.append(cartItems)
            }
            if newCartItemsArray.count == 1, newCartItemsArray.contains(where: {$0 == ""}) {
                self.cartItemsCount = 0
            } else {
                self.cartItemsCount = newCartItemsArray.count
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
