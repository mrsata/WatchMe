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
        super.init()
        
        let user = dictionary["user"] as! NSDictionary
        name = user["username"] as? String
    }

    func logout(){
        User.currentUser = nil
        //Client.sharedInstance.requestSerializer.removeAccessToken()
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: userDidLogoutNotification), object: nil)
    }

    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
        if _currentUser == nil {
        //logged out or just boot up
        let data = UserDefaults.standard.object(forKey: currentUserKey) as? Data
        if data != nil {
        let dictionary: NSDictionary?
        do {
        try dictionary = JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
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
            print(_currentUser ?? "no current user")
            //User need to implement NSCoding; but, JSON also serialized by default
            if let _ = _currentUser {
                var data: Data?
                do {
                    try data = JSONSerialization.data(withJSONObject: user!.dictionary, options: .prettyPrinted)
                    UserDefaults.standard.set(data, forKey: currentUserKey)
                    UserDefaults.standard.synchronize()
                } catch {
                    print(error)
                }
            }
        }
    
    }
}
