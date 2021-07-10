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
    
    private var errorMessage : String?
    /// Description
    /// - Parameter controller: controller used to present mail controller
    func sendEmail(presentedFrom controller: UIViewController) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["sukycar@gmail.com"])
            mail.setSubject("Blitz Buch support")
            controller.present(mail, animated: true)
        } else {
            if let errorMessage = self.errorMessage {
            self.getAlert(errorString: errorMessage, errorColor: Colors.orange)
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        guard let error = error else {
            controller.dismiss(animated: true)
            return
        }
        self.errorMessage = error.localizedDescription
    }
}
