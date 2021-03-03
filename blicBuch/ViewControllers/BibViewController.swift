//
//  BibViewController.swift
//  
//
//  Created by Vladimir Sukanica on 12/21/19.
//

import UIKit

class BibliotechViewController: BaseViewController {
    
    @IBOutlet weak var tabBar: UITabBarItem!
    @IBOutlet weak var borderView: UIView!//view for adding border below label
    var genre: Book.Genre = .avantura
    
    @IBOutlet weak var genreTable: UITableView! {
        didSet {
            genreTable.delegate = self
            genreTable.dataSource = self
            let customCellName = String(describing: CategoryTableViewCell.self)
            
            genreTable.register(UINib(nibName: customCellName, bundle: nil), forCellReuseIdentifier: customCellName)
        }
    }
    
    var dataSource = ["Das Abenteuer", "Lebenslauf" ,"Detektiv-Romane /Kriminalromane" ,"Das epische Fantasy Romangenre","Erotikromane/Liebesromane","Klassikliteratur","Popularpsychologie","Thriller","Historische Romane","Sonstiges","Horror","Aktion","Roman"]
    var indexNumber = Int()
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if let path = genreTable.indexPathForSelectedRow {
            genreTable.deselectRow(at: path, animated: true)
        }
        
        genreTable.delegate = self
        genreTable.dataSource = self
        
        borderView.addBottomBorder(color: .gray, margins: 0, borderLineSize: 0.3)
        genreTable.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let model = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:CategoryTableViewCell.self), for:indexPath) as! CategoryTableViewCell
        cell.contentLabel.text = model
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch indexPath.row {
        case 0:
            self.genre = .avantura
        case 1:
            self.genre = .biografija
        case 2:
            self.genre = .detektivski
        case 3:
            self.genre = .epski
        case 4:
            self.genre = .erotski
        case 5:
            self.genre = .klasika
        case 6:
            self.genre = .psihologija
        case 7:
            self.genre = .triler
        case 8:
            self.genre = .istorijski
        case 9:
            self.genre = .ostalo
        case 10:
            self.genre = .horor
        case 11:
            self.genre = .akcija
        case 12:
            self.genre = .roman
        default:
            print("Select row")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            let transition = CATransition()
            transition.duration = 0.7
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.performSegue(withIdentifier: "bibliotech", sender: self)
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    var imageArray = [UIImage(named: "image1"), UIImage(named: "image2"), UIImage(named: "image3"), UIImage(named: "image4"), UIImage(named: "image5")]
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bibliotech" {
            let newController = segue.destination as! UINavigationController
            let tableViewCTRL = newController.topViewController as! GenreViewController
            tableViewCTRL.genre = self.genre
            
            //tableViewCTRL.modelSwitch = indexNumber
            
            
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
}




