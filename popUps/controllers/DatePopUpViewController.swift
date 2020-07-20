//
//  DatePopUpViewController.swift
//  MassagesApp
//
//  Created by raz cohen on 23/06/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import FSCalendar

class DatePopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        calendarView.layer.masksToBounds = true
        calendarView.layer.cornerRadius =
            (calendarView.frame.height) / 20
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.customizeCalenderAppearance()
    
    }
    
    //MARK: outlets
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarView: UIView!
    
    //MARK: variables
    
    //MARK: actions
    
    //MARK: functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismiss(animated: true)
    }
}


extension DatePopUpViewController:FSCalendarDelegate,FSCalendarDelegateAppearance{
    
    // selected date:
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        let dateString = formatter.string(from: date)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: .saveDate, object: nil, userInfo: ["date":dateString])
        
        dismiss(animated: true)

        
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        
        if date < maximumDate(for: calendar) && date > minimumDate(for: calendar){
            return #colorLiteral(red: 0.5783475041, green: 0.8825933933, blue: 0.8178908825, alpha: 1)
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
            return #colorLiteral(red: 1, green: 0.6509803922, blue: 0.6196078431, alpha: 1)
    }
}

extension DatePopUpViewController:FSCalendarDataSource{
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        
        let currentdate = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentdate)
        
        // if the current time is later than 22:00 so it impossible to make order for today
        
        if hour < 22{
        
            return currentdate

        }else{
            
            var dateComponents = DateComponents()
            dateComponents.setValue(1, for: .day);
            guard let tomarrow = Calendar.current.date(byAdding: dateComponents, to: currentdate)else{return currentdate}
            
            return tomarrow
            
        }
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        
        let calendar = Calendar.current
        guard let addOneWeekToCurrentDate = calendar.date(byAdding: .weekOfYear, value: 2, to: Date()) else{return Date()}
        
        return addOneWeekToCurrentDate
    }
    
}


extension FSCalendar {
    func customizeCalenderAppearance() {
        self.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesSingleUpperCase]
    
        
        self.appearance.headerTitleColor     = #colorLiteral(red: 0.9411764706, green: 0.4431372549, blue: 0.4039215686, alpha: 1)
        self.appearance.weekdayTextColor     = #colorLiteral(red: 0.9411764706, green: 0.4431372549, blue: 0.4039215686, alpha: 1)
        self.appearance.todayColor           = #colorLiteral(red: 0.5783475041, green: 0.8825933933, blue: 0.8178908825, alpha: 1)
       
        
    }
}
