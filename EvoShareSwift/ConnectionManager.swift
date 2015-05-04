//
//  ConnectionManager.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 11/17/14.
//  Copyright (c) 2014 mtu. All rights reserved.
//

import Foundation
import Starscream

private let _connectionManager = ConnectionManager()

protocol ConnectionManagerDelegate {
    func connectionManagerDidRecieveObject(responseObject:AnyObject)
}

class ConnectionManager : NSObject, WebSocketDelegate {
    class var sharedInstance : ConnectionManager {
    return _connectionManager
    }
    
    var socket : WebSocket = WebSocket(url: NSURL(scheme: "ws", host: "wsdev.evo-share.com", path: "//Device.ashx?username=" + NSUUID().UUIDString)!)
    var delegate : ConnectionManagerDelegate?

    override init() {
        super.init()
        socket.delegate = self
//        socket.selfSignedSSL = true
    }
    
    func sendHandshakeWithToken(token: String) {
        var date = NSDate()
        let myDateString = String(Int64(date.timeIntervalSince1970*1000))
        println("Miliseconds = \(myDateString)")
        let dateString = "/Date(\(myDateString)+0000)/"
        
        let handshakeData = ["CTM":dateString,"UID":token] as Dictionary<String,AnyObject>
        let handshakeJSON = [ "RQS":handshakeData,"M":9999] as [String:AnyObject]
        
        var err : NSError?
        let handshakeJSONData = NSJSONSerialization.dataWithJSONObject(handshakeJSON, options:NSJSONWritingOptions.allZeros, error: &err)
        var datastring = NSString(data: handshakeJSONData!, encoding: NSUTF8StringEncoding)
        socket.writeString(datastring!)
    }
}

extension ConnectionManager : WebSocketDelegate {

    func websocketDidConnect() {
        //
    }
    func websocketDidDisconnect(error: NSError?) {
        println("Disconected")
    }
    func websocketDidReceiveData(data: NSData) {
        //
    }
    func websocketDidReceiveMessage(text: String) {
        let data: NSData = text.dataUsingEncoding(NSUTF8StringEncoding)!
        var err : NSError?
        let recievdJson = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &err) as! [String:AnyObject]
        let method = recievdJson["M"] as! Int
        
        switch method {
        case 8888:
            println("Service data")
        case 9999:
            delegate!.connectionManagerDidRecieveObject(recievdJson)
        case 200:
            let jsonContent : [String:AnyObject] = recievdJson["C"] as! [String:AnyObject]
            let token = jsonContent["TKN"] as! String
            if (!token.isEmpty) {
                EVOUidSingleton.sharedInstance.setUserID(token)
                sendHandshakeWithToken(token)
            }
            println("Login")
        case 203:
            let jsonContent : [String:AnyObject] = recievdJson["C"] as! [String:AnyObject]
            let error = recievdJson["S"] as! Int
            if (error == 0) {
                let token = jsonContent["TKN"] as! String
                if (!token.isEmpty) {
                    EVOUidSingleton.sharedInstance.setUserID(token)
                    sendHandshakeWithToken(token)
                }
            } else {
                delegate!.connectionManagerDidRecieveObject(recievdJson)
            }
            println("Registration")
        case 205:
            delegate!.connectionManagerDidRecieveObject(recievdJson)
            println("GetSMS")
        case 206:
            delegate!.connectionManagerDidRecieveObject(recievdJson)
            println("ConfirmSMS")
        case 210:
            let jsonContent = recievdJson["C"] as! [String:AnyObject]
            delegate!.connectionManagerDidRecieveObject(jsonContent)
            println("GetProfile")
        case 212:
            let jsonContent = recievdJson["C"] as! [[String:AnyObject]]
            delegate!.connectionManagerDidRecieveObject(jsonContent)
            println("GetVendors")
        case 213:
            let jsonContent = recievdJson["C"] as! [[String:AnyObject]]
            delegate!.connectionManagerDidRecieveObject(jsonContent)
            println("GetCategoryVendors")
        case 214:
            let jsonContent = recievdJson["C"] as! [[String:AnyObject]]
            delegate!.connectionManagerDidRecieveObject(jsonContent)
            println("GetAgents")
        case 215:
            let messages = recievdJson["C"] as! [[String:AnyObject]]
            delegate!.connectionManagerDidRecieveObject(messages)
            println("GetMessages")
        case 216:
            let jsonContent = recievdJson["C"] as! [String:AnyObject]
            delegate!.connectionManagerDidRecieveObject(jsonContent)
            println("MyMoney")
        case 218:
            let jsonContent = recievdJson["C"] as! [String:AnyObject]
            delegate!.connectionManagerDidRecieveObject(jsonContent)
            println("GetActiveCheck after scan")
        case 219:
            delegate!.connectionManagerDidRecieveObject(recievdJson)
            println("ConfirmCheckData confirm cash amount")
        case 221:
            let listOfPromos = recievdJson["C"] as! [[String:AnyObject]]
            delegate!.connectionManagerDidRecieveObject(listOfPromos)
            println("ActivePromos")
        case 222:
            delegate!.connectionManagerDidRecieveObject(recievdJson)
            println("GetConfirmCheck renew summ")
        case 223:
            delegate!.connectionManagerDidRecieveObject(recievdJson)
            println("RecoveryMethod")
        case 225:
            delegate!.connectionManagerDidRecieveObject(recievdJson)
            println("PayToFriend DONE")
        default:
            println("Something new")
        }
    }
    func websocketDidWriteError(error: NSError?) {
        //
    }
}

