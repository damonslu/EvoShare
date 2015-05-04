//
//  EVOCountryTableViewController.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 3/2/15.
//  Copyright (c) 2015 mtu. All rights reserved.
//

import Foundation
import UIKit

protocol EVOCountryDelegate {
    func didPickCountry(country:[String:AnyObject])
}

class EVOCountryTableViewController: UITableViewController {
    var delegate : EVOCountryDelegate?
    var countries : [[String:AnyObject]]?
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("countrycell") as! CountryCell
        if (self.countries != nil) {
            let country = self.countries![indexPath.row] as [String:AnyObject]
            let ename = country["name"] as? String
            let ecode = country["dial_code"] as? String
            let eimg = country["code"] as? String
            cell.name.text = ename
            cell.code.text = ecode
            cell.flag.image = UIImage(named: eimg!)
        }
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let country = self.countries![indexPath.row] as [String:AnyObject]
        self.delegate!.didPickCountry(country)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
}