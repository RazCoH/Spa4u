//
//  OrderViewController.swift
//  MassagesApp
//
//  Created by raz cohen on 16/06/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import Firebase
import PKHUD


class OrderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        dateLabel.text = date
        timeLabel.text = time
        nameLabel.text = name
        priceLabel.text = priceFormat(price: massagePrice)
        makeCircle(button: orderBtnOutlet, number: 2)
        makeCircle(button: cancelBtnOutlet, number: 2)
    }

    //MARK: outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderBtnOutlet: UIButton!
    @IBOutlet weak var cancelBtnOutlet: UIButton!
    
    //MARK: variables
    
    var name = String()
    var date = String()
    var time = String()
    var ref: DatabaseReference!
    var queues:[MassageQueue] = []
    
    //MARK: actions
    
    @IBAction func makeAnOrder(_ sender: UIButton) {
        
        //(1) save the details to database
        
        guard
            
            let name = nameLabel.text ,
            let startTime = timeLabel.text ,
            let date = dateLabel.text,
            let uid = Auth.auth().currentUser?.uid
        
            else{ return }
            
        let mq = MassageQueue(
            
            name: name,
            date: date,
            startTime: startTime,
            price: massagePrice,
            userID: uid
            
        )
        
         mq.saveToDB()
        
        //send an email to the customer:
        
        guard let userEmail = Auth.auth().currentUser?.email else{
            
            showError(title: "הזמנה נכשלה")
            return
            
        }
        
        FirebaseDataSource.shared.getUserName {(name) in
            
            let emailBody = "<p style='text-align:right'><h1> שלום \(name),</h1><br/> תודה שבחרת בספא פור יו <br/> מחכים לראותך בשעה \(mq.startTime) <br/> בתאריך \(mq.date) </p>"
            
            SendEmail().sendEmail(htmlBody: emailBody, subject: "תור למסאז׳ מפנק", from: "Spa4U", to: name, custumerEmail: userEmail, mailToCustomer: true)
        }
        
        //send customer to the owner:
        
        FirebaseDataSource.shared.getUserName {(name) in
            
            let emailBody = "<p style='text-align:right'>\(mq.startTime) בשעה \(mq.date) בתאריך \(mq.nameOfMassage) הזמין \(name)<br/>\(mq.startTime) <br/> בתאריך \(mq.date) </p>"
            
            SendEmail().sendEmail(htmlBody: emailBody, subject: "תור חדש", from: "My App", to: name, custumerEmail: userEmail, mailToCustomer: false)
            
            self.showSucsses(title: "הזמנה הושלמה")
        
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func cancle(_ sender: UIButton) {
    
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    //MARK: functions

}

extension OrderViewController:ShowHUDMessage{}
extension OrderViewController:RoundButton{}
extension OrderViewController:CurrencyFormat{}
