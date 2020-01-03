//
//  GenreTableViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 12/24/19.
//  Copyright © 2019 sukydeveloper. All rights reserved.
//

import UIKit

class GenreTableViewController: UITableViewController {
    
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
    var modelSwitch = Int() // switch for chosen genre
private var dataSource:[Book] = []
    
    @IBOutlet var mainTable: UITableView!{
        didSet {
            mainTable.delegate = self
            mainTable.dataSource = self
            let customCellName = String(describing: CustomCell.self)
            mainTable.register(UINib(nibName: customCellName, bundle: nil), forCellReuseIdentifier: customCellName)
        }
    }
    
    
    
    func generateModel1() {
        dataSource = [
            Book(imageName: "image1", title: "AVANTURA", authors: ["Richard Lloyd Parry"], genre: "Crime"),
            Book(imageName: "image2", title: "In Cold Blood", authors: ["Truman Capote"], genre: "Comedy"),
            Book(imageName: "image3", title: "And the Sea Will Tell", authors: ["Vinsent Bugliosi", "Bruce Henderson"], genre: "Bibliography & Momories"),
            Book(imageName: "image4", title: "Midnight in the Garden of Good and Evil: A Savannah Story", authors: ["John Berendt"], genre: "Horror"),
            Book(imageName: "image5", title: "Tinseltown: Murder, Morphine, and Madness at the Dawn of Hollywood", authors: ["William J. Mann"], genre: "Music"),
        ]
    }
    
    func generateModel2() {
        dataSource = [
            Book(imageName: "image1", title: "BIOGRAFIJA", authors: ["Richard Lloyd Parry"], genre: "Crime"),
            Book(imageName: "image2", title: "In Cold Blood", authors: ["Truman Capote"], genre: "Comedy"),
            Book(imageName: "image3", title: "And the Sea Will Tell", authors: ["Vinsent Bugliosi", "Bruce Henderson"], genre: "Bibliography & Momories"),
            Book(imageName: "image4", title: "Midnight in the Garden of Good and Evil: A Savannah Story", authors: ["John Berendt"], genre: "Horror"),
            Book(imageName: "image5", title: "Tinseltown: Murder, Morphine, and Madness at the Dawn of Hollywood", authors: ["William J. Mann"], genre: "Music"),
        ]
    }
    
    func generateModel3() {
        dataSource = [
            Book(imageName: "image1", title: "DETEKTIVI", authors: ["Richard Lloyd Parry"], genre: "Crime"),
            Book(imageName: "image2", title: "In Cold Blood", authors: ["Truman Capote"], genre: "Comedy"),
            Book(imageName: "image3", title: "And the Sea Will Tell", authors: ["Vinsent Bugliosi", "Bruce Henderson"], genre: "Bibliography & Momories"),
            Book(imageName: "image4", title: "Midnight in the Garden of Good and Evil: A Savannah Story", authors: ["John Berendt"], genre: "Horror"),
            Book(imageName: "image5", title: "Tinseltown: Murder, Morphine, and Madness at the Dawn of Hollywood", authors: ["William J. Mann"], genre: "Music"),
        ]
    }
    
    func generateModel4() {
        dataSource = [
            Book(imageName: "image1", title: "EPIKA", authors: ["Richard Lloyd Parry"], genre: "Crime"),
            Book(imageName: "image2", title: "In Cold Blood", authors: ["Truman Capote"], genre: "Comedy"),
            Book(imageName: "image3", title: "And the Sea Will Tell", authors: ["Vinsent Bugliosi", "Bruce Henderson"], genre: "Bibliography & Momories"),
            Book(imageName: "image4", title: "Midnight in the Garden of Good and Evil: A Savannah Story", authors: ["John Berendt"], genre: "Horror"),
            Book(imageName: "image5", title: "Tinseltown: Murder, Morphine, and Madness at the Dawn of Hollywood", authors: ["William J. Mann"], genre: "Music"),
        ]
    }
    
    func generateModel5() {
        dataSource = [
            Book(imageName: "image1", title: "EROTIKA", authors: ["Richard Lloyd Parry"], genre: "Crime"),
            Book(imageName: "image2", title: "In Cold Blood", authors: ["Truman Capote"], genre: "Comedy"),
            Book(imageName: "image3", title: "And the Sea Will Tell", authors: ["Vinsent Bugliosi", "Bruce Henderson"], genre: "Bibliography & Momories"),
            Book(imageName: "image4", title: "Midnight in the Garden of Good and Evil: A Savannah Story", authors: ["John Berendt"], genre: "Horror"),
            Book(imageName: "image5", title: "Tinseltown: Murder, Morphine, and Madness at the Dawn of Hollywood", authors: ["William J. Mann"], genre: "Music"),
        ]
    }
    
