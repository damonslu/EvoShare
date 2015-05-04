//
//  QRCodeController.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 12/24/14.
//  Copyright (c) 2014 mtu. All rights reserved.
//

import Foundation
import UIKit

class QRCodeController : UIViewController, ConnectionManagerDelegate {
    @IBOutlet weak var qrimage: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIImageView!
    
    var promoGuid : String?
    var checkID : Int = 0
    var summ : Double = 0
    var currency : String?
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.rotateLayerInfinity(self.activityIndicator.layer)
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.activityIndicator.layer.removeAllAnimations()
    }
    
    override func viewDidLoad() {
        let imgURLString = "http://service.evo-share.com/image.ashx?i=qr&t=\(EVOUidSingleton.sharedInstance.userID())|\(promoGuid)"
        let awesomeURL = imgURLString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let url = NSURL(string: awesomeURL!)
        var err: NSError?
        var imageData: NSData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMapped, error: &err)!
        var relatedPromoImage = UIImage(data:imageData)
        qrimage.image = relatedPromoImage
    }
    
    override func didReceiveMemoryWarning() {
        //
    }
    
    func rotateLayerInfinity(layer:CALayer) {
        var rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = NSNumber(float: 0)
        rotation.toValue = NSNumber(floatLiteral: 2*M_PI)
        rotation.duration = 1.1
        rotation.repeatCount = HUGE
        layer.removeAllAnimations()
        layer.addAnimation(rotation, forKey: "Spin")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "offerSegue" {
            var confirmControlelr = segue.destinationViewController as! OfferController
            ConnectionManager.sharedInstance.delegate = confirmControlelr
            var price : String = String(format: "%.2f", summ)
            confirmControlelr.summ = price
            confirmControlelr.curr = currency
            confirmControlelr.checkID = checkID
        }
    }
    
}

extension QRCodeController : ConnectionManagerDelegate {
    func connectionManagerDidRecieveObject(responseObject: AnyObject) {
        activityIndicator.layer.removeAllAnimations()
        let responseDict = responseObject as! Dictionary<String,AnyObject>

        summ = responseDict["SUM"] as! Double
        currency = responseDict["CUR"] as? String
        checkID = responseDict["CID"] as! Int
        
        performSegueWithIdentifier("offerSegue", sender: self)
    }
}