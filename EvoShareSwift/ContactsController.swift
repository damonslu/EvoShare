//
//  ContactsController.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 1/23/15.
//  Copyright (c) 2015 mtu. All rights reserved.
//

import Foundation
import UIKit

class ContactsController : UIViewController, ConnectionManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let iconImg = UIImage(named: "menu")
        let menuBtn = UIBarButtonItem(image: iconImg, style: UIBarButtonItemStyle.Plain, target: self, action: "toogle:")
        self.navigationItem.setRightBarButtonItem(menuBtn, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        //
    }
    
    func toogle(sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
}

extension ContactsController : ConnectionManagerDelegate {
    func connectionManagerDidRecieveObject(responseObject: AnyObject) {
        //
    }
}