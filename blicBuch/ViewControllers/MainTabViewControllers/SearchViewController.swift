//
//  SearchViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 12/1/19.
//  Copyright © 2019 sukydeveloper. All rights reserved.
//

import UIKit
import CoreData
import RxSwift


class SearchViewController: BaseViewController, UITextFieldDelegate, UISearchResultsUpdating, NSFetchedResultsControllerDelegate, UISearchBarDelegate {
    
    private var dataSource:[Book] = []
    private var mainFilteredData:[Book] = [Book()]
    private var filteredDataSource:[Book] = []
    private let context = DataManager.shared.context
    private var weReccomend = [Book]()
    private var resultsSearchController = UISearchController()
    private var searching = false
    private var alertService = AlertService()

    var fetchResults:NSFetchedResultsController<NSManagedObject>?
    
    @IBOutlet weak var searchTable: UITableView! {
        didSet {
            searchTable.delegate = self
            searchTable.dataSource = self
            let customCellName = String(describing: BookTableViewCell.self)
            searchTable.register(UINib(nibName: customCellName, bundle: nil), forCellReuseIdentifier: customCellName)
        }
    } // Initialize table with customCell
    @IBOutlet weak var viewForBorder: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var searchBar1: UISearchBar!
    @IBOutlet weak var sugestionsLabel: UILabel!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
        fetchRecommendedBooks()
        mainFilteredData = dataSource
        filteredDataSource = weReccomend
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentLoginView), name: LoginNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentRegisterView), name: RegisterNotificationName, object: nil)
        fetch()
        fetchRecommendedBooks()
        searchTable.reloadData()
        filteredDataSource = weReccomend
        searchTable.delegate = self
        searchTable.dataSource = self
        searchTable.resignFirstResponder()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        viewForBorder.addBottomBorder(color: .orange, margins: 0, borderLineSize: 1)
        configureSearch()
    }
    
    override func viewDidLayoutSubviews() {
        searchBar1.text = ""
        self.sugestionsLabel.alpha = 1
    }
    
    func configureSearch(){
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.delegate = searchBar1.delegate
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        print(text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != "" {
            searching = true
            self.sugestionsLabel.alpha = 0
            filteredDataSource = mainFilteredData.filter({ (book) -> Bool in
                guard let text = searchBar.text else { return false }
                return (book.title?.uppercased().contains(text.uppercased()))!
            })
        } else {
            searching = false
            self.sugestionsLabel.alpha = 1
            filteredDataSource = weReccomend
        }
        DispatchQueue.main.async {
            self.searchTable.reloadData()
        }
        
    }
    
    func fetch(){
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataManager.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        self.fetchResults = fetchedResultsController as? NSFetchedResultsController<NSManagedObject>
        try! fetchResults?.performFetch()
        dataSource = fetchResults?.fetchedObjects as! [Book]
        DispatchQueue.main.async {
            self.searchTable.reloadData()
        }
    }
    
    func fetchRecommendedBooks(){
        let request = Book.fetchRequest() as NSFetchRequest
        let predicate = NSPredicate(format: "weRecommend == true")
        request.predicate = predicate
        do {
            if let fetchedBooks = try context?.fetch(request){
                weReccomend = fetchedBooks
            }
        } catch {
            print("Books not fetched")
        }
        DispatchQueue.main.async {
            self.searchTable.reloadData()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar1.resignFirstResponder()
    }
    
    // MARK: - TABLE VIEW SOURCE AND DATA

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching == false {
            return weReccomend.count
        } else {
            return filteredDataSource.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BookTableViewCell.self), for: indexPath) as! BookTableViewCell
        let item = filteredDataSource[indexPath.row]
        cell.set(with: item, inVipController: false)
        cell.orderButton.rx.tap.subscribe(onNext: {[weak self] in
            if let logedIn = blicBuchUserDefaults.get(.logedIn) as? Bool{
                var cartItems = blicBuchUserDefaults.get(.cartItems) as? [String]
                if logedIn == true {
//                    let request = CartBook.fetchRequest() as NSFetchRequest
//                    request.predicate = NSPredicate(format: "id == %d", item.id)
//                    let fetchedCartBooks = try! DataManager.shared.context.fetch(request)
//                    let cartBook = fetchedCartBooks.first
                    self?.navigationController?.view.startActivityIndicator()
                    BooksService.checkLock(bookId: item.id).subscribe { (locked) in
                        if locked == true {
                            if !(cartItems?.contains(String(item.id)) ?? false) {
                                self?.getAlert(errorString: "Knjiga je vec rezervisana", errorColor: Colors.orange)
                            } else {
                                self?.getAlert(errorString: "Knjiga se vec nalazi u korpi", errorColor: Colors.orange)
                            }
                        } else {
                            if item.vip == true {
                                guard let id = blicBuchUserDefaults.get(.id) as? Int32 else {return}
                                UsersService.checkForAvailableBooks(id).subscribe {(vip, regular) in
                                    let vip = vip
                                    let regular = regular
                                    if vip > 0 {
                                        self?.updateBooksNumber(vip: true, removeBooks: true, numberOfBooks: 1, disposeBag: cell.disposeBag)
                                            if !(cartItems?.contains(String(item.id)) ?? false) {
                                                _ = blicBuchUserDefaults.set(.numberOfRegularBooks, value: regular)
                                                self?.getAlert(errorString: "Knjiga je dodata u korpu", errorColor: Colors.blueDefault)
                                                item.locked = LockStatus.locked.rawValue
                                                cartItems?.append(String(item.id))
                                                BooksService.lockBook(bookId: item.id, lockStatus: .locked).subscribe { [weak self] (finished) in
                                                    let lockedBookId = (String(item.id))
                                                    self?.lockedBooks.append(lockedBookId)
                                                    var cartBooks = blicBuchUserDefaults.get(.cartItems) as? [String] ?? [""]
                                                    cartBooks.append(lockedBookId)
                                                    var newCartBooks = cartBooks
                                                    newCartBooks = Array(Set(newCartBooks))
                                                    let clearBooksArray = newCartBooks.filter({return $0 != ""})
                                                    _ = blicBuchUserDefaults.set(.cartItems, value: clearBooksArray) as! [String]
                                                    UsersService.updateCartBooks(userId: id, bookIDs: clearBooksArray).subscribe { (subscribed) in
                                                        //
                                                    } onError: { (error) in
                                                        self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                                                    } onCompleted: {
                                                        //
                                                    }.disposed(by: cell.disposeBag)

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
                                        if (cartItems?.contains(String(item.id)) ?? false) {
                                            self?.getAlert(errorString: "Knjiga se vec nalazi u korpi", errorColor: Colors.orange)
                                        } else {
                                            self?.getAlert(errorString: "Iskoristili ste limit za vip knjige", errorColor: Colors.orange)
                                        }
                                    }
                                    
                                    
                                    
                                } onError: { (error) in
                                    self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                                } onCompleted: {
                                    //
                                } onDisposed: {
                                    //
                                }.disposed(by: cell.disposeBag)
                            }
                            if item.vip == false {
                                guard let id = blicBuchUserDefaults.get(.id) as? Int32 else {return}
                                UsersService.checkForAvailableBooks(id).subscribe {(vip, regular) in
                                    let vip = vip
                                    let regular = regular
                                    if regular > 0 {
                                        self?.updateBooksNumber(vip: false, removeBooks: true, numberOfBooks: 1, disposeBag: cell.disposeBag)
                                        
                                            if !(cartItems?.contains(String(item.id)) ?? false) {
                                                _ = blicBuchUserDefaults.set(.numberOfRegularBooks, value: regular)
                                                self?.getAlert(errorString: "Knjiga je dodata u korpu", errorColor: Colors.blueDefault)
                                                item.locked = LockStatus.locked.rawValue
//                                                cartBook?.inCart = true
                                                cartItems?.append(String(item.id))
                                                BooksService.lockBook(bookId: item.id, lockStatus: .locked).subscribe { [weak self] (finished) in
                                                    let lockedBookId = (String(item.id))
                                                    self?.lockedBooks.append(lockedBookId)
                                                    var cartBooks = blicBuchUserDefaults.get(.cartItems) as? [String] ?? [""]
                                                    cartBooks.append(lockedBookId)
                                                    var newCartBooks = cartBooks
                                                    newCartBooks = Array(Set(newCartBooks))
                                                    let clearBooksArray = newCartBooks.filter({return $0 != ""})
                                                    _ = blicBuchUserDefaults.set(.cartItems, value: clearBooksArray) as! [String]
                                                    UsersService.updateCartBooks(userId: id, bookIDs: clearBooksArray).subscribe { (subscribed) in
                                                        //
                                                    } onError: { (error) in
                                                        self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                                                    } onCompleted: {
                                                        //
                                                    }.disposed(by: cell.disposeBag)
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
                                        if (cartItems?.contains(String(item.id)) ?? false) {
                                            self?.getAlert(errorString: "Knjiga se vec nalazi u korpi", errorColor: Colors.orange)
                                        } else {
                                            self?.getAlert(errorString: "Iskoristili ste limit za obicne knjige", errorColor: Colors.orange)
                                        }
                                    }
                                    
                                    
                                    
                                } onError: { (error) in
                                    self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
                                } onCompleted: {
                                    //
                                } onDisposed: {
                                    //
                                }.disposed(by: cell.disposeBag)
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
                } else {
                    self?.onClick()
                }
            }
        }).disposed(by: cell.disposeBag)
        
        return cell
    }
}


extension SearchViewController{
    @objc func presentLoginView(){
        let vc = LoginViewController.get()
        vc.modalPresentationStyle = .formSheet
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentRegisterView(){
        let vc = RegisterViewController.get()
        vc.modalPresentationStyle = .formSheet
        self.present(vc, animated: true, completion: nil)
    }
}

extension SearchViewController: AlertMe {
    func onClick() {
        let alertVC = alertService.alert()
        self.present(alertVC, animated: true)
    }
}
