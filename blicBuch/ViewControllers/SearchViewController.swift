//
//  SearchViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 12/1/19.
//  Copyright © 2019 sukydeveloper. All rights reserved.
//

import UIKit
import CoreData


class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchResultsUpdating, NSFetchedResultsControllerDelegate, UISearchBarDelegate {
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
            sugestionsLabel.alpha = 1
            filteredDataSource = weReccomend
            searchTable.reloadData()
        }
        searchTable.reloadData()
    }
    var fetchResults:NSFetchedResultsController<NSManagedObject>?
    func fetch(){
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataManager.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        self.fetchResults = fetchedResultsController as? NSFetchedResultsController<NSManagedObject>
        try! fetchResults?.performFetch()
        dataSource = fetchResults?.fetchedObjects as! [Book]
        self.searchTable.reloadData()
        
    }
    
    private var dataSource:[Book] = []
    private var mainFilteredData:[Book] = [Book()]
    private var filteredDataSource:[Book] = []
    
    var weReccomend = [Book]()
    var resultsSearchController = UISearchController()
    var searching = false
    
    
    @IBOutlet weak var searchTable: UITableView! {
        didSet {
            searchTable.delegate = self
            searchTable.dataSource = self
            let customCellName = String(describing: CustomCell.self)
            searchTable.register(UINib(nibName: customCellName, bundle: nil), forCellReuseIdentifier: customCellName)
        }
    } // Initialize table with customCell
    @IBOutlet weak var viewForBorder: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var searchBar1: UISearchBar!
    @IBOutlet weak var sugestionsLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetch()
        mainFilteredData = dataSource.filter( { (book) -> Bool in
            if book.id < 122 || book.id > 126 {
                return true
            }
            return false
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetch()
        weReccomend = dataSource.filter({ (book) -> Bool in
            if book.id > 121 && book.id < 127 {
                return true
            }
            return false
        })
        
        searchTable.reloadData()
        print(mainFilteredData.count)
        print(weReccomend.count)
        filteredDataSource = weReccomend
        searchTable.delegate = self
        searchTable.dataSource = self
        searchTable.resignFirstResponder()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        viewForBorder.addBottomBorder(color: .orange, margins: 0, borderLineSize: 1)
        
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.delegate = searchBar1.delegate
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching == false {
            return weReccomend.count
        } else {
            return filteredDataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomCell.self), for: indexPath) as! CustomCell
        let filtered = filteredDataSource[indexPath.row]
        cell.set(with: filtered)
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar1.resignFirstResponder()
    }
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension UIView {
    func addBottomBorder(color: UIColor = UIColor.red, margins: CGFloat = 0, borderLineSize: CGFloat = 1) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .height,
                                                multiplier: 1, constant: borderLineSize))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .leading,
                                              multiplier: 1, constant: margins))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .trailing,
                                              multiplier: 1, constant: margins))
    }
    
}

