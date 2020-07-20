//
//  FirebaseModel.swift
//  MassagesApp
//
//  Created by raz cohen on 21/06/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation

// protocol create unionity in th app , the code in the protocole is vailable for eacth class that implement it
protocol FirebaseModel{
    
    //from json:
    init?(dict:[String:Any])
    
    //to json:
    var dict:[String:Any]{get}
}

//when you use protocol you get:

extension FirebaseModel{
    //property every instance has it's own formatter
    //static property = formatter is shared
    
    //shared formatter:
    static var formatter:ISO8601DateFormatter{
        let formtter = ISO8601DateFormatter()
        formtter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formtter
    }
}
