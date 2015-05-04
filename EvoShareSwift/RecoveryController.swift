//
//  RecoveryController.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 1/28/15.
//  Copyright (c) 2015 mtu. All rights reserved.
//

import Foundation
import UIKit

class RecoveryController: UIViewController,UITextFieldDelegate,ConnectionManagerDelegate {
    @IBOutlet weak var phoneNumberField: UITextField!
    
    @IBAction func recoverAction(sender: UIButton) {
        var index: String.Index = advance(phoneNumberField.text.startIndex, 3)
        var phoneString = phoneNumberField.text.substringFromIndex(index)
        var phoneCode = phoneNumberField.text.substringToIndex(index)
        let promoListRequest = ["PID":NSUUID().UUIDString,"LCL":NSLocale.currentLocale().objectForKey(NSLocaleCountryCode)!,"PHN":phoneString,"PHC":phoneCode, "DBG":true] as Dictionary<String,AnyObject>
        let params = ["RQS":promoListRequest, "M": 223] as Dictionary<String,AnyObject>
        
        var err: NSError?
        let finalJSONData = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: &err)
        let stringJSON : String = NSString(data: finalJSONData!, encoding: NSUTF8StringEncoding)!
        
        ConnectionManager.sharedInstance.socket.writeString(stringJSON)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ConnectionManager.sharedInstance.delegate = self
        self.phoneNumberField.delegate = self
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        //
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent){
        self.view.endEditing(true);
    }
}

extension RecoveryController : ConnectionManagerDelegate {
    func connectionManagerDidRecieveObject(responseObject: AnyObject) {
        let recStatus = responseObject["C"] as! Bool
        var errMsg = ""
        if recStatus {
            errMsg = "Check your e-mail for password recovery"
            
        } else {
            errMsg = "Failed to recovery password"
        }
        let failAlert = UIAlertController(title: "Recovery status", message: errMsg, preferredStyle: UIAlertControllerStyle.Alert)
        failAlert.addAction(UIAlertAction(title: "Okay",
            style: UIAlertActionStyle.Default,
            handler: {(alert: UIAlertAction!) in println("-__-")}))
        self.presentViewController(failAlert, animated: true, completion: {
            
        })
    }
}
