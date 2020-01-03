//
//  SearchViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 12/1/19.
//  Copyright © 2019 sukydeveloper. All rights reserved.
//

import UIKit



class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    private var dataSource:[Book] = []
    
    var list = [String]()
    var filteredList = [String]()
    var resultsSearchController = UISearchController()
    var searching = true
    

   
    @IBOutlet weak var searchTable: UITableView!
    
    @IBOutlet weak var viewForBorder: UIView!
    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var searchBar1: UISearchBar!
    
    func generateModel() {
        dataSource = [
            Book(imageName: "image1", title: "People Who Eat Darkness: Love, Grief and a Journey into Japan's Shadows", authors: ["Richard Lloyd Parry"], genre: "Crime"),
            Book(imageName: "image2", title: "In Cold Blood", authors: ["Truman Capote"], genre: "Comedy"),
            Book(imageName: "image3", title: "And the Sea Will Tell", authors: ["Vinsent Bugliosi", "Bruce Henderson"], genre: "Bibliography & Momories"),
            Book(imageName: "image4", title: "Midnight in the Garden of Good and Evil: A Savannah Story", authors: ["John Berendt"], genre: "Horror"),
            Book(imageName: "image5", title: "Tinseltown: Murder, Morphine, and Madness at the Dawn of Hollywood", authors: ["William J. Mann"], genre: "Music"),
        ]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        generateModel()
        
        dataSource.forEach { (book) in
            list.append(book.title)
        }
        
        
        
        searchTable.delegate = self
        searchTable.dataSource = self
       
        
        viewForBorder.addBottomBorder(color: .orange, margins: 0, borderLineSize: 1)
       
   
        
        
        // Do any additional setup after loading the view.
    }
   
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return list.count
        } else {
            return filteredList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if searching {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "searchCell")!
            cell1.textLabel?.text = list[indexPath.row]
            cell1.textLabel?.textColor = .orange
            cell = cell1
        } else {
            let model = dataSource[indexPath.row]
            
            let cell2 = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomCell.self), for: indexPath) as! CustomCell
            
            cell2.configure(with: model)
            
            
            cell = cell2
            
        }
        return cell
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

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredList = list.filter({$0.prefix(searchText.count) == searchText})
        searching = false
        searchTable.reloadData()
    }
}


