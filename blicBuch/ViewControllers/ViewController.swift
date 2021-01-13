//
//  ViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 11/17/19.
//  Copyright © 2019 sukydeveloper. All rights reserved.
//
/* Postupak prilikom ubacivanja u korpu:
 1. Na svim ekranima sa kojih se moze porucivati napraviti funciju koja radi proveru userDefaults vrednosti za
 broj dostupnih vip i regularnih knjiga
 2. Napraviti alert message dole sa brojem mogucih porucivanja "You have only ? vip book and ? regular books available for order. You have ? vip and ? regular books in your cart."
 3. Povezati sve ekrane sa ekranom za porucivanje - cart ekranom i ubaciti funkciju za ubacivanje novih knjiga u cart
 */

import UIKit
import MessageUI
import CoreData
import RxSwift
import Alamofire
import SideMenu
import Kingfisher
import RxCocoa
import RxSwift
import SideMenu



class ViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, NSFetchedResultsControllerDelegate {
    var homeBooksArray : [Book]?{
        didSet{
//            self.tableView2.layoutIfNeeded()
            self.tableView2.reloadData()
        }
        }
    let context = DataManager.shared.context
    var fetchResults:NSFetchedResultsController<NSManagedObject>?
    var frame : CGRect?
    var frameView : UIView?
    var snapshot : UIImage?
    private var transition: CustomTransition2?
    var book:Book?
    private var sideMenuController: SideMenuViewController?

    var tableContent = ["Einloggen", "Registrieren", "Kontakt", "SCHENKUNG", "Cart"]
    /*var tableContent1 = ["Login", "Sign up", "Contact us", "DONATE"]*/
    var arrayOfBookId = [Int32]()
    var alphaTest = 0
    var timer:Timer?
    let alertService = AlertService()
    var numberOfRegularBooks: String = {
            _ = blicBuchUserDefaults.set(.numberOfRegularBooks, value: 4)
            return blicBuchUserDefaults.get(.numberOfRegularBooks) as? String ?? ""
    }()
    var numberOfVipBooks: String = {
            _ = blicBuchUserDefaults.set(.numberOfVipBooks, value: 1)
            return blicBuchUserDefaults.get(.numberOfVipBooks) as? String ?? ""
    }()
    var numberOfRegularBooksInt = Int()
    var numberOfVipBooksInt = Int()
    
    
    @IBAction func vipButton(_ sender: Any) {
        if let tabController = UIApplication.shared.keyWindow?.rootViewController as? TabBarViewController {
            tabController.view.backgroundColor = .white
        if let vc = tabController.viewControllers?[2] {
            _ = tabController.tabBarController(tabController, shouldSelect: vc)
            vc.presentedViewController?.dismiss(animated: true, completion: nil)
            if let vc = vc as? UINavigationController {
                vc.popToRootViewController(animated: true)
            }
        }
    }
    }
    @IBOutlet weak var imageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView2: UITableView! {
        didSet{
            let customCellName = String(describing: CustomCell.self)
            tableView2.register(UINib(nibName: customCellName, bundle: nil), forCellReuseIdentifier: customCellName)
            
            let customCell = String(describing: BlueCloudCell.self)
            tableView2.register(UINib(nibName: customCell, bundle: nil), forCellReuseIdentifier: customCell)
        }
        }
    @IBOutlet weak var tableView1: UITableView!
    
    @IBOutlet weak var button1: UIButton!

    var disposeBag = DisposeBag()
    let networking = NetworkingService.shared
    
    override func viewDidLoad() {
        
        //MARK: - TESTING of login
        
        UsersService.getUser("test@yahoo.com", "Sada").subscribe { [weak self] (logedIn) in
            print("Da li je ulogovan: \(logedIn.description)")
            if logedIn == false {
                self?.getAlert(errorString: "Greska u login podacima, pokusajte ponovo", errorColor: Colors.orange)
            }
        } onError: { (error) in
            self.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
        } onCompleted: {
            //
        } onDisposed: {
            //
        }.disposed(by: self.disposeBag)

        fetch()
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissSideMenu), name: NSNotification.Name(rawValue: "enteredBackground"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.performLoginTransition), name: NSNotification.Name("loginHome"), object: nil)
        numberOfRegularBooksInt = Int(numberOfRegularBooks) ?? 0
        numberOfVipBooksInt = Int(numberOfVipBooks) ?? 0
        print("Broj dostupnih regularnih knjiga \(numberOfRegularBooksInt)")
        print("Broj dostupnih vip knjiga \(numberOfVipBooksInt)")

