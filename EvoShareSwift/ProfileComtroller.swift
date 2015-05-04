//
//  ProfileComtroller.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 12/21/14.
//  Copyright (c) 2014 mtu. All rights reserved.
//

import Foundation
import UIKit

class ProfileController : UIViewController, ConnectionManagerDelegate {
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var refFriendLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConnectionManager.sharedInstance.delegate = self
        let iconImg = UIImage(named: "menu")
        let menuBtn = UIBarButtonItem(image: iconImg, style: UIBarButtonItemStyle.Plain, target: self, action: "toogle:")
        self.navigationItem.setRightBarButtonItem(menuBtn, animated: true)
        
        let locale = NSLocale.currentLocale()
        let countryCode = locale.objectForKey(NSLocaleCountryCode) as! String
        
        let promoListRequest = ["UID":EVOUidSingleton.sharedInstance.userID(),"LOC":countryCode, "DBG":true] as Dictionary<String,AnyObject>
        let params = ["RQS":promoListRequest, "M": 210] as Dictionary<String,AnyObject>
        
        var err: NSError?
        let finalJSONData = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: &err)
        let stringJSON : String = NSString(data: finalJSONData!, encoding: NSUTF8StringEncoding)!
        
        ConnectionManager.sharedInstance.socket.writeString(stringJSON)
    }
    
    override func didReceiveMemoryWarning() {
        //
    }
    
    func toogle(sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
}

extension ProfileController : ConnectionManagerDelegate {
    func connectionManagerDidRecieveObject(responseObject: AnyObject) {
        let responseDict : [String:AnyObject] = responseObject as! [String:AnyObject]
        let phnc = responseDict["PHC"] as! String
        let phnn = responseDict["PHN"] as! String
        let country = responseDict["CTR"] as! String
        let email = responseDict["EML"] as! String
        let fullname = responseDict["FNM"] as! String
        let refName = responseDict["RNM"] as! String
        
        self.phoneNumber.text = phnc + phnn
        self.countryField.text = country
        self.emailField.text = email
        self.fullNameField.text = fullname
        self.refFriendLabel.text = refName
    }
}