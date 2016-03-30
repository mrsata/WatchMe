//
//  Client.swift
//  WatchMe
//
//  Created by Labuser on 3/22/16.
//  Copyright © 2016 Grace. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let clientKey = "aa88988e98c9f1c01ee9b2b2a85fb7744894d9ce0bf931dcc4bbdb5fb3b73694"
let clientSecret = "4c35bf1e4314f917b074ff720f3424cb49916bacce6df3695c92ee990c56fc9c"
let clientBaseUrl = NSURL(string: "https://api-v2launch.trakt.tv")


class Client: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?)-> ())?
    
    class var sharedInstance: Client {
        struct Static{
            static let instance = Client(baseURL: clientBaseUrl, consumerKey: clientKey, consumerSecret:
                clientSecret)
        }
        
        return Static.instance
    }
    
    
    func loginWithCompletion(completion: (user: User?, error: NSError?)-> ()) {
        loginCompletion = completion
        
        // Fetch request token and redirect to authorization page
        
        Client.sharedInstance.requestSerializer.removeAccessToken()
        Client.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:"trakt://oauth"), scope: nil, success: {( requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            let authURL = NSURL(string: "http://docs.trakt.apiary.io/#reference/authentication-oauth/authorize\(requestToken.token)")
            
            
            UIApplication.sharedApplication().openURL(authURL!)
            }) {(error: NSError!) -> Void in
                print("Gailed to get request token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    
}
