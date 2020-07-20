//
//  Massage.swift
//  MassagesApp
//
//  Created by raz cohen on 11/06/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation
import UIKit

struct Massage{

    let name:String
    let description:String
    let image:UIImage
    let priceForHalfHour:Int
    let priceForHour:Int
    let priceForHourAndHalf:Int    
}

var massages:[Massage] = {
    
    let faceMassage = Massage(name:"פני מלאך",
                              description: "טיפול המשפר את מרקם העור. מבוסס על מרכיבים טבעיים המטפלים בעומק רקמת העור ומשווים לו מראה צעיר ורענן.",
                              image: #imageLiteral(resourceName: "face"), priceForHalfHour: 100, priceForHour: 160, priceForHourAndHalf: 200)
    
    let thaiMassage = Massage(name:"מסאז׳ תאילנדי",
                              description: "עיסוי תאילנדי מסורתי המשלב טכניקות עיסוי מגוונות, הטיפול מתבצע עם תרכובת ייחודית של שמנים ארומטיים.",
                              image: #imageLiteral(resourceName: "thaiMassage"), priceForHalfHour: 120, priceForHour: 180, priceForHourAndHalf: 220)
    
    let manMassage = Massage(name:"עיסוי מלכים",
                             description: "טיפול מיוחד לעור הגברי, לחידוש העור ושפע של לחות לעור קורן ובריא. מומלץ לכל גבר המודע ומעריך את מראה העור שלו ומפרגן לעצמו.",
                             image: #imageLiteral(resourceName: "manMassage"), priceForHalfHour: 160, priceForHour: 200, priceForHourAndHalf: 240)
    
    let backMassage = Massage(name:"להתחיל מחדש",
                              description: "עיסוי השם דגש על הרפיית ושיחרור השרירים , טיפול המשלב מגוון טכניקות מן המזרח הרחוק יחד עם שמנים ארומטיים. ",
                              image: #imageLiteral(resourceName: "backMassage"), priceForHalfHour: 140, priceForHour: 180, priceForHourAndHalf: 220)
    
    let coupleMassage = Massage(name:"עיסוי זוגי",
                                description: "חוויה רומנטית של שחרור והרפיה, טכניקות עיסוי מגוונות ואבנים חמות",
                                image: #imageLiteral(resourceName: "coupleMassage"), priceForHalfHour: 200, priceForHour: 280, priceForHourAndHalf: 350)
    
    
    return [faceMassage,thaiMassage,manMassage,backMassage,coupleMassage]
}()


