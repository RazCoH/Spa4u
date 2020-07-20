//
//  FirstViewController.swift
//  MassagesApp
//
//  Created by raz cohen on 10/06/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class FirstViewController: UIViewController {
    
    var mq: MassageQueue?
    
    //MARK: outlets
    
    
    @IBOutlet weak var insagramOtlet: UIButton!
    @IBOutlet weak var facebookOutlet: UIButton!
    @IBOutlet weak var whatsappOutlet: UIButton!
    
    @IBOutlet weak var mainText: UILabel!
    
    @IBOutlet weak var logOutBtnOutlet: UIButton!
    
    @IBOutlet weak var showOnMap: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let text = "אנחנו ב - Spa4u מזמינים אותך לבוא ולהירגע, להרפות את השרירים ולהנות מעיסוי מפנק באווירה פסטורלית מלווה בניחוחות בשמים וקטורת מן המזרח הרחוק. בתפריט עיסויים שלנו תוכל/י לבחור מבין מגוון עיסויים ב- 10% הנחה למזמינים באפליקציה."
        
        mainText.text = text
        mainText.textAlignment = .right
        
        mainText.alpha = 0
        showOnMap.alpha = 0
        insagramOtlet.alpha = 0
        facebookOutlet.alpha = 0
        whatsappOutlet.alpha = 0
        
        makeCircle(button: showOnMap, number: 2)
        
        let buttons = [insagramOtlet,facebookOutlet,whatsappOutlet]
        changeIconSize(buttons: buttons as! [UIButton])
        FirebaseDataSource.shared.deletePssedQueues()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.8, animations: {
            self.mainText.alpha = 1
        }) {[weak self] (true) in
            self?.showMapBtn()
        }
    }

    //MARK: functions
    
    func showMapBtn(){
       
        UIView.animate(withDuration: 1, animations: {
            self.showOnMap.alpha = 1
        }) {[weak self] (true) in
            
            self?.showSocialMediaBtns()
        }
    }
    
    func showSocialMediaBtns(){
        UIView.animate(withDuration: 1, animations: {
            
            self.insagramOtlet.alpha = 1
            self.facebookOutlet.alpha = 1
            self.whatsappOutlet.alpha = 1
        })
    }
    
    func changeIconSize(buttons:[UIButton]){
        
        for b in buttons{
            let bImage = b.imageView?.image
            let resizedIcon = bImage?.resized(with: CGSize(width: 40, height: 40))
            b.setImage(resizedIcon, for: .normal)
            
            makeCircle(button: b, number: 2)
        }
        
    }
    
    //MARK: actions

    @IBAction func logOut(_ sender: UIButton) {
        
        do{
            try Auth.auth().signOut()
            Router.shared.chooseMainViewController()
            
        }catch let error{
            print("Error!",error)
        }
    }
    
    
    @IBAction func openInstagram(_ sender: UIButton) {
        
        let claientInstagramAccountLink = ""
        let instagramHooks = "instagram://user?username=\(claientInstagramAccountLink)"
        let instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
            UIApplication.shared.open(instagramUrl! as URL)
        } else {
          
            UIApplication.shared.open(NSURL(string: "http://instagram.com/")! as URL)
        }
    }
    
    
    @IBAction func openFacebook(_ sender: UIButton) {
      
        let claientFacebookAccountLink = ""
        let facebookHooks = "facebook://user?username=\(claientFacebookAccountLink)"
        let facebookUrl = NSURL(string: facebookHooks)
        if UIApplication.shared.canOpenURL(facebookUrl! as URL) {
            UIApplication.shared.open(facebookUrl! as URL)
        } else {
          
            UIApplication.shared.open(NSURL(string: "http://facebook.com/")! as URL)
        }
        
    }
    
    
    @IBAction func openWhatsapp(_ sender: UIButton) {
        
        let claientNumber = ""
        let urlWhats = "whatsapp://send?phone=+972\(claientNumber)&abid=12354"
        
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL) {
                    UIApplication.shared.open(whatsappURL)
                } else {
                  showError(title: "שגיאה", subtitle:"היישומן whatsapp לא מותקן במכשירך")
                }
            }
        }
    }
}

extension FirstViewController:RoundButton{}
extension FirstViewController:ShowHUDMessage{}

