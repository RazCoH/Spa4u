//
//  MassageQueue.swift
//  MassagesApp
//
//  Created by raz cohen on 21/06/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation
import Firebase

class MassageQueue: FirebaseModel {
    
    
    //properties:
    
    let queueID:String
    let userID:String
    let date:String
    let startTime:String
    let nameOfMassage:String
    let price:Int
    
    var dict: [String : Any]{
        
        let dict = [
            
            "queueID":queueID,
            "userID":userID,
            "date":date,
            "startTime":startTime,
            "nameOfMassage":nameOfMassage,
            "price":price
            
            
            ]
            
            as [String : Any]
        
        return dict
    }
    
    init(name:String , date:String, startTime:String , price:Int , userID:String){
        
        self.queueID = UUID().uuidString
        self.userID = userID
        self.date = date
        self.startTime = startTime
        self.nameOfMassage = name
        self.price = price
    }
    
    required init?(dict: [String : Any]) {
        
        guard
            
            let queueID = dict["queueID"] as? String,
            let userID = dict["userID"] as? String,
            let date = dict["date"] as? String,
            let startTime = dict["startTime"] as? String,
            let nameOfMassage = dict["nameOfMassage"] as? String,
            let price = dict["price"] as? Int
            
            
            else{ print("!!! bad Json")
                return nil
                
        }
        self.queueID = queueID
        self.userID = userID
        self.date = date
        self.startTime = startTime
        self.nameOfMassage = nameOfMassage
        self.price = price
    }
    
}


extension MassageQueue{
    
    
    static var massageRef:DatabaseReference {
        
        return Database.database().reference().child("queues")
    }
    
    var ref: DatabaseReference{
        
        return Database.database().reference().child("queues").child(queueID)
    }
    
    func saveToDB(){
        
        ref.setValue(dict)
        
    }
    
}
