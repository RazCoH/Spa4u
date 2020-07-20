//
//  MyQueuesTableViewController.swift
//  MassagesApp
//
//  Created by raz cohen on 27/06/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import Firebase

class MyQueuesTableViewController: UITableViewController {

    var userOrders = [MassageQueue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem?.title = "ביטול תור"
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.9411764706, green: 0.4431372549, blue: 0.4039215686, alpha: 1)
        
        FirebaseDataSource.shared.getUserOrders {[weak self](orders) in
            
            self?.userOrders = orders
            self?.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    
    // costume edit button text:
    
    override func setEditing (_ editing:Bool, animated:Bool){
        
       super.setEditing(editing,animated:animated)
        
        if(self.isEditing){
            
        self.editButtonItem.title = "סיום"
            
       }else{
            
        self.editButtonItem.title = "ביטול תור"
       }
     }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         
         cell.alpha = 0
         UIView.animate(withDuration: 0.75) {
             cell.alpha = 1
         }
     }
    
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userOrders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "queueCell", for: indexPath)

        if let cell = cell as? QueueTableViewCell{
            cell.populate(with: userOrders[indexPath.row])
        }

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    // cancle the swipe to delete:
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        if tableView.isEditing {
            return .delete
        }

        return .none
    }
    
    // costume the delete text:
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
         let deleteButton = UITableViewRowAction(style: .default, title: "בטל תור") { (action, indexPath) in
             self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
             return
         }

         deleteButton.backgroundColor = UIColor.red
         return [deleteButton]
     }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //send Email to the costumer and the owner about the cancelation
            
            guard let userEmail = Auth.auth().currentUser?.email else{return}
            
           
                
            FirebaseDataSource.shared.getUserName {[weak self](name) in
                // send to customer:
                
                guard let date = self?.userOrders[indexPath.row].date else{return}
                guard let hour = self?.userOrders[indexPath.row].startTime else{return}
                
                
                let emailBody = "<p style='text-align:right'><h1> שלום \(name),</h1><br/> התור שניקבע עבורך לתאריך \(date) <br/> בשעה \(hour) <br/> בוטל לבקשתך , מקווים לשמוע ממך בעתיד. </p>"
                
                SendEmail().sendEmail(htmlBody: emailBody, subject: "ביטול תור", from: "Spa4U", to: name, custumerEmail: userEmail, mailToCustomer: true )
            }
            
            // send to owner:
            FirebaseDataSource.shared.getUserName {[weak self](name) in
                
                guard let date = self?.userOrders[indexPath.row].date else{return}
                guard let hour = self?.userOrders[indexPath.row].startTime else{return}
                
                let emailBody = "<p style='text-align:right'><h1>ביטול תור</h1><br/>ביטל את התור שניקבע לו   \(name) בתאריך \(date) בשעה \(hour)</p>"
                
                SendEmail().sendEmail(htmlBody: emailBody, subject: "ביטול תור", from: "Nitszan's Spa", to: name, custumerEmail: userEmail, mailToCustomer: false)
                
                //delete from firebase:
                self?.deleteQueueFromFirebase(queue: (self?.userOrders[indexPath.row])!)
                
                // delete from table view:
                 
                 self?.userOrders.remove(at: indexPath.row)
                 tableView.deleteRows(at: [indexPath], with: .fade)
            }
                
            showSucsses(title: "תור בוטל")
            
            //reload the table:
            self.tableView.reloadData()
            
        }
    }
    
    func deleteQueueFromFirebase(queue:MassageQueue){
        
        let qID = queue.queueID
        let ref = MassageQueue.massageRef
        ref.child(qID).removeValue()
        
    }
}

extension MyQueuesTableViewController:ShowHUDMessage{}
