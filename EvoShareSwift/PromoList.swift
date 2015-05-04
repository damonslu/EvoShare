//
//  PromoList.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 12/23/14.
//  Copyright (c) 2014 mtu. All rights reserved.
//

import Foundation
import UIKit

struct PromoListDataSourceInfo {
    static let reuseIdentifier: String = "promolistcell"
    static let rowheight: CGFloat = 265.0
}

class ListOfPromosTableViewController : UITableViewController, ConnectionManagerDelegate {
    var listOfPromosJSON: [[String:AnyObject]]?
    
    override func viewDidLoad() {
//
    }
    
    override func didReceiveMemoryWarning() {
        //
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "charityDetailSegue" {
            let destinationViewController = segue.destinationViewController as! ActionDetailViewController
            
            let relatedPromo = listOfPromosJSON![self.tableView.indexPathForSelectedRow()!.row]
            let promoTitle = relatedPromo["TIT"] as! String
            let promoText = relatedPromo["DTL"] as! String
            let imgURLString = relatedPromo["IMG"] as! String
            let needToCollect = relatedPromo["SND"] as! Double
            let collected = relatedPromo["SET"] as! Double
            let peoples = relatedPromo["CUS"] as! Int
            let countImg = relatedPromo["IMS"] as! Int
            
            let needToCollectString = String(format: "%.0f", needToCollect)
            let peoplesString = String(format: "%d", peoples)
            let collectedString = String(format: "%.0f", collected)
            
            destinationViewController.need = needToCollectString
            destinationViewController.people = peoplesString
            destinationViewController.gained = collectedString
            destinationViewController.img = imgURLString
            destinationViewController.desc = promoText
            destinationViewController.imgCount = countImg
            destinationViewController.actionID = self.tableView.indexPathForSelectedRow()!.row
        }
    }
    //  MARK:TableView DataSource
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: PromoCell! = tableView.dequeueReusableCellWithIdentifier(PromoListDataSourceInfo.reuseIdentifier, forIndexPath: indexPath) as! PromoCell
        let relatedPromo = listOfPromosJSON![indexPath.row]
        let imgURLString = relatedPromo["IMG"] as! String
        let promoTitle = relatedPromo["TIT"] as! String
        let promoText = relatedPromo["DTL"] as! String
        
        let url = NSURL(string: imgURLString)
        var err: NSError?
        let imageData: NSData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMapped, error: &err)!
        let relatedPromoImage = UIImage(data:imageData)
        
        cell.promoImage.image = relatedPromoImage
        cell.promoName.text = promoTitle
        cell.promoDesc.text = promoText
        return cell
    }
    //  MARK:TableView Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("did select row: \(indexPath.row)")
    }
    
    //  MARK:TableView Properties
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfPromosJSON!.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return PromoListDataSourceInfo.rowheight
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
}
// MARK:ConnectionManagerDelegate
extension ListOfPromosTableViewController : ConnectionManagerDelegate {
    func connectionManagerDidRecieveObject(responseObject: AnyObject) {
        //
    }}
