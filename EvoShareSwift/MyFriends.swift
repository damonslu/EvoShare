//
//  MyFriends.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 1/23/15.
//  Copyright (c) 2015 mtu. All rights reserved.
//

import Foundation
import UIKit

class MyFriendsController : UIViewController, ConnectionManagerDelegate {
    
    @IBOutlet weak var friendsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.friendsTextView.text = self.friendsTextView.text + "\n"
        ConnectionManager.sharedInstance.delegate = self
        let iconImg = UIImage(named: "menu")
        let menuBtn = UIBarButtonItem(image: iconImg, style: UIBarButtonItemStyle.Plain, target: self, action: "toogle:")
        self.parentViewController?.navigationItem.setRightBarButtonItem(menuBtn, animated: true)
        self.requestFriends()
    }
    
    override func didReceiveMemoryWarning() {
        //
    }
    
    func requestFriends() {
        let locale = NSLocale.currentLocale()
        let countryCode = locale.objectForKey(NSLocaleCountryCode) as! String
        let promoListRequest = ["UID":EVOUidSingleton.sharedInstance.userID(),"LOC":countryCode, "DBG":true] as Dictionary<String,AnyObject>
        let params = ["RQS":promoListRequest, "M": 214] as Dictionary<String,AnyObject>
        
        var err: NSError?
        let finalJSONData = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: &err)
        let stringJSON : String = NSString(data: finalJSONData!, encoding: NSUTF8StringEncoding)!
        
        ConnectionManager.sharedInstance.socket.writeString(stringJSON)
    }
    
    func toogle(sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
}

extension MyFriendsController : ConnectionManagerDelegate {
    func connectionManagerDidRecieveObject(responseObject: AnyObject) {
        let friends : [[String:AnyObject]] = responseObject as! [[String:AnyObject]]
        for friend in friends {
            var friendName = friend["NM"] as! String
            self.friendsTextView.text = self.friendsTextView.text + friendName + "\n"
        }
    }
}