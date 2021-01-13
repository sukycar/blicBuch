//
//  GenreTableViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 12/24/19.
//  Copyright © 2019 sukydeveloper. All rights reserved.
//

import UIKit
import CoreData
import RxSwift


class GenreTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var book : Book?
    var genre: Book.Genre = .avantura
    var books = [Book]()
    var booksInGenre = [Book]()
    
    @IBOutlet weak var holderView: UIView!//holder for uiimage view
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var genreLabel: UIButton!
    @IBAction func back(_ sender: Any) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
        
    }
    @IBOutlet var mainTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        for book in books {
            if book.genre == self.genre.title{
                booksInGenre.append(book)
            }
        }
        pictureView.contentMode = .scaleAspectFit
        pictureView.addBottomBorderGray()
        genreLabel.setTitle(genre.title, for: .normal)
        mainTable.delegate = self
        mainTable.dataSource = self
        
        let customCellName = String(describing: CustomCell.self)
        mainTable.register(UINib(nibName: customCellName, bundle: nil), forCellReuseIdentifier: customCellName)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksInGenre.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTable.dequeueReusableCell(withIdentifier: String(describing: CustomCell.self), for:indexPath) as! CustomCell
        let item = booksInGenre[indexPath.row]
        cell.set(with: item, inVipController: false)
        cell.index = indexPath
        cell.orderButton.rx.tap.subscribe(onNext: {[weak self] in
            let request = CartBook.fetchRequest() as NSFetchRequest
            request.predicate = NSPredicate(format: "id == %d", item.id)
            let fetchedCartBooks = try! DataManager.shared.context.fetch(request)
            let cartBook = fetchedCartBooks.first
            self?.navigationController?.view.startActivityIndicator()
            BooksService.checkLock(bookId: item.id).subscribe { (locked) in
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()
        height = 182
        return height
    }
    
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
    
   
}


//extension GenreTableViewController {
//    class func getController(for book:Books?, and type: Genre) -> GenreTableViewController {
//        let vc = UIStoryboard(name: "GenreTableViewController", bundle: nil).instantiateViewController(identifier: "GenreTableViewController") as! GenreTableViewController
//        vc.book = book
//        vc.genre = type
//        return vc
//    }
//}

extension UIView {
    func addBottomBorderGray(color: UIColor = UIColor.lightGray, margins: CGFloat = 0, borderLineSize: CGFloat = 0.3) {
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

