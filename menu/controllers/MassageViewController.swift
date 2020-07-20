//
//  MassageViewController.swift
//  MassagesApp
//
//  Created by raz cohen on 12/06/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit

var massagePrice = Int()

class MassageViewController: UIViewController {
    
    //MARK: variables
    
    static var massage = Massage(
        
        name: "",
        description: "",
        image: UIImage(),
        priceForHalfHour: 0,
        priceForHour: 0,
        priceForHourAndHalf: 0
        
    )
    
    static var queueDate = String()
    static var queueHour = String()
    
    //MARK: outlets
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateBtnOutlet: UIButton!
    @IBOutlet weak var hourBtnOutlet: UIButton!
    @IBOutlet weak var continueBtnOutlet: UIButton!
    
    @IBOutlet weak var myStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMassage()
        hourBtnOutlet.isEnabled = false
        continueBtnOutlet.isEnabled = false
        massagePrice = MassageViewController.massage.priceForHalfHour
        
        makeCircle(button: continueBtnOutlet, number: 2)
        makeCircle(button: dateBtnOutlet, number: 4)
        makeCircle(button: hourBtnOutlet, number: 4)
        
        customeSegment()

        customeForDevice()
        resizedIcons()
        
    }
    
    //MARK: functions
    
    func customeSegment(){
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
            UIColor.darkGray,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20)], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
            UIColor.white], for: .selected)
    }
    
    func customeForDevice(){
        
        let device =  UIDevice().name
        
        switch device {
            
        case "iPhone 11 Pro Max","iPhone 11 Pro","iPhone 11","iPhone 8 Plus":
            
            myStack.spacing = 60
            
        default:
            
            myStack.spacing = 40
            descriptionLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)
        }
    }
    
    func resizedIcons(){
        
        let icons = [dateBtnOutlet,hourBtnOutlet]
        
        for icon in icons{
            
            let iconImage = icon?.imageView?.image
            
            let resizedIcon = iconImage?.resized(with: CGSize(width: 40, height: 40)).withTintColor(.white)
            
            icon?.setImage(resizedIcon, for: .normal)
        }
        
    }
    
    func initMassage(){
        
        nameLabel.text = MassageViewController.massage.name
        descriptionLabel.text = MassageViewController.massage.description
        descriptionLabel.textAlignment = .right
        let price = priceFormat(price: MassageViewController.massage.priceForHalfHour)
        priceLabel.text = price
        
    }
    

    
    //MARK: actions
    
    @IBAction func continueBtn(_ sender: UIButton) {
        
        performSegue(withIdentifier: "toSummery", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if let dest = segue.destination as? OrderViewController{
            
            dest.name = MassageViewController.massage.name
            dest.date = MassageViewController.queueDate
            dest.time = MassageViewController.queueHour
        }
    }

    @IBAction func pickDate(_ sender: UIButton) {
        
        //(1) show date popup:
        
        let sb = UIStoryboard(name: "DatePopUp", bundle: .main)
        guard let vc = sb.instantiateViewController(identifier: "calendarSB") as? DatePopUpViewController else{return}
        
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
        
        //(2) get the chosen date:
        NotificationCenter.default.addObserver(forName: .saveDate, object: nil, queue: .main) { [weak self](notification) in
            if let chosenDate = notification.userInfo?["date"]as? String{
               
                MassageViewController.queueDate = chosenDate
                self?.hourBtnOutlet.isEnabled = true
            }
        }
    }
    
    @IBAction func pickHour(_ sender: UIButton) {
        
        //(1) show hour popup
        let sb = UIStoryboard(name: "HourPopUp", bundle: .main)
        guard let vc = sb.instantiateViewController(identifier: "hourSB") as?
            HourPopUpViewController else{return}
        
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
        
        //(2) get the chosen hour:
        NotificationCenter.default.addObserver(forName: .saveHour, object: nil, queue: .main) { [weak self](notification) in
            if let chosenHour = notification.userInfo?["hour"]as? String{
                
                MassageViewController.queueHour = chosenHour
                self?.continueBtnOutlet.isEnabled = true
            }
        }
    }
    
    
    @IBAction func timeSegment(_ sender: UISegmentedControl) {
        
        let index = segmentOutlet.selectedSegmentIndex
        
        switch index {
            
        case 0:
            
            priceLabel.text = priceFormat(price: MassageViewController.massage.priceForHalfHour)
            massagePrice = MassageViewController.massage.priceForHalfHour
            
        case 1:
            
            priceLabel.text = priceFormat(price: MassageViewController.massage.priceForHour)
            massagePrice = MassageViewController.massage.priceForHour
        case 2:
            
            priceLabel.text = priceFormat(price: MassageViewController.massage.priceForHourAndHalf)
            massagePrice = MassageViewController.massage.priceForHourAndHalf
            
        default:
            break
        }
        
    }
    
}

extension MassageViewController:RoundButton{}
extension MassageViewController:CurrencyFormat{}
