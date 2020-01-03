//
//  ViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 11/17/19.
//  Copyright © 2019 sukydeveloper. All rights reserved.
//

import UIKit
import MessageUI

struct Book: Codable {
    let imageName: String
    let title: String
    let authors: [String]
    let genre: String
}

class ViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    private var dataSource:[Book] = []
    
    var tableContent = ["Login", "Sign up", "Contact us", "DONATE"]
    var tableContent1 = ["Login", "Sign up", "Contact us", "DONATE"]
    

    var alphaTest = 0

    

    

    @IBOutlet weak var tableView2: UITableView! {
        didSet {
            tableView2.delegate = self
            tableView2.dataSource = self
            let customCellName = String(describing: CustomCell.self)
            tableView2.register(UINib(nibName: customCellName, bundle: nil), forCellReuseIdentifier: customCellName)
        }
    }
    @IBOutlet weak var tableView1: UITableView!
    
    @IBOutlet weak var button1: UIButton!

    
    override func viewDidLoad() {
      
        generateModel()
        
        print("hi")
        alphaTest = 0
        if alphaTest == 0 {
        tableView1.alpha = 0
            self.tableView1.frame = CGRect(x: self.button1.center.x, y:  self.button1.center.y, width: 0, height: 0)
        }
         
        tableView2.delegate = self
        tableView2.dataSource = self
        tableView2.layer.borderColor = UIColor.gray.cgColor
        tableView2.layer.borderWidth = 0.3
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView1.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        tableView1.layer.borderWidth = 0.22
    tableView1.translatesAutoresizingMaskIntoConstraints = false
        
        tableView2.translatesAutoresizingMaskIntoConstraints = false
    }
    
   
    func generateModel() {
        dataSource = [
            Book(imageName: "image1", title: "People Who Eat Darkness: Love, Grief and a Journey into Japan's Shadows", authors: ["Richard Lloyd Parry"], genre: "Crime"),
            Book(imageName: "image2", title: "In Cold Blood", authors: ["Truman Capote"], genre: "Comedy"),
            Book(imageName: "image3", title: "And the Sea Will Tell", authors: ["Vinsent Bugliosi", "Bruce Henderson"], genre: "Bibliography & Momories"),
            Book(imageName: "image4", title: "Midnight in the Garden of Good and Evil: A Savannah Story", authors: ["John Berendt"], genre: "Horror"),
            Book(imageName: "image5", title: "Tinseltown: Murder, Morphine, and Madness at the Dawn of Hollywood", authors: ["William J. Mann"], genre: "Music"),
        ]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numOfRows = Int()
        if tableView == tableView1 {
            numOfRows = tableContent.count
            print("Tabela 1")
        }
        else if tableView == tableView2 {
            numOfRows = dataSource.count
            print("Tabela 2")
        }
        return numOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == tableView1 {
        cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let cellDonate = UIImage(named: "donate")
        let cellLogIn = UIImage(named: "login")
        let cellRegistration = UIImage(named: "registration")
        let cellLocation = tableContent[indexPath.row]
            cell.textLabel?.text = cellLocation
            let cellContact = UIImage(named: "contact")
            
        let aColor = UIColor(hexString: "#5cbff2")
            cell.textLabel?.textColor = aColor
            let cellContactColored = cellContact?.withTintColor(aColor)
            
            
            switch indexPath.row {
            case 0:
                cell.imageView?.image = cellLogIn
            case 1:
                cell.imageView?.image = cellRegistration
            case 2:
                cell.imageView?.image = cellContactColored
            case 3:
                cell.imageView?.image = cellDonate
                cell.textLabel?.textColor = .orange
            default:
                print("No cell index")
            }
            cell.translatesAutoresizingMaskIntoConstraints = false
            cell.selectionStyle = .default
            cell.layer.masksToBounds = true
            cell.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.8)
            cell.layer.borderWidth = 0.22
            cell.textLabel?.font = UIFont(name: "Roboto-Regular", size: 16)
            
            cell.isUserInteractionEnabled = true
        } else if tableView == tableView2 {
           
            let model = dataSource[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomCell.self), for: indexPath) as! CustomCell
            cell.configure(with: model)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()
        if tableView.tag == 1{
        height = tableView1.frame.size.height / 4
        } else if tableView.tag == 2{
            height = 182 /*self.view.frame.size.height / 3*/
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            performSegue(withIdentifier: "login", sender: self)
        }
        if indexPath.row == 1 {
            performSegue(withIdentifier: "registration", sender: self)
           
            
        }
        if indexPath.row == 2 {
           
            
            self.sendEmail()
            
        }
        if indexPath.row == 3 {
            performSegue(withIdentifier: "donate", sender: self)
        }
        
    }
    
   
    @IBAction func buttonAction(_ sender: Any) {
        
        if alphaTest == 0 {
            tableView1.alpha = 1
            UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                
                
                self.tableView1.transform = CGAffineTransform(translationX: self.view.frame.size.width, y: 120)
                self.tableView1.frame = CGRect(x: 0, y: self.button1.center.y + self.button1.frame.size.height, width: self.view.frame.size.width, height: 120)
                
                
                }, completion: nil)
                
            self.alphaTest = 1
        } else {
            
         UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
        
        self.tableView1.transform = CGAffineTransform(translationX: -self.view.frame.size.width, y: -120)
            self.tableView1.frame = CGRect(x: self.button1.center.x, y:  self.button1.center.y, width: 0, height: 0)
        
            self.alphaTest = 0
        }, completion: nil)
        
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["sukycar@gmail.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

            mail.setSubject("Blic Buch support")
            
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }// func for sending mail
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }// extension for using HEX code for colors
    
    
}
