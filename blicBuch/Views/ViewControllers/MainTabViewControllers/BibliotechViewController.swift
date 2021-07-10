//
//  BibViewController.swift
//  
//
//  Created by Vladimir Sukanica on 12/21/19.
//

import UIKit

class BibliotechViewController: BaseViewController {
    
    @IBOutlet weak var tabBar: UITabBarItem!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var genreTable: UITableView!
    
    var genre: Book.Genre = .avantura
    fileprivate var dataSource = ["Das Abenteuer", "Lebenslauf" ,"Detektiv-Romane /Kriminalromane" ,"Das epische Fantasy Romangenre","Erotikromane/Liebesromane","Klassikliteratur","Popularpsychologie","Thriller","Historische Romane","Sonstiges","Horror","Aktion","Roman"]
    private var indexNumber = Int()
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        dataSource.sort { (String1, String2) -> Bool in
            String1 < String2
        }
        if let path = genreTable.indexPathForSelectedRow {
            genreTable.deselectRow(at: path, animated: true)
        }
        borderView.addBottomBorder(color: .gray, margins: 0, borderLineSize: 0.3)
    }
    
    override func configureTable() {
        genreTable.delegate = self
        genreTable.dataSource = self
        let customCellName = String(describing: CategoryTableViewCell.self)
        genreTable.register(UINib(nibName: customCellName, bundle: nil), forCellReuseIdentifier: customCellName)
        genreTable.tableFooterView = UIView()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:CategoryTableViewCell.self), for:indexPath) as! CategoryTableViewCell
        cell.set(with: model)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataSource[indexPath.row]
        switch model {
        case "Das Abenteuer":
            self.genre = .avantura
        case "Lebenslauf":
            self.genre = .biografija
        case "Detektiv-Romane /Kriminalromane":
            self.genre = .detektivski
        case "Das epische Fantasy Romangenre":
            self.genre = .epski
        case "Erotikromane/Liebesromane":
            self.genre = .erotski
        case "Klassikliteratur":
            self.genre = .klasika
        case "Popularpsychologie":
            self.genre = .psihologija
        case "Thriller":
            self.genre = .triler
        case "Historische Romane":
            self.genre = .istorijski
        case "Sonstiges":
            self.genre = .ostalo
        case "Horror":
            self.genre = .horor
        case "Aktion":
            self.genre = .akcija
        case "Roman":
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
        }
    }
    
    
}




