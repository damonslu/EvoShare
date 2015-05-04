//
//  MyBalanceController.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 1/23/15.
//  Copyright (c) 2015 mtu. All rights reserved.
//

import Foundation
import UIKit

class MyBalanceController : UIViewController, ConnectionManagerDelegate {
    @IBOutlet weak var fullBalance: UILabel!
    
    @IBOutlet weak var fullBalanceCurrency: UILabel!
    @IBOutlet weak var verifiedBalance: UILabel!
    @IBOutlet weak var verifiedBalanceCurrency: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConnectionManager.sharedInstance.delegate = self
        requestData()
        let iconImg = UIImage(named: "menu")
        let menuBtn = UIBarButtonItem(image: iconImg, style: UIBarButtonItemStyle.Plain, target: self, action: "toogle:")
        self.parentViewController?.navigationItem.setRightBarButtonItem(menuBtn, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        //
    }
    
    func toogle(sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
    
    func requestData() {
        let locale = NSLocale.currentLocale()
        let countryCode = locale.objectForKey(NSLocaleCountryCode) as! String
        let promoListRequest = ["UID":EVOUidSingleton.sharedInstance.userID(),"LOC":countryCode, "DBG":true] as Dictionary<String,AnyObject>
        let params = ["RQS":promoListRequest, "M": 216] as Dictionary<String,AnyObject>
        
        var err: NSError?
        let finalJSONData = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: &err)
        let stringJSON : String = NSString(data: finalJSONData!, encoding: NSUTF8StringEncoding)!
        
        ConnectionManager.sharedInstance.socket.writeString(stringJSON)
    }
}

extension MyBalanceController : ConnectionManagerDelegate {
    func connectionManagerDidRecieveObject(responseObject: AnyObject) {
        let responseDict : [String:AnyObject] = responseObject as! [String:AnyObject]
        var fullBalanceText : String = String(format: "%.2f",responseDict["FBL"] as! Double)
        var verBalanceText : String = String(format: "%.2f",responseDict["VBL"] as! Double)
        var curr = responseDict["CYR"] as! String
        
        self.fullBalance.text = fullBalanceText
        self.verifiedBalance.text = verBalanceText
        self.fullBalanceCurrency.text = curr
        self.verifiedBalanceCurrency.text = curr
    }
}