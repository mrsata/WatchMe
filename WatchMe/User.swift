//
//  User.swift
//  WatchMe
//
//  Created by Labuser on 3/24/16.
//  Copyright © 2016 Grace. All rights reserved.
//

import UIKit


let currentUserKey = "kCurrentKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var dictionary: NSDictionary
    var name: String?
    var twitterHandle: String?
    var numCollection: Int?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["username"] as? String
    }

    func logout(){
        User.currentUser = nil
        //Client.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }

    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
        if _currentUser == nil {
        //logged out or just boot up
        let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        if data != nil {
        let dictionary: NSDictionary?
        do {
        try dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
        _currentUser = User(dictionary: dictionary!)
    } catch {
        print(error)
                    }
            }
        }
        return _currentUser
        
        }
        
        set(user) {
            _currentUser = user
            print(_currentUser)
            //User need to implement NSCoding; but, JSON also serialized by default
            if let _ = _currentUser {
                var data: NSData?
                do {
                    try data = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: .PrettyPrinted)
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                    NSUserDefaults.standardUserDefaults().synchronize()
                } catch {
                    print(error)
                }
            }
        }
    
    }
}
