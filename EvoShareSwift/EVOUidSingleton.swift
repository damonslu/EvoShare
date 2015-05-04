//
//  EVOUidSingleton.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 11/5/14.
//  Copyright (c) 2014 mtu. All rights reserved.
//

import Foundation

private let _SingletonSharedInstance = EVOUidSingleton()

var _userUID : String?
var _logedString : String?
var _userCode : String?
var _promoUID : String?
var _countryISO : String?
var _pushToken : String?
var _lastMoneyCount : NSNumber?
var _latitude : Float?
var _longitude : Float?

class EVOUidSingleton  {
        class var sharedInstance : EVOUidSingleton {
        return _SingletonSharedInstance
        }
    

    func setUserID(userUID : String) {
        _userUID = userUID
        NSUserDefaults.standardUserDefaults().setObject(userUID, forKey:"userUID")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func setUserCode(userCode : String) {
        _userCode = userCode
        NSUserDefaults.standardUserDefaults().setObject(userCode, forKey:"userCode")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func setCountryISO(countryISO : String) {
        _countryISO = countryISO
        NSUserDefaults.standardUserDefaults().setObject(countryISO, forKey:"countryISO")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func setPushToken(pushToken : String) {
        _countryISO = pushToken
        NSUserDefaults.standardUserDefaults().setObject(pushToken, forKey:"pushToken")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    

    func setLogedString(logedString : String) {
        _logedString = logedString
        NSUserDefaults.standardUserDefaults().setObject(logedString, forKey:"logedString")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func setLastMoneyCount(lastMoneyCount : NSNumber) {
        _lastMoneyCount = lastMoneyCount
        NSUserDefaults.standardUserDefaults().setObject(lastMoneyCount, forKey:"lastMoneyCount")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func logedString () -> String {
        if (_logedString != nil) {
            return NSUserDefaults.standardUserDefaults().stringForKey("logedString")!
        } else {
            return _logedString!;
        }

    }
    
    func userID() -> String {
        if (_userUID != nil) {
            return NSUserDefaults.standardUserDefaults().stringForKey("userUID")!
        } else {
            return _userUID!
        }
    }
}


//    - (NSString *)logedString {
//    if (!_logedString) {
//    return [[NSUserDefaults standardUserDefaults] objectForKey:@"logedString"];
//    } else {
//    return _logedString;
//    }
//    }
//    
//    - (NSNumber *)lastMoneyCount {
//    if (!_lastMoneyCount) {
//    NSNumber *lastCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastMoneyCount"];
//    if (lastCount) {
//    return lastCount;
//    } else {
//    return @(0);
//    }
//    } else {
//    return _lastMoneyCount;
//    }
//    }
//    
//    - (NSString *)userUID {
//    if (!_userUID) {
//    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"];
//    } else {
//    return _userUID;
//    }
//    }
//    
//    - (NSString *)userCode {
//    if (!_userCode) {
//    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userCode"];
//    } else {
//    return _userCode;
//    }
//    }
//    
//    - (NSString *)countryISO {
//    if (!_countryISO) {
//    return [[NSUserDefaults standardUserDefaults] objectForKey:@"countryISO"];
//    } else {
//    return _countryISO;
//    }
//    }
//    
//    - (NSString *)pushToken {
//    if (!_pushToken) {
//    return [[NSUserDefaults standardUserDefaults] objectForKey:@"pushToken"];
//    } else {
//    return _pushToken;
//    }
//    }
//    
//    - (NSString *)QRCodeString {
//    return [NSString stringWithFormat:@"%@|%@", self.userUID, self.promoUID];
//    }
//
//}
