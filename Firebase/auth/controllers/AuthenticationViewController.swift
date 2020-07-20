//
//  AuthenticationViewController.swift
//  MassagesApp
//
//  Created by raz cohen on 02/07/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        makeCircle(button: registerOutlet, number: 2)
    }
    
    //MARK: outlets
    
    @IBOutlet weak var registerOutlet: UIButton!
    
    //MARK: variables
    
    //MARK: actions
    
    
    @IBAction func registerBtn(_ sender: UIButton) {
        
        performSegue(withIdentifier: "toReg" , sender: nil)
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        
        //TODO: forgot password
        
    }
    
    //MARK: functions

}



extension AuthenticationViewController:RoundButton{}
