//
//  TransferMoneyController.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 1/27/15.
//  Copyright (c) 2015 mtu. All rights reserved.
//

import Foundation
import UIKit

class TransferMoneyController : UIViewController, ConnectionManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var totalField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConnectionManager.sharedInstance.delegate = self
        phoneField.delegate = self
        totalField.delegate = self
        let iconImg = UIImage(named: "menu")
        let menuBtn = UIBarButtonItem(image: iconImg, style: UIBarButtonItemStyle.Plain, target: self, action: "toogle:")
        self.parentViewController?.navigationItem.setRightBarButtonItem(menuBtn, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        //
    }
    
@IBAction func sendMoney(sender: UIButton) {
    
    let promoListRequest = ["UID":EVOUidSingleton.sharedInstance.userID(),"SUM":(totalField.text as NSString).doubleValue, "RCD":"1234","RPN":(phoneField.text as NSString).doubleValue] as Dictionary<String,AnyObject>
    let params = ["RQS":promoListRequest, "M": 225] as Dictionary<String,AnyObject>
    
    var err: NSError?
    let finalJSONData = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: &err)
    let stringJSON : String = NSString(data: finalJSONData!, encoding: NSUTF8StringEncoding)!
    
    ConnectionManager.sharedInstance.socket.writeString(stringJSON)
    self.phoneField.text = ""
    self.totalField.text = ""
}
    func toogle(sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true);
    }
}

extension TransferMoneyController : ConnectionManagerDelegate {
    func connectionManagerDidRecieveObject(responseObject: AnyObject) {
        let recStatus = responseObject["C"] as! Bool
        var errMsg = ""
        if recStatus {
            errMsg = "Success transfer"
            
        } else {
            errMsg = "Failed transfer"
        }
        let failAlert = UIAlertController(title: "Recovery status", message: errMsg, preferredStyle: UIAlertControllerStyle.Alert)
        failAlert.addAction(UIAlertAction(title: "Okay",
            style: UIAlertActionStyle.Default,
            handler: {(alert: UIAlertAction!) in println("-__-")}))
        self.presentViewController(failAlert, animated: true, completion: {
            
        })
    }
}