//        timer?.invalidate()
//            self.timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { (timer) in
//                BooksService.getAll().subscribe(onNext: { (finished) in
//                    print("refreshed data")
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//                        self.fetch()
//                    })
//                }, onError: { (error) in
//                    print(error)
//                }, onCompleted: {
//
//
//                }) {
//
//                }.disposed(by: self.disposeBag)
//            })

//        let url = "\(Router.books.fullUrl())"
//        print(url)
        alphaTest = 0
        if alphaTest == 0 {
                self.tableView1.alpha = 0
                self.tableView1.frame = CGRect(x: self.button1.center.x, y:  self.button1.center.y, width: 0, height: 0)

        }
         
        tableView2.delegate = self
        tableView2.dataSource = self
        tableView2.layer.borderColor = UIColor.gray.cgColor
        tableView2.layer.borderWidth = 0.3
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView1.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        tableView1.layer.borderWidth = 0.22
    tableView1.translatesAutoresizingMaskIntoConstraints = false
        tableView2.translatesAutoresizingMaskIntoConstraints = false
        definesPresentationContext = true
        /*Alamofire.request(Router.books.fullUrl(), method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success(let books):
                
                BooksService.getAll().subscribe(onNext: { (finished) in

                                           }, onError: { (error) in
                print(error)
                                          }, onCompleted: {
                                            print(books)
                print("SUCESSSSSS")
                                           }) {

                                           }.disposed(by: self.disposeBag)
                    
            case .failure(let error):
                print("ERROR \(error)")
            }
        }*/
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetch()
//        BooksService.updateBook(bookId: 152).subscribe { (finished) in
//            print("Updated")
//        } onError: { (error) in
//            print("error updating")
//        } onCompleted: {
//            //
//        } onDisposed: {
//            //
//        }.disposed(by: self.disposeBag)

//        DispatchQueue.main.async {
//            let id: Int32 = 157
//
//                BooksService.deleteBook(bookId: id).subscribe(onNext: { [weak self](finished) in
//                    print(finished)
//                    }, onError: { (error) in
//                        print(error)
//                }, onCompleted: {
//
//                }) {
//
//                }.disposed(by: self.disposeBag)
//
//        }
    }
    
