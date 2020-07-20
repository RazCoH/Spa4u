//
//  Router.swift
//  MassagesApp
//
//  Created by raz cohen on 19/06/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class Router {
    //properties:
    
    //the app main window (windows shows view controllers)
    weak var window:UIWindow?
    static let shared = Router()
    
    //is the user log in?
    var isLoggedIn:Bool{
        
        return Auth.auth().currentUser != nil // if user not nil logged in = true
    }
    private init(){}
    
    func chooseMainViewController(){
        //make sure that we are on the ui thread
        
        // only the ui thread may change view controllers
        guard Thread.current.isMainThread else{
            // call this method agin on the ui thread:
            DispatchQueue.main.async {[weak self] in
                self?.chooseMainViewController()
            }
            return
        }
        
        // here we are 100% on the UIThread
        //print(isLoggedIn ? "Yes" : "No")
        let fileName = isLoggedIn ? "Main" : "LogIn"
        let sb = UIStoryboard(name: fileName, bundle: .main)
        window?.rootViewController = sb.instantiateInitialViewController()
    }
}


