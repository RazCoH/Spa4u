//
//  ForgetPasswordViewController.swift
//  MassagesApp
//
//  Created by raz cohen on 14/07/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase

class ForgetPasswordViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendOutlet.isEnabled = false
        
        emailTextField.becomeFirstResponder()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        emailTextField = textFieldsUI(text: "כתובת דוא״ל", title: "כתובת דוא״ל תקינה", imageSystemName: "envelope", position: CGRect(x: 32, y: 80, width: 280, height: 45),passwordType: false , view: self.view)
        
        emailTextField.autocorrectionType = .no
        
        emailTextField.addTarget(self, action: #selector(emailDidChange(_:)), for: .editingChanged)
        
        makeCircle(button: sendOutlet, number: 2)
        
    }
    
    //MARK: variables
    
    var emailTextField = SkyFloatingLabelTextFieldWithIcon()
    
    //MARK: outlets
    
    @IBOutlet weak var sendOutlet: UIButton!
    
    //MARK: actions
    
    
    @IBAction func sendBtn(_ sender: UIButton) {
        
        let auth = Auth.auth()
        
        auth.sendPasswordReset(withEmail: emailTextField.text!) {[weak self] (error) in
            if error != nil {
                
                self?.showError(title: "שגיאה!",subtitle: "נסיון שליחת סיסמא חדשה לכתובת הדוא״ל שהזנת כשלה.")
                return
                
            }else{
                
                self?.showSucsses(title: "נשלח!")
              
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    func validEmail(_ email:String)->Bool{
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}")
        return emailTest.evaluate(with: email)
    }
    
    @objc func emailDidChange(_ textfield: UITextField) {
        if let firstEmail = textfield as? SkyFloatingLabelTextField{
            if !validEmail(textfield.text ?? ""){
                firstEmail.errorMessage = "לא לשכוח @ ו .com"
                sendOutlet.isEnabled = false
                
            }else{
                
                firstEmail.errorMessage = ""
                sendOutlet.isEnabled = true
            }
        }
    }
}

extension ForgetPasswordViewController:ShowHUDMessage,RoundButton{}
extension ForgetPasswordViewController:TextFieldUI{}
