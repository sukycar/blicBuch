//
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordRepeat: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBAction func registerButton(_ sender: Any) {
    }
    var textFieldTester = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil);
        
    }//observe keyboard actions
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if let activeTextField = UIResponder.currentFirst() as? UITextField {
            if activeTextField.tag > 4 {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardFrame.height
            }
            }
        }
        
    }//set fields above keyboard if they overlap

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
    }//return view to original state after keyboard is hidden
    
    @IBAction func textField(_ sender: AnyObject) {
        self.view.endEditing(true);
    }// for dismiss of keyboard
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
public extension UIResponder {

    private struct Static {
        static weak var responder: UIResponder?
    }

    static func currentFirst() -> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }

    @objc private func _trap() {
        Static.responder = self
    }
}//code for checking first responder
