//
//  EvoNavigationController.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 12/21/14.
//  Copyright (c) 2014 mtu. All rights reserved.
//

import Foundation
import UIKit

class EvoNavigationController : ENSideMenuNavigationController, ENSideMenuDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        let sideMenuController = storyboard?.instantiateViewControllerWithIdentifier("evosidemenu") as! SideMenuTableViewController
        sideMenu = ENSideMenu(sourceView: self.view, menuTableViewController:sideMenuController, menuPosition: .Right)
        sideMenu?.delegate = self //optional
        sideMenu?.menuWidth = 220.0 // optional, default is 160
        sideMenu?.bouncingEnabled = false
        //sideMenu?.bouncingEnabled = false
        // make navigation bar showing over side menu)
        view.bringSubviewToFront(navigationBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - ENSideMenu Delegate
}
extension EvoNavigationController : ENSideMenuDelegate {
    func sideMenuWillClose() {
        //
    }
    func sideMenuWillOpen() {
        //
    }
}