//
//  QueueTableViewCell.swift
//  MassagesApp
//
//  Created by raz cohen on 27/06/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit

class QueueTableViewCell: UITableViewCell {

//MARK: outlets
    
    
    @IBOutlet weak var massageImage: UIImageView!
    @IBOutlet weak var massageName: UILabel!
    @IBOutlet weak var queueDate: UILabel!
    @IBOutlet weak var queueTime: UILabel!
    
    func populate(with queue: MassageQueue){
        
        massageName.textAlignment = .right
        massageName.text = queue.nameOfMassage
        queueDate.text = queue.date
        queueTime.text = queue.startTime
    
        switch massageName.text {

        case CodingKeys.faceMassage.rawValue:

            massageImage.image = UIImage(massagesImages: .faceMassage)
        
        case CodingKeys.backMassage.rawValue:

            massageImage.image = UIImage(massagesImages: .backMassage)

        case CodingKeys.thaiMassage.rawValue:

            massageImage.image = UIImage(massagesImages: .thaiMassage)

        case CodingKeys.coupleMassage.rawValue:

            massageImage.image = UIImage(massagesImages: .coupleMassage)

        case CodingKeys.manMassage.rawValue:

            massageImage.image = UIImage(massagesImages: .manMassage)
        
        default:
            break
        }
        
        
    }
}