//    func fetch(){
//        let fetchRequest: NSFetchRequest<Books> = Books.fetchRequest()
//
//
//            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
//            fetchRequest.fetchLimit = 5
//
////        }
//
//        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataManager.shared.context, sectionNameKeyPath: nil, cacheName: nil)
//        fetchedResultsController.delegate = self
//        self.fetchResults = fetchedResultsController as? NSFetchedResultsController<NSManagedObject>
//        try! fetchResults?.performFetch()
//        self.tableView2?.reloadData()
//
//    }
    
    func fetch(){
            let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
            
           // fetchRequest.predicate = NSPredicate(format: "id > 121 && id < 127", [])
    //        if let activeSort = sort.getActive() {
    //            fetchRequest.sortDescriptors = activeSort.compactMap({NSSortDescriptor(key: $0.0, ascending: $0.1)})
    //        }else{
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
                fetchRequest.fetchLimit = 5
                
    //        }
            
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
            self.fetchResults = fetchedResultsController as? NSFetchedResultsController<NSManagedObject>
            try! fetchResults?.performFetch()
        homeBooksArray?.removeAll()
        homeBooksArray = fetchResults?.fetchedObjects as? [Book]
        homeBooksArray?.forEach({ (book) in
            print(book)
        })
        self.tableView2.reloadData()
        }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numOfRows = Int()
        if tableView == tableView1 {
            numOfRows = tableContent.count
        }
        else if tableView == tableView2 {
            
            numOfRows = 6
            
        }
        return numOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.selectionStyle = .none
        if tableView == tableView1 {
        cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let cellDonate = UIImage(named: "img_menu_donate")
        let cellLogIn = UIImage(named: "login")
        let cellRegistration = UIImage(named: "registration")
            let cellCart = UIImage(named: "img_menu_donate")
        let cellLocation = tableContent[indexPath.row]
            cell.textLabel?.text = cellLocation
            let cellContact = UIImage(named: "img_contact")
        let aColor = UIColor(hexString: "#5cbff2")
            cell.textLabel?.textColor = aColor
            let cellContactColored = cellContact?.withTintColor(aColor)
            
            
            switch indexPath.row {
            case 0:
                cell.imageView?.image = cellLogIn
            case 1:
                cell.imageView?.image = cellRegistration
            case 2:
                cell.imageView?.image = cellContactColored
            case 3:
                cell.imageView?.image = cellDonate
                cell.textLabel?.textColor = .orange
            case 4:
                cell.imageView?.image = cellCart
            default:
                print("No cell index")
            }
            cell.translatesAutoresizingMaskIntoConstraints = false
            cell.selectionStyle = .default
            cell.layer.masksToBounds = true
            cell.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.8)
            cell.layer.borderWidth = 0.22
            cell.textLabel?.font = UIFont(name: "Roboto-Regular", size: 16)
            
            cell.isUserInteractionEnabled = true
            
        } else if tableView == tableView2 {
            
            if indexPath.row < 5 {

                let model = homeBooksArray?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomCell.self), for: indexPath) as! CustomCell
                if let item = model  {
                    cell.set(with: item, inVipController: false)
                print(item.id)
                
            cell.cellDelegate = self
            cell.index = indexPath
                    cell.orderButton.rx.tap.subscribe(onNext: {[weak self] in
                        let request = CartBook.fetchRequest() as NSFetchRequest
                        request.predicate = NSPredicate(format: "id == %d", item.id)
                        let fetchedCartBooks = try! DataManager.shared.context.fetch(request)
                        let cartBook = fetchedCartBooks.first
                        self?.navigationController?.view.startActivityIndicator()
                        BooksService.checkLock(bookId: item.id).subscribe { (locked) in
                            self?.onClick(index: 1)
                            if locked == true {
                                if cartBook?.inCart == false {
                                self?.getAlert(errorString: "Knjiga je vec rezervisana", errorColor: Colors.orange)
                                } else {
                                    self?.getAlert(errorString: "Knjiga se vec nalazi u korpi", errorColor: Colors.orange)
                                }
                            } else {
                                if item.vip == true {
                                    if let vipBooks = blicBuchUserDefaults.get(.numberOfVipBooks) as? Int {
                                        if vipBooks > 0 {
                                            if cartBook?.inCart == false {
                                                cartBook?.inCart = true
                                                _ = blicBuchUserDefaults.set(.numberOfVipBooks, value: vipBooks - 1)
                                                self?.getAlert(errorString: "Knjiga je dodata u korpu", errorColor: Colors.blueDefault)
                                                item.locked = LockStatus.locked.rawValue
                                                BooksService.lockBook(bookId: item.id, lockStatus: .locked).subscribe { [weak self] (finished) in
                                                    print(finished.description)
                                                } onError: { (error) in
                                                    self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                                                } onCompleted: {
                                                    //
                                                } onDisposed: {
                                                    //
                                                }.disposed(by: cell.disposeBag)
                                            } else {
                                                self?.getAlert(errorString: "Knjiga se vec nalazi u korpi", errorColor: Colors.orange)
                                            }
                                        } else {
                                            if cartBook?.inCart == true {
                                                self?.getAlert(errorString: "Knjiga se vec nalazi u korpi", errorColor: Colors.orange)
                                            } else {
                                                self?.getAlert(errorString: "Iskoristili ste limit za VIP knjige", errorColor: Colors.orange)
                                            }
                                        }
                                    }
                                }
                                if item.vip == false {
                                    if let books = blicBuchUserDefaults.get(.numberOfRegularBooks) as? Int {
                                        if books > 0 {
                                            if cartBook?.inCart == false {
                                                cartBook?.inCart = true
                                                _ = blicBuchUserDefaults.set(.numberOfRegularBooks, value: books - 1)
                                                self?.getAlert(errorString: "Knjiga je dodata u korpu", errorColor: Colors.blueDefault)
                                                item.locked = LockStatus.locked.rawValue
                                                BooksService.lockBook(bookId: item.id, lockStatus: .locked).subscribe { [weak self] (finished) in
                                                    print(finished.description)
                                                } onError: { (error) in
                                                    self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                                                } onCompleted: {
                                                    //
                                                } onDisposed: {
                                                    //
                                                }.disposed(by: cell.disposeBag)
                                            } else {
                                                self?.getAlert(errorString: "Knjiga se vec nalazi u korpi", errorColor: Colors.orange)
                                            }
                                        } else {
                                            if cartBook?.inCart == true {
                                                self?.getAlert(errorString: "Knjiga se vec nalazi u korpi", errorColor: Colors.orange)
                                            } else {
                                                self?.getAlert(errorString: "Iskoristili ste limit za obicne knjige", errorColor: Colors.orange)
                                            }
                                        }
                                    }
                                }
                            }
                            self?.navigationController?.view.stopActivityIndicator()
                        } onError: { (error) in
                            self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                        } onCompleted: {
                            //
                        } onDisposed: {
                            //
                        }.disposed(by: cell.disposeBag)

                        do {
                            try DataManager.shared.context.save()
                        } catch {
                            self?.getAlert(errorString: "Error saving data", errorColor: Colors.orange)
                        }
                        
                    }).disposed(by: cell.disposeBag)
                    return cell
                }
            } else {
                
                
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BlueCloudCell.self), for: indexPath) as! BlueCloudCell
                cell.imageView?.frame.size.height = 20
                
            }
            
        }
        return cell
    }
    
    @objc func alert () {
        let newAlert = UIAlertController(title: "NOVI", message: "FUCKING CONTROLER", preferredStyle: .alert)
        present(newAlert, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()
        if tableView.tag == 1 {
            height = 40
        } else if tableView.tag == 2 {
            height = 182
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableView1 {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "login", sender: self)
        }
        if indexPath.row == 1 {
            performSegue(withIdentifier: "registration", sender: self)
           
            
        }
        if indexPath.row == 2 {
            self.sendEmail()
        }
        if indexPath.row == 3 {
            performSegue(withIdentifier: "donate", sender: self)
        }
            if indexPath.row == 4 {
            performSegue(withIdentifier: "cart", sender: self)
        }
    }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCart" {
            _ = segue.destination as? CartTableView
        }
        self.disposeBag = DisposeBag()
    }
    
   
    @IBAction func buttonAction(_ sender: Any) {
        if let vc = (UIApplication.shared.delegate as? AppDelegate)?.getSideMenu() {
            sideMenuController = vc
            let menu = SideMenuNavigationController(rootViewController: vc)
            menu.leftSide = true
            if self.traitCollection.userInterfaceStyle == .dark {
                    menu.settings.blurEffectStyle = .systemMaterialDark
            } else {
                    menu.settings.blurEffectStyle = .systemMaterialLight
            }
            menu.pushStyle = .default
            menu.presentationStyle = .menuSlideIn
            menu.presentationStyle.menuOnTop = true
            menu.menuWidth = self.view.frame.size.width * 0.8
            menu.presentationStyle.presentingEndAlpha = 0.5
            menu.statusBarEndAlpha = 0
            menu.presentationStyle.onTopShadowOffset = CGSize(width: 3, height: 0)
            menu.enableSwipeToDismissGesture = true
            menu.dismissWhenBackgrounded = true
            vc.navigationController?.setNavigationBarHidden(true, animated: false)
            present(menu, animated: true, completion: nil)
    }
    }
    
    @objc func dismissSideMenu(){
        sideMenuController?.dismiss(animated: true, completion: nil)
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

    // func for sending mail
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @objc func performLoginTransition(){
        let vc = LoginViewController.get()
        let newFrame = CGRect(x: (frame?.origin.x)! + 66, y: (frame?.origin.y)!, width: 30, height: 30)
        self.transition = CustomTransition2(from: self, to: vc, fromFrame: newFrame, snapshot: nil, viewToHide: nil)
        vc.transitioningDelegate = self.transition
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
    }
    
}


extension ViewController: AlertMe {
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
      
    }//alert for table cell button
    
    
}