    func generateModel6() {
        dataSource = [
            Book(imageName: "image1", title: "ISTORIJSKI ROMANI", authors: ["Richard Lloyd Parry"], genre: "Crime"),
            Book(imageName: "image2", title: "In Cold Blood", authors: ["Truman Capote"], genre: "Comedy"),
            Book(imageName: "image3", title: "And the Sea Will Tell", authors: ["Vinsent Bugliosi", "Bruce Henderson"], genre: "Bibliography & Momories"),
            Book(imageName: "image4", title: "Midnight in the Garden of Good and Evil: A Savannah Story", authors: ["John Berendt"], genre: "Horror"),
            Book(imageName: "image5", title: "Tinseltown: Murder, Morphine, and Madness at the Dawn of Hollywood", authors: ["William J. Mann"], genre: "Music"),
        ]
    }
    
    func generateModel7() {
        dataSource = [
            Book(imageName: "image1", title: "KLASICI", authors: ["Richard Lloyd Parry"], genre: "Crime"),
            Book(imageName: "image2", title: "In Cold Blood", authors: ["Truman Capote"], genre: "Comedy"),
            Book(imageName: "image3", title: "And the Sea Will Tell", authors: ["Vinsent Bugliosi", "Bruce Henderson"], genre: "Bibliography & Momories"),
            Book(imageName: "image4", title: "Midnight in the Garden of Good and Evil: A Savannah Story", authors: ["John Berendt"], genre: "Horror"),
            Book(imageName: "image5", title: "Tinseltown: Murder, Morphine, and Madness at the Dawn of Hollywood", authors: ["William J. Mann"], genre: "Music"),
        ]
    }
    
    func generateModel8() {
        dataSource = [
            Book(imageName: "image1", title: "POPULARNA PSIHOLOGIJA", authors: ["Richard Lloyd Parry"], genre: "Crime"),
            Book(imageName: "image2", title: "In Cold Blood", authors: ["Truman Capote"], genre: "Comedy"),
            Book(imageName: "image3", title: "And the Sea Will Tell", authors: ["Vinsent Bugliosi", "Bruce Henderson"], genre: "Bibliography & Momories"),
            Book(imageName: "image4", title: "Midnight in the Garden of Good and Evil: A Savannah Story", authors: ["John Berendt"], genre: "Horror"),
            Book(imageName: "image5", title: "Tinseltown: Murder, Morphine, and Madness at the Dawn of Hollywood", authors: ["William J. Mann"], genre: "Music"),
        ]
    }
    
    func generateModel9() {
        dataSource = [
            Book(imageName: "image1", title: "TRILERI", authors: ["Richard Lloyd Parry"], genre: "Crime"),
            Book(imageName: "image2", title: "In Cold Blood", authors: ["Truman Capote"], genre: "Comedy"),
            Book(imageName: "image3", title: "And the Sea Will Tell", authors: ["Vinsent Bugliosi", "Bruce Henderson"], genre: "Bibliography & Momories"),
            Book(imageName: "image4", title: "Midnight in the Garden of Good and Evil: A Savannah Story", authors: ["John Berendt"], genre: "Horror"),
            Book(imageName: "image5", title: "Tinseltown: Murder, Morphine, and Madness at the Dawn of Hollywood", authors: ["William J. Mann"], genre: "Music"),
        ]
    }
    
    func generateModel10() {
        dataSource = [
            Book(imageName: "image1", title: "OSTALO", authors: ["Richard Lloyd Parry"], genre: "Crime"),
            Book(imageName: "image2", title: "In Cold Blood", authors: ["Truman Capote"], genre: "Comedy"),
            Book(imageName: "image3", title: "And the Sea Will Tell", authors: ["Vinsent Bugliosi", "Bruce Henderson"], genre: "Bibliography & Momories"),
            Book(imageName: "image4", title: "Midnight in the Garden of Good and Evil: A Savannah Story", authors: ["John Berendt"], genre: "Horror"),
            Book(imageName: "image5", title: "Tinseltown: Murder, Morphine, and Madness at the Dawn of Hollywood", authors: ["William J. Mann"], genre: "Music"),
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("model je \(modelSwitch)")
        
        pictureView.contentMode = .scaleAspectFit
        
        switch modelSwitch {
        case 1:
        generateModel1()
        genreLabel.setTitle("avantura", for: .normal)
            case 2:
            generateModel2()
            genreLabel.setTitle("biografija", for: .normal)
            case 3:
            generateModel3()
            genreLabel.setTitle("detektivski krimi roman", for: .normal)
            case 4:
            generateModel4()
            genreLabel.setTitle("epska fantastika", for: .normal)
            case 5:
            generateModel5()
            genreLabel.setTitle("erotski/ljubavni romani", for: .normal)
            case 6:
            generateModel6()
            genreLabel.setTitle("istorijski romani", for: .normal)
            case 7:
            generateModel7()
            genreLabel.setTitle("klasici", for: .normal)
            case 8:
            generateModel8()
            genreLabel.setTitle("popularna psihologija", for: .normal)
            case 9:
            generateModel9()
            genreLabel.setTitle("trileri", for: .normal)
            case 10:
            generateModel10()
            genreLabel.setTitle("ostalo", for: .normal)
        default:
            print("No model chosen")
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count// for other categories should be added
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

       let model = dataSource[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomCell.self), for: indexPath) as! CustomCell
            cell.configure(with: model)
            
        

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
