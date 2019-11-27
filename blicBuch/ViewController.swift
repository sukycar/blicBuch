//
//  ViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 11/17/19.
//  Copyright © 2019 sukydeveloper. All rights reserved.
//

import UIKit

class ViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var tableContent = ["Login", "Sign up", "DONATE"]
var alphaTest = 0

    

    
    @IBOutlet weak var table1: UITableView!
    @IBOutlet weak var upView: UIView!
    
    @IBOutlet weak var button1: UIButton!

    
    override func viewWillAppear(_ animated: Bool)  {
        print("hi")
        alphaTest = 0
        if alphaTest == 0 {
        table1.alpha = 0
            self.table1.frame = CGRect(x: self.button1.center.x, y:  self.button1.center.y, width: 0, height: 0)
        }
         
       
        table1.delegate = self
        table1.dataSource = self
        table1.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        table1.layer.borderWidth = 0.22
    table1.translatesAutoresizingMaskIntoConstraints = true
        
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        table1 = tableView
        return tableContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        if tableView.tag == 1 {
        cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let cellDonate = UIImage(named: "donate")
        let cellLogIn = UIImage(named: "login")
        let cellRegistration = UIImage(named: "registration")
        let cellLocation = tableContent[indexPath.row]
        cell!.textLabel?.text = cellLocation
        let aColor = UIColor(hexString: "#5cbff2")
        cell!.textLabel?.textColor = aColor
            
            switch indexPath.row {
            case 0:
                cell!.imageView?.image = cellLogIn
            case 1:
                 cell!.imageView?.image = cellRegistration
            case 2:
                cell!.imageView?.image = cellDonate
            cell?.textLabel?.textColor = .orange
            default:
                print("No cell index")
            }
            cell?.translatesAutoresizingMaskIntoConstraints = false
        cell!.selectionStyle = .default
        cell!.layer.masksToBounds = false
            cell!.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.8)
            cell!.layer.borderWidth = 0.22
        cell!.textLabel?.font = UIFont(name: "Roboto-Regular", size: 16)
        
        } else {
        print("Druga")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = table1.frame.size.height / 3
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
            performSegue(withIdentifier: "donate", sender: self)
        }
    }
    @IBAction func buttonAction(_ sender: Any) {
        
        if alphaTest == 0 {
            table1.alpha = 1
            UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                
                
                self.table1.transform = CGAffineTransform(translationX: self.table1.frame.size.width, y: 120)
                self.table1.frame = CGRect(x: 0, y:  self.upView.frame.size.height + 10, width: self.view.frame.size.width, height: 120)
                
                
                }, completion: nil)
                
            self.alphaTest = 1
        } else {
            
         UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
        
        self.table1.transform = CGAffineTransform(translationX: -self.view.frame.size.width, y: -120)
            self.table1.frame = CGRect(x: self.button1.center.x, y:  self.button1.center.y, width: 0, height: 0)
        
            self.alphaTest = 0
        }, completion: nil)
        
        }
    }
    
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
