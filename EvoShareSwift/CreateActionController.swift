//
//  CreateActionController.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 1/31/15.
//  Copyright (c) 2015 mtu. All rights reserved.
//

import Foundation
import UIKit

class CreateActionController : UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var scrollVIew: UIScrollView!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var tottalField: UITextField!
    @IBOutlet weak var actionPhoto: UIImageView!
    @IBOutlet weak var pasportScanPreview: UIImageView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var passportNumberField: UITextField!
    @IBOutlet weak var detailsField: UILabel!
    var mediaUI = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollVIew.contentSize = CGSizeMake(320.00, 800.00)
        self.mediaUI.delegate = self
    }
    override func didReceiveMemoryWarning() {
        //
    }
    override func viewDidLayoutSubviews() {
        
    }
    
    @IBAction func uploadPhoto(sender: UIButton) {
        self.mediaUI.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        var str : String = "Charity Image"
        self.mediaUI.navigationItem.title = str
        self.presentViewController(self.mediaUI, animated: true) {
        }
    }
    @IBAction func uploadScan(sender: UIButton) {
        self.mediaUI.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        var str : String = "ID Scan"
        self.mediaUI.navigationItem.title = str
        self.presentViewController(self.mediaUI, animated: true) {
        }
    }
    
}

extension CreateActionController : UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var tempImage:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        if picker.navigationItem.title == "Charity Image" {
            self.actionPhoto.image = tempImage
            self.dismissViewControllerAnimated(true) {
            }

        } else if picker.navigationItem.title == "ID Scan"  {
            self.pasportScanPreview.image = tempImage
            self.dismissViewControllerAnimated(true) {
            }
        }
    }
}
