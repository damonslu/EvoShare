 //
//  RegistrationController.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 11/17/14.
//  Copyright (c) 2014 mtu. All rights reserved.
//

import Foundation
import UIKit
import Starscream

class RegistrationController : UIViewController, UIPickerViewDataSource, ConnectionManagerDelegate, UITextFieldDelegate {
    @IBOutlet weak var registerScrollView: UIScrollView!
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var phoneCode: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var refrealCode: UITextField!
    
    @IBOutlet weak var repeatPassword: UITextField!
    
    var codeTextField : UITextField!
    var countries : [String] = ["Ukraine","Russian","Poland","Moldova"]
    
    @IBAction func register(sender: UIButton) {
        if (password.text != repeatPassword.text) {
            let failAlert = UIAlertController(title: "Registration failed", message: "Password doesn't match", preferredStyle: UIAlertControllerStyle.Alert)
            failAlert.addAction(UIAlertAction(title: "Okay",
                style: UIAlertActionStyle.Default,
                handler: {(alert: UIAlertAction!) in println("-__-")}))
            self.presentViewController(failAlert, animated: true, completion: {
                
            })
        } else if (!self.phoneNumber.text.isEmpty && !self.phoneCode.text.isEmpty && !self.fullName.text.isEmpty && !self.password.text.isEmpty) {
            let codeRequestData = ["PHN":phoneNumber.text,"PHC":phoneCode.text,"SMC":""] as [String:AnyObject]
            var params = ["RQS":codeRequestData, "M": 205] as Dictionary<String,AnyObject>
            println("Foundation dictionary for JSON: \(params)")
            var err: NSError?
            let finalJSONData = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: &err)
            
            var stringJSON = NSString(data: finalJSONData!, encoding: NSUTF8StringEncoding)!
            println("JSON String: \(stringJSON)")
            
            ConnectionManager.sharedInstance.socket.writeString(stringJSON)
            
            var alertController = UIAlertController(title: "Confirm registration", message: "Enter the code from SMS below", preferredStyle: UIAlertControllerStyle.Alert)
            
            var confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default) { (confirm) in
                let codeRequestData = ["PHN":self.phoneNumber.text,"PHC":self.phoneCode.text,"SMC":self.codeTextField.text] as [String:AnyObject]
                var params = ["RQS":codeRequestData, "M": 206] as Dictionary<String,AnyObject>
                println("Foundation dictionary for JSON: \(params)")
                var err: NSError?
                let finalJSONData = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: &err)
                
                var stringJSON = NSString(data: finalJSONData!, encoding: NSUTF8StringEncoding)!
                println("JSON String: \(stringJSON)")
                
                ConnectionManager.sharedInstance.socket.writeString(stringJSON)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (cancel) in
                
            }
            alertController.addAction(cancelAction)
            alertController.addAction(confirmAction)
            alertController.addTextFieldWithConfigurationHandler { (codeField) in
                self.codeTextField = codeField
                codeField.placeholder = "Confirmation code"
                codeField.secureTextEntry = false
                
                NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: codeField, queue: NSOperationQueue.mainQueue()) { (notification) in
                    confirmAction.enabled = (codeField.text != "")
                }
            }
            self.presentViewController(alertController, animated: true) {
            }
            
        } else {
            let failAlert = UIAlertController(title: "Registration failed", message: "Fill all fields", preferredStyle: UIAlertControllerStyle.Alert)
            failAlert.addAction(UIAlertAction(title: "Okay",
                style: UIAlertActionStyle.Default,
                handler: {(alert: UIAlertAction!) in println("-__-")}))
            self.presentViewController(failAlert, animated: true, completion: {
                
            })
        }
    }
    
    func sendRegistration() {
        let locale = NSLocale.currentLocale()
        let countryCode = locale.objectForKey(NSLocaleCountryCode) as! String
        
        var codeString = self.refrealCode.text.substringWithRange(Range<String.Index>(start: self.refrealCode.text.startIndex, end: advance(self.refrealCode.text.endIndex, -9)))
        var phoneString = self.refrealCode.text.substringWithRange(Range<String.Index>(start: advance(self.refrealCode.text.endIndex, -9), end: self.refrealCode.text.endIndex))
        
        let registerData = ["CTR":countryCode,
            "RPN":phoneString,
            "EML":email.text,
            "FNM":fullName.text,
            "RCD":codeString,
            "LCL":countryCode,
            "LGN":(phoneCode.text + phoneNumber.text),
            "PSH":"sad","PHN":phoneNumber.text,
            "PAS":password.text,"PHC":phoneCode.text,
            "PID":NSUUID().UUIDString,
            "LAT":0.0,
            "LON":0.0,
            "OS":2,
            "DBG":true] as Dictionary <String,AnyObject>
        println("Register data:\(registerData)")
        
        var params = ["RQS":registerData, "M": 203] as Dictionary<String,AnyObject>
        println("Foundation dictionary for JSON: \(params)")
        
        var err: NSError?
            let finalJSONData = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: &err)
            
            var stringJSON = NSString(data: finalJSONData!, encoding: NSUTF8StringEncoding)!
            println("JSON String: \(stringJSON)")
            
            ConnectionManager.sharedInstance.socket.writeString(stringJSON)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Registration"
        self.countryPicker.dataSource = self
        self.password.delegate = self
        self.email.delegate = self
        self.phoneCode.delegate = self
        self.phoneNumber.delegate = self
        self.fullName.delegate = self
        self.refrealCode.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
    }
    override func viewDidLayoutSubviews() {
        registerScrollView.contentSize = CGSizeMake(320.00, 840.00)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mainScreenSegue" {
            let vc = segue.destinationViewController as! MainController
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true);
    }
}

extension RegistrationController : UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.countries.count
    }
}

extension RegistrationController : UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.countries[row]
    }
}

extension RegistrationController : ConnectionManagerDelegate {
    func connectionManagerDidRecieveObject(responseObject: AnyObject) {
        var responseDict = responseObject as! [String:AnyObject]
        var method = responseDict["M"] as! Int
        switch method {
        case 203:
            var errMsg = responseDict["MSG"] as! String
            let failAlert = UIAlertController(title: "Registration failed", message: errMsg, preferredStyle: UIAlertControllerStyle.Alert)
            failAlert.addAction(UIAlertAction(title: "Okay",
                style: UIAlertActionStyle.Default,
                handler: {(alert: UIAlertAction!) in println("-__-")}))
            self.presentViewController(failAlert, animated: true, completion: {
                
            })
        case 205:
            println("205 comes")
        case 206:
            let isConfirmed = responseDict["C"] as! Bool
            
            if isConfirmed {
                sendRegistration()
            } else {
                
            }
            println("206 comes")
        case 9999:
            let responseString = responseDict["C"] as! Int
            if responseString == 1 {
                performSegueWithIdentifier("mainScreenSegue", sender: self)
            } else if responseString == 0 {
                println("Handshake fail!")
            }
        default:
            println("Something strange happens")
        }
    }
}
