//
//  MyHistoryController.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 1/23/15.
//  Copyright (c) 2015 mtu. All rights reserved.
//

import Foundation
import UIKit

class MyHistoryController : UIViewController, ConnectionManagerDelegate {
    
    @IBOutlet weak var historyTextView: UITextView!
    var history : String?
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
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

extension MyHistoryController : ConnectionManagerDelegate {
    func connectionManagerDidRecieveObject(responseObject: AnyObject) {
        self.historyTextView.text = self.historyTextView.text + "\n"
        let responseDict : [String:AnyObject] = responseObject as! [String:AnyObject]
        let historyArray : [Dictionary] = responseDict["HBL"] as! [[String:AnyObject]]
        for dates in historyArray {
            let id : Int? = dates["ID"] as? Int
            let date : String? = dates["DT"] as? String
            let type : String? = dates["TYP"] as? String
            let summ : Double = dates["SUM"] as! Double
            let isVeryfied : Bool = dates["IVR"] as! Bool
            let currency : String? = dates["CYR"] as? String
            
            var historyStr : String = String(format: "%@ - %@ - %.2f %@\n", date!,type!,summ,currency!)
            self.historyTextView.text = self.historyTextView.text + historyStr
        }
    }
}