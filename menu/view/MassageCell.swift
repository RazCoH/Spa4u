//
//  MassageCell.swift
//  MassagesApp
//
//  Created by raz cohen on 11/06/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit

class MassageCell: UITableViewCell {

    //MARK: outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var massageImage: UIImageView!
    
    func populate(with massage: Massage){
        
        titleLabel.text = massage.name
        titleLabel.textAlignment = .right
    
        massageImage.image = massage.image
        
        massageImage.layer.masksToBounds = true
        massageImage.layer.cornerRadius =
            (massageImage.frame.height) / 10
        
    }

}


