//
//  MainController.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 11/2/14.
//  Copyright (c) 2014 mtu. All rights reserved.
//

import Foundation
import UIKit

enum imageMask: Int {
    case One = 1
    case Two = 3
    case Three = 7
}

class MainController : UIViewController, ConnectionManagerDelegate {
    
    @IBOutlet weak var slideView: UIScrollView!
    @IBOutlet weak var collectedLabel: UILabel!
    
    @IBOutlet weak var charityName: UILabel!
    @IBOutlet weak var peopleLabel: UILabel!
    
    @IBOutlet weak var needToCollectLabel: UILabel!
    
    var listOfPromos:[Dictionary<String, AnyObject>]?
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConnectionManager.sharedInstance.delegate = self
        //Request List of Promos
        let locale = NSLocale.currentLocale()
        let countryCode = locale.objectForKey(NSLocaleCountryCode) as! String
        let promoListRequest = ["UID":EVOUidSingleton.sharedInstance.userID(),"LOC":countryCode, "DBG":true] as Dictionary<String,AnyObject>
        let params = ["RQS":promoListRequest, "M": 221] as Dictionary<String,AnyObject>
        
        var err: NSError?
        let finalJSONData = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: &err)
        let stringJSON : String = NSString(data: finalJSONData!, encoding: NSUTF8StringEncoding)!

        ConnectionManager.sharedInstance.socket.writeString(stringJSON)
    }
    
    func setupCharityWithIndex(ind:Int) {
        let relatedPromo = listOfPromos![ind]
        let promoName = relatedPromo["TIT"] as! String
        let imgURLString = relatedPromo["IMG"] as! String
        let needToCollect = relatedPromo["SND"] as! Double
        let peoples = relatedPromo["CUS"] as! Int
        let collected = relatedPromo["SET"] as! Double
        let imgCount = relatedPromo["IMS"] as! Int
        
        let needToCollectString = String(format: "%.0f", needToCollect)
        let peoplesString = String(format: "%d", peoples)
        let collectedString = String(format: "%.0f", collected)
        
        var index: Int
        var count : Int = (imgCount - 1) / 2
        self.slideView.contentSize = CGSizeMake(CGFloat(count) * self.slideView.bounds.size.width, self.slideView.bounds.height)
        var newSize = self.slideView.bounds
        for index = 1; index <= count; ++index {
            var imgIndex = String(format: "&index=%d", index)
            var resultImgUrl = imgURLString + imgIndex
            if index == 1 {
                let url = NSURL(string: resultImgUrl)
                var err: NSError?
                var imageData: NSData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!
                var relatedPromoImage = UIImage(data:imageData)
                var imgView = UIImageView(frame: newSize)
                imgView.image = relatedPromoImage
                self.slideView.addSubview(imgView)
            } else {
                newSize = CGRectOffset(newSize, self.slideView.bounds.size.width, 0)
                let url = NSURL(string: resultImgUrl)
                var err: NSError?
                var imageData: NSData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!
                var relatedPromoImage = UIImage(data:imageData)
                var imgView = UIImageView(frame: newSize)
                imgView.image = relatedPromoImage
                self.slideView.addSubview(imgView)
            }
        }
        self.needToCollectLabel.text = needToCollectString
        self.collectedLabel.text = collectedString
        self.peopleLabel.text = peoplesString
        self.charityName.text = promoName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func toggleMenu(sender: AnyObject) {
        toggleSideMenuView()
    }

    @IBAction func unwindToMainMenu(sender: UIStoryboardSegue)
    {
        if sender.identifier == "details" {
            let sourceViewController = sender.sourceViewController as! ActionDetailViewController
            let selectedCharityIndex = sourceViewController.actionID!
            self.setupCharityWithIndex(selectedCharityIndex)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "qrSegue" {
            let vc = segue.destinationViewController as! QRCodeController
            ConnectionManager.sharedInstance.delegate = vc
            
            let relatedPromo = listOfPromos![0]
            let guid = relatedPromo["UID"] as! String
            vc.promoGuid = guid
        } else if segue.identifier == "promolist" {
            let vc = segue.destinationViewController as! ListOfPromosTableViewController
            ConnectionManager.sharedInstance.delegate = vc
            
            vc.listOfPromosJSON = listOfPromos!
        }
    }
}

extension MainController : ConnectionManagerDelegate {
    func connectionManagerDidRecieveObject(responseObject: AnyObject) {
        let responseArray = responseObject as! [Dictionary<String,AnyObject>]
        if !responseArray.isEmpty {
            listOfPromos = responseArray
            self.setupCharityWithIndex(0)
        }
    }
}
