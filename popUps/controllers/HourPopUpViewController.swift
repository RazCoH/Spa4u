//
//  HourPopUpViewController.swift
//  MassagesApp
//
//  Created by raz cohen on 23/06/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit

class HourPopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        container.layer.masksToBounds = true
        container.layer.cornerRadius =
            (container.frame.height) / 20
    
    }
    
    //MARK: outlets
    
    
    @IBOutlet weak var container: UIView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismiss(animated: true)
    }

}
