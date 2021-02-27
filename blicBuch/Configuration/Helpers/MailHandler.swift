//
//  MailHandler.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 23.2.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import MessageUI

class MailHandler: UIViewController, MFMailComposeViewControllerDelegate {
    
    /// Description
    /// - Parameter controller: controller used to present mail controller
    func sendEmail(presentedFrom controller: UIViewController) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["sukycar@gmail.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            mail.setSubject("Blic Buch support")
            controller.present(mail, animated: true)
        } else {
            self.getAlert(errorString: "Mail not send. Check your connection\nand try again.", errorColor: Colors.orange)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        guard let error = error else {
            controller.dismiss(animated: true)
            return
        }
        print(error.localizedDescription)
    }
}
