//
//  SideMenu.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 12/21/14.
//  Copyright (c) 2014 mtu. All rights reserved.
//

import Foundation
import UIKit

class SideMenuTableViewController : UITableViewController {
    var items = ["Main", "Where?", "My Money", "Profile","Technical Support","Contacts","About EvoShare", "Logout"]
    var menuImagesNames = ["img_main","img_where","img_mymoney","img_profile","img_support","img_contact","img_about","img_logout"]
    var selectedMenuItem : Int = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var somePath = NSIndexPath(forItem: 0, inSection: 0)
        self.tableView.selectRowAtIndexPath(somePath, animated: false, scrollPosition: UITableViewScrollPosition.None)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.registerClass(SideMenuCell.self, forCellReuseIdentifier: "sidemenucell")
        tableView.separatorStyle = .None
        tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0)
        tableView.backgroundColor = UIColor.clearColor()
        tableView.scrollsToTop = false
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
    }
//  MARK:TableView DataSource
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("evosidemenucell", forIndexPath: indexPath) as! SideMenuCell
        
        cell.titleImageView.image = UIImage(named: self.menuImagesNames[indexPath.row] as String)
        cell.titleLabel.text = items[indexPath.row]
        cell.backgroundColor = UIColor.clearColor()

            let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.2)
            cell.selectedBackgroundView = selectedBackgroundView
        return cell
    }
//  MARK:TableView Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("did select row: \(indexPath.row)")
        
        if (indexPath.row == selectedMenuItem) {
            return
        }
        selectedMenuItem = indexPath.row
        
        //Present new view controller
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
//        var destViewController : UIViewController
        switch (indexPath.row) {
        case 0:
            var destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("maincontroller") as! MainController
            sideMenuController()?.setContentViewController(destViewController)
            break
        case 1:
            var destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("shopscontroller") as! EVOShopsController
            sideMenuController()?.setContentViewController(destViewController)
            break
        case 2:
            var destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("cabinetcontroller") as! UITabBarController
            sideMenuController()?.setContentViewController(destViewController)
            break
        case 3:
            var destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("profilecontroller") as! ProfileController
            sideMenuController()?.setContentViewController(destViewController)
            break
        case 4:
//            var destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("supportcontroller") as! UIViewController
//            sideMenuController()?.setContentViewController(destViewController)
            break
        case 5:
            var destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("contactscontroller") as! ContactsController
            sideMenuController()?.setContentViewController(destViewController)
            break
        case 6:
            var destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("aboutcontroller") as! AboutUsController
            sideMenuController()?.setContentViewController(destViewController)
            break
        case 7:
            var destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("authcontroller") as! AuthorizationController
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            var somePath = NSIndexPath(forItem: 0, inSection: 0)
            self.tableView.selectRowAtIndexPath(somePath, animated: false, scrollPosition: UITableViewScrollPosition.None)
            sideMenuController()?.setContentViewController(destViewController)
            break
        default:
            break
        }
    }
    
//  MARK:TableView Properties
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}
