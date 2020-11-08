//
//  ContactViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 12/3/19.
//  Copyright © 2019 sukydeveloper. All rights reserved.

//"https://icons8.com" send icon IMPORTANT
//

import UIKit
import MessageUI

class ContactViewController: UIViewController {
    
    
    @IBAction func sendMailButton(_ sender: Any) {
        sendEmail()
    }
    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true) {
            //getting back to main view
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        toTextField.frame.size.width = self.view.frame.size.width - 16
       
        toTextField.beginFloatingCursor(at: CGPoint(x: 50, y: 0))
       
       
        toTextField.insertText("To:")
        
        fromTextField.insertText("From:")
        
        subjectTextField.insertText("Subject:")
        fromTextField.frame.size.width = self.view.frame.size.width - 16
        
        subjectTextField.frame.size.width = self.view.frame.size.width - 16
       
        
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: toTextField.frame.height - 1, width: toTextField.frame.size.width, height: 0.5)
        bottomLine.backgroundColor = UIColor.gray.cgColor
        toTextField.placeholder?.append("Vlada")
        toTextField.layer.masksToBounds = true
        toTextField.borderStyle = .none
        toTextField.layer.addSublayer(bottomLine)
        //adding bottom line to textField
        
        
        
        let bottomLine1 = CALayer()
        bottomLine1.frame = CGRect(x: 0, y: fromTextField.frame.height - 1, width: fromTextField.frame.size.width, height: 0.5)
        bottomLine1.backgroundColor = UIColor.gray.cgColor
        fromTextField.borderStyle = .none
        fromTextField.layer.masksToBounds = true
        fromTextField.layer.addSublayer(bottomLine1)
        //adding bottom line to textField
        
        subjectTextField.layer.masksToBounds = true
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0, y: subjectTextField.frame.height - 1, width: subjectTextField.frame.size.width, height: 0.5)
        bottomLine2.backgroundColor = UIColor.gray.cgColor
        subjectTextField.borderStyle = .none
        subjectTextField.layer.addSublayer(bottomLine2)
        //adding bottom line to textField
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
            mail.setToRecipients(["sukycar@gmail.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}


