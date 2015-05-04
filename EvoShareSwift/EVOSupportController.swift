//
//  EVOSupportController.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 1/23/15.
//  Copyright (c) 2015 mtu. All rights reserved.
//

import Foundation
import UIKit

class EVOSupportController : LGChatController,LGChatControllerDelegate, ConnectionManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        ConnectionManager.sharedInstance.delegate = self
        let helloWorld = LGChatMessage(content: "Wellcome to support, how can i help you?", sentBy: .Opponent)
        self.messages = [helloWorld]
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
    
    // MARK: LGChatControllerDelegate
    
    func chatController(chatController: LGChatController, didAddNewMessage message: LGChatMessage) {
        println("Did Add Message: \(message.content)")
    }
    
    func shouldChatController(chatController: LGChatController, addMessage message: LGChatMessage) -> Bool {
        
        if message.sentBy == .Opponent {
            return true
        } else if message.sentBy == .User {
            let userMsg = ["UID":EVOUidSingleton.sharedInstance.userID(),"TXT":message.content, "IHS":false] as Dictionary<String,AnyObject>
            let params = ["RQS":userMsg, "M": 215] as Dictionary<String,AnyObject>
            
            var err: NSError?
            let finalJSONData = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: &err)
            let stringJSON : String = NSString(data: finalJSONData!, encoding: NSUTF8StringEncoding)!
            
            ConnectionManager.sharedInstance.socket.writeString(stringJSON)
            return true
        }
        /*
        Use this space to prevent sending a message, or to alter a message.  For example, you might want to hold a message until its successfully uploaded to a server.
        */
        return true
    }
}

extension EVOSupportController : ConnectionManagerDelegate {
    func connectionManagerDidRecieveObject(responseObject: AnyObject) {
        let messagesArray = responseObject as [[String:AnyObject]]
        for message in messagesArray {
            var content = message["TXT"] as String
            let msg = LGChatMessage(content: content, sentBy: .Opponent)
            self.addNewMessage(msg)
        }
    }
}