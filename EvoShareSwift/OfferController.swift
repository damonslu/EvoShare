//
//  OfferController.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 1/16/15.
//  Copyright (c) 2015 mtu. All rights reserved.
//

import Foundation
import UIKit

class OfferController : UIViewController, ConnectionManagerDelegate {
    
    @IBOutlet weak var tottalPriceLabel: UILabel!
    
    @IBOutlet weak var currencyLabel: UILabel!
    var checkID: Int?
    var summ: String?
    var curr:  String?
    
    @IBAction func refusePayment(sender: UIButton) {
        responseWithBool(false)
        tottalPriceLabel.text = "0.00"
    }
    
    @IBAction func confirmPayment(sender: UIButton) {
        responseWithBool(true)
    }
    
    func popOut() {
//        let vc : MainController = self.storyboard?.instantiateViewControllerWithIdentifier("maincontroller") as MainController
//        self.navigationController?.popViewControllerAnimated(true)
        self.performSegueWithIdentifier("backInBlack", sender: self)
    }
    func responseWithBool(confirm:Bool) {
        let locale = NSLocale.currentLocale()
        let countryCode = locale.objectForKey(NSLocaleCountryCode) as! String
        
        var successResponse = ["UID":EVOUidSingleton.sharedInstance.userID(),
            "LOC":countryCode,
            "CID":self.checkID!,
            "ICM":confirm,
            "DBG":true] as Dictionary<String,AnyObject>
        var params = ["RQS":successResponse, "M": 219] as Dictionary<String,AnyObject>
        println("Foundation dictionary for JSON: \(params)")
        
        var err: NSError?
        let finalJSONData = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: &err)
        
        var stringJSON : String = NSString(data: finalJSONData!, encoding: NSUTF8StringEncoding)!
        
        ConnectionManager.sharedInstance.socket.writeString(stringJSON)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tottalPriceLabel.text = self.summ
        self.currencyLabel.text = curr
    }
    
    override func didReceiveMemoryWarning() {
        //
    }
}

extension OfferController : ConnectionManagerDelegate {
    func connectionManagerDidRecieveObject(responseObject: AnyObject) {
        let jsonContent = responseObject as! [String:AnyObject]
        let responseDict = jsonContent["C"] as [String:AnyObject]
        let method : Int = jsonContent["M"] as Int
        
        switch method {
        case 222:
            let price : Double = responseDict["SUM"] as Double
            var priceString : String = String(format: "%.2f", price)
            self.tottalPriceLabel.text = priceString
        case 219:
            let isFinished  = responseDict["IAP"] as Bool
            if isFinished {
                let failAlert = UIAlertController(title: "Offer status", message: "Offer success", preferredStyle: UIAlertControllerStyle.Alert)
                failAlert.addAction(UIAlertAction(title: "Okay",
                    style: UIAlertActionStyle.Default,
                    handler: {(alert: UIAlertAction!) in
                        self.popOut()
                }))
                self.presentViewController(failAlert, animated: true, completion: {
                    
                })
            } else {
                
            }
        default:
            println("asd")
        }
    }
}