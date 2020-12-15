//
//  VIPViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 1/2/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit
import MessageUI
import CoreData
import RxSwift
import Alamofire

class VIPViewController: UIViewController, NSFetchedResultsControllerDelegate {

    var books = [Book]()
    var booksInVip = [Book]()
    
    func fetch(){
        let context = DataManager.shared.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        
        do {
            let results = try context?.fetch(fetchRequest)
            let booksCreated = results as! [Book]
            
            for _booksCreated in booksCreated {
                books.append(_booksCreated)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    var sort = [SortModel](){
        didSet{
        }
    }
    var book:Book?
        
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            let customCellName = String(describing: CustomCell.self)
            tableView.register(UINib(nibName: customCellName, bundle: nil), forCellReuseIdentifier: customCellName)
            
            
        }
    }
    let alertService = AlertService()
    
    override func viewDidLoad() {
//        super.viewDidLoad()
        fetch()
        tableView.delegate = self
        tableView.dataSource = self

        for book in books {
            if book.vip == true{
                booksInVip.append(book)
            }
        }
        let customCellName = String(describing: CustomCell.self)
        tableView.register(UINib(nibName: customCellName, bundle: nil), forCellReuseIdentifier: customCellName)
        // Do any additional setup after loading the view.
    }

    
}

extension VIPViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksInVip.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = booksInVip[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomCell.self), for: indexPath) as! CustomCell
                cell.set(with: model)
        cell.cellDelegate = self
        cell.index = indexPath
        return cell
    }
    
    @objc func alert () {
        let newAlert = UIAlertController(title: "NOVI", message: "FUCKING CONTROLER", preferredStyle: .alert)
        present(newAlert, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()

       
            height = 182
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension VIPViewController: AlertMe {
    func selectedBook(id: Int32) {
        print(id)
    }
    func onClick(index: Int) {
        let availableBooks = blicBuchUserDefaults.get(.numberOfVipBooks)
        let selectedVipBooks = blicBuchUserDefaults.get(.selectedVipBooks)
        let selectedBooksString = selectedVipBooks as? String
        let availableBooksString = availableBooks as? String
        let selectedBooks = Int(selectedBooksString ?? "0") ?? 0
        let availableVipBooks = Int(availableBooksString ?? "0") ?? 0
        if selectedBooks >= availableVipBooks {
            print("Previse izabrano")
            print(selectedBooks.description)
            let alertController = UIAlertController.init(title: "PREKORACEN LIMIT", message: "Prekoracili ste limit za VIP knjige. Kontaktirajte nas klub.", preferredStyle: .alert)
            alertController.addAction(.init(title: "OK", style: .default, handler: { (action) in
                print("Closed")
            }))
            self.present(alertController, animated: true, completion: nil)
//        let alertVC = alertService.alert()
//        present(alertVC, animated: true)
        } else {
            let addedValue = String(selectedBooks + 1)
            _ = blicBuchUserDefaults.set(.selectedVipBooks, value: addedValue)
            print(selectedBooks)
            print("Ovde ubaciti funkciju za popunjavanje cart-a")
            
        }
    }//alert for table cell button
    
}
