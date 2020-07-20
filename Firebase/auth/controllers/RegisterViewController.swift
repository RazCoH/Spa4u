//
//  RegisterViewController.swift
//  MassagesApp
//
//  Created by raz cohen on 19/06/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField

class RegisterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeCircle(button: registerOutlet, number: 2)
        setTextFields()
    }
    
    //MARK: outlets
    
  
    @IBOutlet weak var registerOutlet: UIButton!
    
    //MARK: variables
    
    var ref: DatabaseReference!
    var emailTextField = SkyFloatingLabelTextFieldWithIcon()
    var repeatEmailTextField = SkyFloatingLabelTextFieldWithIcon()
    var passwordTextField = SkyFloatingLabelTextFieldWithIcon()
    var repeatPasswordTextField = SkyFloatingLabelTextFieldWithIcon()
    var phoneNumberTextField = SkyFloatingLabelTextFieldWithIcon()
    var nameTextField = SkyFloatingLabelTextFieldWithIcon()
    
    //MARK: actions
    
    
    @IBAction func confirmBtn(_ sender: UIButton) {
        
        let error = validateFields()
        
        if error != nil {
            
            if !CheckInternet().isOnline(){
                
                print("אין חיבור לאינטרנט")
                showOfflineAlert(view: self)
                
            }else{
    
                showError(title: "לא יכול ליצור משתמש",subtitle: error)
                
            }
        }else{
            
            createUser()
        }
    }
    
    //MARK: functions
    
    func createUser(){
        
         showProgress()
        
        guard let email = emailTextField.text else{return}
        guard let password = passwordTextField.text else{return}
        guard let phoneNumber = phoneNumberTextField.text else{return}
        guard let userName = nameTextField.text else{return}
        
        
        Auth.auth().createUser(withEmail: email, password: password) {[weak self]
            (authResult, error) in
            
            if error == nil{
                
                self?.ref = Database.database().reference()
                let uid:String = Auth.auth().currentUser!.uid
                self?.ref.child("users")
                    .child(uid)
                    .setValue([
                        "email" : email,
                        "phone" : phoneNumber,
                        "name" : userName
                    ])
                
                Router.shared.chooseMainViewController()
            }
        }
    }
    
    
    
    func validName(_ name:String)->Bool{
        
        if !name.contains(" "){
            
            return false
            
        }else{
            
            var fullName = name.components(separatedBy: " ")
            let firstName = fullName[0]
            let lastName = fullName[1]
            
            if fullName.last == " "{
                
                fullName.removeLast()
                
            }
            
            if fullName.count > 2 {
                
                return false
                
            }else if firstName.count < 2 || lastName.count < 2 {
                
                return false
                
            }else{
                
                return true
                
            }
        }
    }
    
    
    func validPhoneNumber(value: String) -> Bool {
        
        if value.count != 11 {
            
            return false
            
        }else{
            
            let fullNumber = value.components(separatedBy: "-")
            let companyNum = fullNumber[0]
            
            switch companyNum {
                
            case "050","051","052","053","054","055","058":
                
                return true
                
            default:
                
                return false
            }
        }
    }
    
    func validEmail(_ email:String)->Bool{
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}")
        return emailTest.evaluate(with: email)
    }
    
    func emailsEquality(address1:String , address2:String)->Bool{
        
        if address1 == address2 {
            return true
        }
        return false
    }
    
    func passwordsEquality(password1:String , password2:String)->Bool{
           
           if password1 == password2 {
               return true
           }
           return false
       }
    
    func validPassword(_ password: String)->Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$")
        return passwordTest.evaluate(with: password)
    }
    
    func fieldsAreEquals(field1:String , field2:String) -> Bool{
        
        if field1 == field2{
            return true
        }else{
            return false
        }
    }
    
    func setTextFields(){
        
        emailTextField = textFieldsUI(text: "כתובת דואר אלקטרוני", title: "כתובת דוא״ל תקינה", imageSystemName: "envelope.fill", position: CGRect(x: 80, y: 0, width: 240, height: 45), passwordType: false, view: self.view)
        
         emailTextField.autocorrectionType = .no
         emailTextField.addTarget(self, action: #selector(emailDidChange(_:)), for: .editingChanged)
        
        repeatEmailTextField = textFieldsUI(text: "אנא הזנ/י כתובת דוא״ל שנית", title: "כתובות דוא״ל תואמות", imageSystemName: "envelope", position: CGRect(x: 80, y: 60 ,width: 240, height: 45), passwordType: false, view: self.view)
        
         repeatEmailTextField.autocorrectionType = .no
        repeatEmailTextField.addTarget(self, action: #selector(secondEmailDidChange(_:)), for: .editingChanged)
        
        passwordTextField = textFieldsUI(text: "בחר/י סיסמא", title: "סיסמא תקינה", imageSystemName: "lock.fill", position: CGRect(x: 80, y: 120, width: 240, height: 45), passwordType: true, view: self.view)
        
         passwordTextField.autocorrectionType = .no
         passwordTextField.addTarget(self, action: #selector(passwordDidChange(_:)), for: .editingChanged)
        
        repeatPasswordTextField = textFieldsUI(text: "אנא הזנ/י סיסמא שנית", title: "סיסמאות תואמות", imageSystemName: "lock", position: CGRect(x: 80, y: 180, width: 240, height: 45), passwordType: true, view: self.view)
        
         repeatPasswordTextField.autocorrectionType = .no
         repeatPasswordTextField.addTarget(self, action: #selector(secondPasswordDidChange(_:)), for: .editingChanged)
        
        phoneNumberTextField = textFieldsUI(text: "מספר טלפון סלולארי", title: "מספר תקין", imageSystemName: "phone.fill", position: CGRect(x: 80, y: 240, width: 240, height: 45), passwordType: false, view: self.view)
        
        phoneNumberTextField.autocorrectionType = .no
        phoneNumberTextField.addTarget(self, action: #selector(phoneNumberDidChange(_:)), for: .editingChanged)
        
        nameTextField = textFieldsUI(text: "שם מלא", title: "שם יפה ☺️", imageSystemName: "person", position: CGRect(x: 80, y: 300, width: 240, height: 45), passwordType: false, view: self.view)
        
        nameTextField.autocorrectionType = .no
        nameTextField.addTarget(self, action: #selector(userNameDidChange(_:)), for: .editingChanged)
        
    }
    
    @objc func emailDidChange(_ textfield: UITextField) {
        
        if let firstEmail = textfield as? SkyFloatingLabelTextField{
            if !validEmail(textfield.text ?? ""){
                firstEmail.errorMessage = "כתובת דוא״ל חייבת להכיל ׳@׳ ו- ׳ com.׳"
            }else{
                firstEmail.errorMessage = ""
            }
        }
    }
    
    @objc func passwordDidChange(_ textfield: UITextField) {
        
        if let password = textfield as? SkyFloatingLabelTextField{
            if !validPassword(textfield.text ?? ""){
                password.errorMessage = "לפחות 8 תווים, אותיות באנגלית ומספרים"
            }else{
                password.errorMessage = ""
            }
        }
    }
    
    @objc func phoneNumberDidChange(_ textfield: UITextField) {
        
        if phoneNumberTextField.text!.count == 3 && !phoneNumberTextField.text!.contains("-") {
            
            phoneNumberTextField.text?.append("-")
        }
        
        if let number = textfield as? SkyFloatingLabelTextField{
            if !validPhoneNumber(value: textfield.text ?? ""){
                number.errorMessage = "מספר סלולארי לא תקין"
            }else{
                number.errorMessage = ""
            }
        }
    }
    
    @objc func userNameDidChange(_ textfield: UITextField) {
        
        if let name = textfield as? SkyFloatingLabelTextField{
            if !validName(textfield.text ?? ""){
                name.errorMessage = "אנא הזנ/י שם פרטי ומשפחה"
            }else{
                name.errorMessage = ""
            }
        }
    }
    
    @objc func secondEmailDidChange(_ textfield1: UITextField ) {
        
        guard let secondEmail = textfield1 as? SkyFloatingLabelTextField else{return}
        guard let firstEmail = emailTextField.text else{return}
    
        if !emailsEquality(address1: secondEmail.text!, address2: firstEmail){
                secondEmail.errorMessage = "כתובת הדוא״ל אינן תואמות"
            }else{
                secondEmail.errorMessage = ""
            }
    }
    
    @objc func secondPasswordDidChange(_ textfield: UITextField ) {
        
        guard let secondPassword = textfield as? SkyFloatingLabelTextField else{return}
        guard let firstPassword = passwordTextField.text else{return}
    
        if !passwordsEquality(password1: firstPassword, password2: secondPassword.text!){
                secondPassword.errorMessage = "סיסמאות אינן תואמות"
            }else{
                secondPassword.errorMessage = ""
            }
    }
    
    func validateFields()->String?{
        
        //check that all the field are fill in:
        
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            
            repeatEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            
            repeatPasswordTextField.text?.trimmingCharacters(
                in: .whitespacesAndNewlines) == "" ||
            
            phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            
            nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            
        {
            
            return "אנא מלאו את כל השדות"
            
        }else if !validEmail(emailTextField.text!)  {
            
            return "כתובת דוא״ל לא תקינה"
            
        }else if !validPassword(passwordTextField.text!){
            
            return "אנא הזנ/י סיסמא המורכבת משמונה תווים לפחות הכוללת אותיות באנגלית ומספרים"
            
        }else if !fieldsAreEquals(field1: emailTextField.text!, field2: repeatEmailTextField.text!){
            
            return "כתובות הדוא״ל שהזנת לא תואמות"
            
        }else if !fieldsAreEquals(field1: passwordTextField.text!, field2: repeatPasswordTextField.text!){
            
            return "הסיסמאות שהזנת לא תואמות"
            
        }else if !validName(nameTextField.text!){
            
            return "שם משתמש לא תקין"
            
        }else if !validPhoneNumber(value: phoneNumberTextField.text!){
            
            return "מספר סלולארי לא תקין"
            
        }else{
            return nil
        }
    }
}

extension RegisterViewController:RoundButton,TextFieldUI,ShowHUDMessage,OfflinAlert{}
