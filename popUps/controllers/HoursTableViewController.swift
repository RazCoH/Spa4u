//
//  HoursTableViewController.swift
//  MassagesApp
//
//  Created by raz cohen on 15/06/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

var queueHour = String()

class HoursTableViewController: UITableViewController {
    
    //MARK: variables
    
    // array of all the posible hours
    
    var allHours:[String] = {
        
        var hoursArray: [String] = []
        let closeHour: Double = 22
        var currentTime: Double = 11
        let interevalMinutes: Double = 30 // increment by 30 minutes
        
        while currentTime < closeHour {
            
            currentTime += (interevalMinutes/60)
            let hours = Int(floor(currentTime))
            let minutes = Int(currentTime.truncatingRemainder(dividingBy: 1)*60)
            
            if minutes == 0 {
                
                hoursArray.append("\(hours):00")
                
            } else {
                
                hoursArray.append("\(hours):\(minutes)")
            }
        }
        return hoursArray
        
    }()
    
    var hoursToPresent = [String]()
    var passedHours = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let d = MassageViewController.queueDate
        let date = castToDate(string: d)
        
        presentAvailableHours(date: date)
    }
    
    func presentAvailableHours(date:Date){
        
        HUD.show(.progress)
        
        var availableHours = [String]()
        var hoursInChosenDate = [String]()
        
        FirebaseDataSource.shared.getOrders {(orders) in
            
                //(1) loop for all the orders:
            for order in orders{
                
                let orderDate = self.castToDate(string: order.date)
                
                //(2) orders with the chosen date:
                
                if date == orderDate{
                    
                    if !hoursInChosenDate.contains(order.startTime){
                        hoursInChosenDate.append(order.startTime)
                    }
                }
                
                //(3) remove the taken hours from the all the hours
                
                availableHours = Array(Set(self.allHours).subtracting(hoursInChosenDate))
                
                
                //(4) remove the erlier hours than now
                
                let currentDate = Date()
                let calendar = Calendar.current
                let currentHour = calendar.component(.hour, from: currentDate)
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yy"
                let currentDateString = formatter.string(from: currentDate)
                let chosenDate = MassageViewController.queueDate
                
                if chosenDate == currentDateString{
                    
                    for ah in availableHours{
                        
                        let ahArr = ah.components(separatedBy: ":")
                        let hour = ahArr[0]
                        guard let intHour = Int(hour) else{return}
                        
                        if currentHour >= intHour{
                            self.passedHours.append(ah)
                        }
                    }
                    availableHours = Array(Set(availableHours).subtracting(self.passedHours))
                }
                
                //(5) sort the array:
                
                let start = "11:30"
                let end = "22:00"
                
                availableHours = availableHours.sorted{
                    $0.hasSuffix(start) && !$1.hasSuffix(end) ? true :
                        $0.localizedStandardCompare($1) == .orderedAscending
                    
                }
                
                self.hoursToPresent = availableHours
                self.tableView.reloadData()
                
            }
            HUD.hide()
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return hoursToPresent.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        UIView.animate(withDuration: 0.75) {
            cell.alpha = 1
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "hourCell", for: indexPath)
        
        if let cell = cell as? HourCell{
            
            cell.hourLabel.text = hoursToPresent[indexPath.row]
            
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chosenHour = hoursToPresent[indexPath.row]
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: .saveHour, object: nil, userInfo: ["hour":chosenHour])
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension HoursTableViewController{
    
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

