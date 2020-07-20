//
//  FirebaseDataSource.swift
//  MassagesApp
//
//  Created by raz cohen on 23/06/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation
import Firebase

class FirebaseDataSource{
    
    //Singletone:
    
    static let shared = FirebaseDataSource()
    private init(){}
    
    
    //array of all the hours
    //emty array to fill it with all the avilable hours
    
    
    func getOrders(callback:@escaping([MassageQueue])->Void){
        
        var orders = [MassageQueue]()
        let r = MassageQueue.massageRef
        
        r.observe(.childAdded) {(snapshot) in
            guard let dict = snapshot.value as? [String:Any],
                let massage = MassageQueue(dict: dict)
                else{print("bad dict");return}

            orders.append(massage)
    
                DispatchQueue.main.async {

                   callback(orders)

                }
            }
        }
    
    
    func getUserOrders(callback:@escaping([MassageQueue])->Void){
        
        var userOrders = [MassageQueue]()
        let uid = Auth.auth().currentUser?.uid
        let r = MassageQueue.massageRef
        
        r.observe(.childAdded) {(snapshot) in
            guard let dict = snapshot.value as? [String:Any],
                let massage = MassageQueue(dict: dict)
                else{print("bad dict");return}
            
            if massage.userID == uid{
                
                userOrders.append(massage)

            }
            
            DispatchQueue.main.async {
                
                callback(userOrders)
                
            }
        }
    }
    
    func getUserName(callback:@escaping(String)->Void){
    
          let ref = Database.database().reference()
          guard let userID = Auth.auth().currentUser?.uid else{return}
          ref.child("users").child(userID).child("name").observe(.value) { (snapshot) in
              guard let name = snapshot.value else{return}
              
              DispatchQueue.main.async {
                callback(name as! String)
              }
          }
      }
    
    
    func deletePssedQueues(){
        
        FirebaseDataSource.shared.getUserOrders {[weak self] (orders) in
            
            for order in orders{
                
                let today =  Date()
                guard let orderDate = self?.castToDate(string: order.date)else{return}
                
                
                if today > orderDate{
                    
                    deleteQueueFromFirebase(queue: order)

                }
            }
        }
    }
}

func deleteQueueFromFirebase(queue:MassageQueue){
      
      let qID = queue.queueID
      let ref = MassageQueue.massageRef
      ref.child(qID).removeValue()
      
  }

extension FirebaseDataSource{
    
    func castToDate(string:String)->Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        guard let dateInFormat = dateFormatter.date(from: string) else { return Date() }
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        let epochDate = dateInFormat.timeIntervalSince1970
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
        return timeZoneOffsetDate
        
    }
    
}
