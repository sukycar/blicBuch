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
    
    var fetchResults:NSFetchedResultsController<NSManagedObject>?
    var book : Books?
    //var genre : Books.Genre?
    var genre:Books.Genre = .avantura
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
    
    
    var books = [Books]()
    var booksInGenre = [Books]()
    //private var dataSource:[Book] = []
    //var books = Books()
    
    @IBOutlet var mainTable: UITableView!
    
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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        for book in books {
            if book.genre == self.genre.title{
                booksInGenre.append(book)
            }
        }
        print(booksInGenre.count)
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return booksInGenre.count// for other categories should be added
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = mainTable.dequeueReusableCell(withIdentifier: String(describing: CustomCell.self), for:indexPath) as! CustomCell
        let item = booksInGenre[indexPath.row]
            cell.set(with: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()
        
            height = 182
       
        return height
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
     
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

