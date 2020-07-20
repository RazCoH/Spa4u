//
//  ProtocolsAndExtentions.swift
//  MassagesApp
//
//  Created by raz cohen on 24/06/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation
import UIKit
import PKHUD
import SkyFloatingLabelTextField

extension Notification.Name{
    
     static let saveHour = Notification.Name("saveHour")
     static let saveDate = Notification.Name("saveDate")
    
}

extension UIImage{
    
    enum MassagesImages:String{
        
        case faceMassage = "faceMassage"
        case thaiMassage = "thaiMassage"
        case manMassage = "manMassage"
        case backMassage = "backMassage"
        case coupleMassage = "coupleMassage"
        
        static let values = [faceMassage,thaiMassage,manMassage,backMassage,coupleMassage]
        
    }
    
    convenience init!(massagesImages: MassagesImages){
        self.init(named:massagesImages.rawValue)
    }
}

extension UIImage{
    func resized(with size:CGSize)->UIImage{
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { [weak self](context) in
            self?.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

protocol CurrencyFormat{}

extension CurrencyFormat{
    
    func priceFormat(price:Int) -> String{
        
          let formatter = NumberFormatter()
          formatter.numberStyle = .currency
          formatter.locale = Locale(identifier: "en_IL")
          guard let formattedPrice = formatter.string(from: NSNumber(value: price)) else{return ""}
          let wholeText = "\(formattedPrice)"
          let priceArr = wholeText.components(separatedBy: ".")
          let priceToPresent = priceArr[0]
        
        return priceToPresent
    }
}

protocol ShowHUDMessage{}

extension ShowHUDMessage{
    
    func showProgress(title:String? = nil,subtitle:String? = nil){
        HUD.show(.labeledProgress(title: title, subtitle: subtitle))
    }
    
    func showError(title:String? = nil,subtitle:String? = nil){
        HUD.flash(.labeledError(title: title, subtitle: subtitle),delay: 3)
    }
    
    func showSucsses(title:String? = nil,subtitle:String? = nil){
        HUD.flash(.labeledSuccess(title: title, subtitle: subtitle),delay: 2)
    }
}

protocol RoundButton{}

extension RoundButton{
    func makeCircle(button:UIButton,number:CGFloat){
        button.layer.masksToBounds = true
        button.layer.cornerRadius = (button.frame.height) / number
    }
}

protocol OfflinAlert{}
extension OfflinAlert{
    
    func showOfflineAlert(view:UIViewController){
        
        let alert = UIAlertController(title: "חיבור אינטרנט לא זמין",
                                      message: "הפעולה שבירצונך לבצע דושרת חיבור לרשת. אנא כנס להגדרות המכשיר שלך והתחבר לרשת.",
                                      preferredStyle: .alert)
        
        alert.addAction(.init(title: "הגדרות", style: .default, handler: {(action) in
            
            if let url = URL.init(string: UIApplication.openSettingsURLString){
                
                UIApplication.shared.open(url,options: [:], completionHandler: nil)
                
            }
        }))
        
        alert.addAction(.init(title: "סגור", style: .destructive, handler: { (action) in}))
        
        view.present(alert, animated: true)
    }
    
}

protocol TextFieldUI{}
extension TextFieldUI{
    
        func textFieldsUI(text:String, title: String, imageSystemName:String , position: CGRect , passwordType:Bool , view: UIView)-> SkyFloatingLabelTextFieldWithIcon{
            
            let color = #colorLiteral(red: 1, green: 0.5009384155, blue: 0.4935207963, alpha: 1)
            let textFieldFrame = position
            let textField = SkyFloatingLabelTextFieldWithIcon(frame: textFieldFrame , iconType: .image)
            textField.isLTRLanguage = false
            textField.placeholder = text
            textField.title = title
            textField.selectedTitleColor = color
            textField.lineColor = color
            textField.tintColor = color
            textField.textColor = #colorLiteral(red: 0.2862745098, green: 0.3450980392, blue: 0.4039215686, alpha: 1)
            
            if passwordType{
                
                textField.isSecureTextEntry = true
                
            }
            
            textField.iconImage = UIImage(systemName: imageSystemName)
            textField.iconColor = color
            textField.lineHeight = 1.0
            textField.selectedLineColor = color
            textField.selectedLineHeight = 2.5
            textField.titleFont = UIFont(name: "Hiragino Maru Gothic Pro W4", size: 14)!
            textField.placeholderFont = UIFont(name: "Hiragino Maru Gothic Pro W4", size: 16)!
            textField.selectedIconColor = color
            textField.errorColor = .red
            
            view.addSubview(textField)
            return textField
        }
    }


