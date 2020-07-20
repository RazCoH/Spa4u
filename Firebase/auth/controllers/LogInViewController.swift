//
//  LogInViewController.swift
//  MassagesApp
//
//  Created by raz cohen on 19/06/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import Firebase
import SystemConfiguration
import SkyFloatingLabelTextField

class LogInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFields()
        makeCircle(button: logInOutlet, number: 2)
 
    }
    
    //MARK: outlets
    
    @IBOutlet weak var logInOutlet: UIButton!
    
    //MARK: variables
    
    var emailTextField = SkyFloatingLabelTextFieldWithIcon()
    var passwordTextField = SkyFloatingLabelTextFieldWithIcon()
    
    //MARK: actions
    
    @IBAction func logInBtn(_ sender: UIButton) {

        if CheckInternet().isOnline(){

            tryLogIn()

        }else{

            showOfflineAlert(view: self)
            
        }
    }
    
    //MARK: functions
    
    func tryLogIn(){
        
        // (1) check fields validility:
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // (2) check email and password are correct
        
        Auth.auth().signIn(withEmail: email, password: password) {[weak self](authResult, error) in
            
            if error != nil {
                
                self?.showError(title: "שגיאה" ,subtitle: "שם משתמש או סיסמא לא נכונים")
                
            }else{
                
                Router.shared.chooseMainViewController()
            }
        }
    }
    
    
    func setTextFields(){
        
        emailTextField.becomeFirstResponder()
        
        let device =  UIDevice().name
        var xSize = Int()
        
         switch device {
             
         case "iPhone 11 Pro Max","iPhone 11 Pro","iPhone 11","iPhone 8 Plus":
            xSize = 88
            
         default:
            xSize = 64
         }
        
        emailTextField = textFieldsUI(text: "כתובת דוא״ל", title: " אנא הזן את כתובת הדוא״ל שלך", imageSystemName: "envelope", position: CGRect(x: xSize, y: 4, width: 216, height: 45), passwordType: false, view: self.view)
          emailTextField.autocorrectionType = .no
        
        passwordTextField = textFieldsUI(text: "סיסמא", title: "אנא הזן סיסמא", imageSystemName: "lock", position: CGRect(x: xSize, y: 60, width: 216, height: 45), passwordType: true, view: self.view)
        
          emailTextField.autocorrectionType = .no
        
    }
}

    extension LogInViewController:RoundButton,ShowHUDMessage,OfflinAlert,TextFieldUI{}

