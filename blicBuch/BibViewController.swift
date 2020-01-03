//
//  BibViewController.swift
//  
//
//  Created by Vladimir Sukanica on 12/21/19.
//

import UIKit


struct Genre: Codable {
    let imageName: String
    let title: String
}


class BibViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var borderView: UIView!//view for adding border below label
    private var dataSource:[Genre] = []
    
    @IBOutlet weak var genreTable: UITableView! {
        didSet {
            genreTable.delegate = self
            genreTable.dataSource = self
            let customCellName = String(describing: CategoryTableViewCell.self)
            
            genreTable.register(UINib(nibName: customCellName, bundle: nil), forCellReuseIdentifier: customCellName)
        }
    }
    
    var indexNumber = Int()
    
    override func viewWillAppear(_ animated: Bool) {
     
        super.viewWillAppear(animated)
        
        if let path = genreTable.indexPathForSelectedRow {

            genreTable.deselectRow(at: path, animated: true)
        }//cancels the selections when view appears
        
        
        generateModel()//creates the genre list
        
        
        genreTable.delegate = self
        genreTable.dataSource = self
        
        borderView.addBottomBorder(color: .gray, margins: 0, borderLineSize: 0.5)//adds borders
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        let model = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:CategoryTableViewCell.self), for:indexPath) as! CategoryTableViewCell
        cell.configure(with: model)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
            switch indexPath.row {
            case 0:
                indexNumber = 1
            case 1:
                indexNumber = 2
            case 2:
                indexNumber = 3
            case 3:
                indexNumber = 4
            case 4:
                indexNumber = 5
            case 5:
                indexNumber = 6
            case 6:
                indexNumber = 7
            case 7:
                indexNumber = 8
            case 8:
                indexNumber = 9
            case 9:
                indexNumber = 10
            default:
                print("Select row")
            }
       
            
        let transition = CATransition()
        transition.duration = 0.7
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        performSegue(withIdentifier: "bibliotech", sender: self)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    var imageArray = [UIImage(named: "image1"), UIImage(named: "image2"), UIImage(named: "image3"), UIImage(named: "image4"), UIImage(named: "image5")]
    
   
    
    
    
    func generateModel() {
        dataSource = [
            Genre(imageName: "arrowR", title: "Avantura"),
            Genre(imageName: "arrowR", title: "Biografija"),
            Genre(imageName: "arrowR", title: "Detektivski krimi roman"),
            Genre(imageName: "arrowR", title: "Epska fantastika"),
            Genre(imageName: "arrowR", title: "Erotski/ljubavni romani"), Genre(imageName: "arrowR", title: "Istorijski romani"),
            Genre(imageName: "arrowR", title: "Klasici"),
            Genre(imageName: "arrowR", title: "Popularna psihologija"),
            Genre(imageName: "arrowR", title: "Trileri"),
            Genre(imageName: "arrowR", title: "Ostalo")
        ]
    }
    
   

   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bibliotech"{
            let newController = segue.destination as! UINavigationController
            let tableViewCTRL = newController.topViewController as! GenreTableViewController
            
tableViewCTRL.modelSwitch = indexNumber
      
        
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}




