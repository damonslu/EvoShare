//
//  DemoController.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 2/3/15.
//  Copyright (c) 2015 mtu. All rights reserved.
//

import Foundation
import UIKit

class DemoController : UIViewController {
    @IBOutlet weak var demoImage: UIImageView!
    @IBOutlet weak var demoPageControl: UIPageControl!
    var images : [String] = ["slide1.png","slide2.png"]
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(self.demoPageControl)
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(leftSwipe)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Left:
                if (self.demoPageControl.currentPage != self.demoPageControl.numberOfPages) {
                    self.demoPageControl.currentPage = self.demoPageControl.currentPage + 1
                    self.demoImage.image = UIImage(named: images[self.demoPageControl.currentPage])
                }
                               println("Swipe Left")
            case UISwipeGestureRecognizerDirection.Right:
                if (self.demoPageControl.currentPage != 0) {
                    self.demoPageControl.currentPage = self.demoPageControl.currentPage - 1
                    self.demoImage.image = UIImage(named: images[self.demoPageControl.currentPage])
                }

                println("Swiped Right")
            default:
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        //
    }
    @IBAction func pageChanged(sender: AnyObject) {

    }
}