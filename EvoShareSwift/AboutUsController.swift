//
//  AboutUsController.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 12/21/14.
//  Copyright (c) 2014 mtu. All rights reserved.
//

import Foundation
import UIKit

class AboutUsController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let iconImg = UIImage(named: "menu")
        let menuBtn = UIBarButtonItem(image: iconImg, style: UIBarButtonItemStyle.Plain, target: self, action: "toogle:")
        self.navigationItem.setRightBarButtonItem(menuBtn, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        //
    }
    
    func toogle(sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
}
