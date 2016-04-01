//
//  Client.swift
//  WatchMe
//
//  Created by Labuser on 3/31/16.
//  Copyright © 2016 Grace. All rights reserved.
//

import UIKit
import AFOAuth2Manager

let clientKey = "aa88988e98c9f1c01ee9b2b2a85fb7744894d9ce0bf931dcc4bbdb5fb3b73694"
let clientSecret = "4c35bf1e4314f917b074ff720f3424cb49916bacce6df3695c92ee990c56fc9c"
let clientBaseUrl = NSURL(string: "https://api-v2launch.trakt.tv")

class Client: AFOAuth2Manager {
    class var sharedInstance: Client {
        struct Static{
            static let instance = Client(baseURL: clientBaseUrl, clientID: clientKey, secret:
                clientSecret)
        }
        
        return Static.instance
    }
    
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ())
    {
        loginSuccess = success
        loginFailure = failure
        Client.sharedInstance.authenticateUsingOAuthWithURLString("https://trakt.tv/oauth/authorize", code: "code", redirectURI: "urn:ietf:wg:oauth:2.0:oob", success: { (requestToken: AFOAuthCredential!)
            -> Void in
            print("Got the request token")
            }) { (error: NSError!) -> Void in
                print("Failed to get request token")
        }
//        TwitterClient.sharedInstance.deauthorize()
//        
//        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "mytwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
//            print("Got the request token!")
//            
//            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
//            UIApplication.sharedApplication().openURL(authURL!)
//            
//            }) { (error: NSError!) -> Void in
//                print("Failed to get request token")
//                self.loginFailure?(error)
//        }
//        
    }
//
//    func logout()
//    {
//        User.currentUser = nil
//        deauthorize()
//        
//        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
//    }
//    
//    func handleOpenUrl(url: NSURL)
//    {
//        let requestToken = BDBOAuth1Credential(queryString: url.query)
//        
//        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
//            print("Received access token!")
//            
//            self.currentAccount({ (user: User) -> () in
//                User.currentUser = user
//                self.loginSuccess?()
//                }, failure: { (error: NSError) -> () in
//                    self.loginFailure?(error)
//            })
//            
//            }) { (error: NSError!) -> Void in
//                print("Failed to receive access token")
//                self.loginFailure?(error)
//        }
//        
//    }


}

