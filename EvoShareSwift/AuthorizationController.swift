//
//  ViewController.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 10/23/14.
//  Copyright (c) 2014 mtu. All rights reserved.
//

import UIKit

class AuthorizationController: UIViewController, NSURLConnectionDelegate, ConnectionManagerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, EVOCountryDelegate {
    
    // MARK: Properties
    @IBOutlet weak var logo: UIImageView!

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var phoneTextFiled: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var fbAuthButton: UIButton!
    @IBOutlet weak var vkAuthButton: UIButton!
    
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    @IBOutlet weak var demoButton: UIButton!

    @IBOutlet weak var pickCountry: UIButton!
    let uuid = NSUUID()
    // MARK: Actions
    @IBAction func enter(sender: UIButton) {
        
        if (count(phoneTextFiled.text) >= 8 && !passwordTextField.text.isEmpty) {
            var codeString = self.pickCountry.titleLabel!.text!

            var phoneString = self.phoneTextFiled.text
            let locale = NSLocale.currentLocale()
            let countryCode = locale.objectForKey(NSLocaleCountryCode) as! String
            
            let loginData = ["LCL":countryCode,
                "LGN":NSUUID().UUIDString,
                "PAS":passwordTextField.text,
                "PHN":phoneString,
                "PHC":codeString,
                "PID":uuid.UUIDString,
                "LAT":0.0,
                "LON":0.0,
                "OS":2,
                "DBG":true] as Dictionary <String,AnyObject>
            
            println("Register data:\(loginData)")
            
            var params = ["RQS":loginData, "M": 200] as Dictionary<String,AnyObject>
            println("Foundation dictionary for JSON: \(params)")
            
            var err: NSError?
            let finalJSONData = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: &err)
            
            var stringJSON : String = NSString(data: finalJSONData!, encoding: NSUTF8StringEncoding)!
            println("JSON String: \(stringJSON)")
            
            ConnectionManager.sharedInstance.socket.writeString(stringJSON)
        } else {
            let failAlert = UIAlertController(title: "Authorization failed", message: "Number or Password are incorrect", preferredStyle: UIAlertControllerStyle.Alert)
            failAlert.addAction(UIAlertAction(title: "Okay",
                style: UIAlertActionStyle.Default,
                handler: {(alert: UIAlertAction!) in println("-__-")}))
            self.presentViewController(failAlert, animated: true, completion: {
                
            })
        }
    }
    
    
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        
        phoneTextFiled.delegate = self
        passwordTextField.delegate = self
        ConnectionManager.sharedInstance.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationItem.leftBarButtonItem = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mainScreenSegueLogin" {
            let vc = segue.destinationViewController as! MainController
            ConnectionManager.sharedInstance.delegate = vc
        } else if segue.identifier == "registration" {
            let vc = segue.destinationViewController as! RegistrationController
            ConnectionManager.sharedInstance.delegate = vc
        } else if segue.identifier == "showcountries" {
            let vc = segue.destinationViewController as! EVOCountryTableViewController
            vc.delegate = self
            let path = NSBundle.mainBundle().pathForResource("countries", ofType: "json")
            
            var err : NSError?
            var data = NSData(contentsOfFile: path!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
            
            let json = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &err) as! [[String:AnyObject]]
            vc.countries = json
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}

extension AuthorizationController : ConnectionManagerDelegate {
    func connectionManagerDidRecieveObject(responseObject: AnyObject) {
        var responseDict = responseObject as! [String:AnyObject]
        var method = responseDict["M"] as! Int
        switch method {
        case 9999:
            let handshakeResponse = responseDict["C"] as! Int
            if handshakeResponse == 1 {
                performSegueWithIdentifier("mainScreenSegueLogin", sender: self)
            } else if handshakeResponse == 0 {
                println("Handshake fail!")
                let failAlert = UIAlertController(title: "Authorization failed", message: "Number or Password are incorrect", preferredStyle: UIAlertControllerStyle.Alert)
                failAlert.addAction(UIAlertAction(title: "Okay",
                    style: UIAlertActionStyle.Default,
                    handler: {(alert: UIAlertAction!) in println("-__-")}))
                self.presentViewController(failAlert, animated: true, completion: {
                    
                })
            }
        default:
            println("What is this?")
        }
    }
}

extension AuthorizationController : EVOCountryDelegate {
    func didPickCountry(country: [String : AnyObject]) {
        let code = country["dial_code"] as! String
        let flagCode = country["code"] as! String
        let img = UIImage(named: flagCode)
        self.pickCountry.setTitle(code, forState: UIControlState.Normal)
        self.pickCountry.setImage(img, forState: UIControlState.Normal)
    }
}

