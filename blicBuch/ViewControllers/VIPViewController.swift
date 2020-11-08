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

    var books = [Books]()
    var booksInVip = [Books]()
    func fetch(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Books")
        
        do {
            let results = try context.fetch(fetchRequest)
            let booksCreated = results as! [Books]
            
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
    var book:Books?
        
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
    func onClick(index: Int) {
        let alertVC = alertService.alert()
        present(alertVC, animated: true)
    }//alert for table cell button
    
}
