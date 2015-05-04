//
//  ActionDetailController.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 1/31/15.
//  Copyright (c) 2015 mtu. All rights reserved.
//

import Foundation
import UIKit

class ActionDetailViewController : UIViewController {
    
    @IBOutlet weak var needToCollect: UILabel!
    
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var collected: UILabel!
    
    @IBOutlet weak var peopleCount: UILabel!
    @IBOutlet weak var actionImg: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    var need : String?
    var desc : String?
    var people : String?
    var img : String?
    var gained : String?
    var actionID: Int?
    var imgCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.needToCollect.text = need
        self.collected.text = gained
        self.descriptionTextView.text = desc
        self.peopleCount.text = people
        let subViews = self.scroller.subviews
        self.revtrieveImages()
    }
    
    func revtrieveImages() {
        var index: Int
        var count : Int = (self.imgCount! - 1) / 2
        self.scroller.contentSize = CGSizeMake(CGFloat(count) * self.scroller.bounds.size.width, self.scroller.bounds.height)
        var newSize = self.scroller.bounds
        for index = 1; index <= count; ++index {
            var imgIndex = String(format: "&index=%d", index)
            var resultImgUrl = img! + imgIndex
            if index == 1 {
                let url = NSURL(string: resultImgUrl)
                var err: NSError?
                var imageData: NSData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!
                var relatedPromoImage = UIImage(data:imageData)
                var imgView = UIImageView(frame: newSize)
                imgView.image = relatedPromoImage
                self.scroller.addSubview(imgView)
            } else {
                newSize = CGRectOffset(newSize, self.scroller.bounds.size.width, 0)
                let url = NSURL(string: resultImgUrl)
                var err: NSError?
                var imageData: NSData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!
                var relatedPromoImage = UIImage(data:imageData)
                var imgView = UIImageView(frame: newSize)
                imgView.image = relatedPromoImage
                self.scroller.addSubview(imgView)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        //
    }
}