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
    
    var accessToken: String!
    
    class var sharedInstance: Client {
        struct Static{
            static let instance = Client(baseURL: clientBaseUrl, clientID: clientKey, secret:
                clientSecret)
        }
        
        return Static.instance
    }
    
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(pin: String, success: () -> (), failure: (NSError) -> ())
    {
        loginSuccess = success
        loginFailure = failure
       
        var parameters: [String: String] = ["code": pin]
        parameters["client_id"] =  clientKey
        parameters["client_secret"] = clientSecret
        parameters["redirect_uri"] = "urn:ietf:wg:oauth:2.0:oob"
        parameters["grant_type"] = "authorization_code"
        Client.sharedInstance.authenticateUsingOAuthWithURLString("https://api-v2launch.trakt.tv/oauth/token", parameters: parameters, success: { (token: AFOAuthCredential!) -> Void in
            print("Was successful")
            self.accessToken = token.accessToken
            }) { (error: NSError!) -> Void in
                print("Was not successful")
        }

    }
    
    func search(query: String?, type: String?, year: Int?,success: ([Entertainment]) -> (), failure: (NSError) -> ())
    {
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestSerializer.setValue("2", forHTTPHeaderField: "trakt-api-version")
        requestSerializer.setValue(clientKey, forHTTPHeaderField: "trakt-api-key")

        var parameters: [String: AnyObject] = ["query": query!]
        if type != nil
        {
            parameters["type"] = type
        }
        if year != nil
        {
            parameters["year"] = year
        }
        GET("https://api-v2launch.trakt.tv/search?type=movie,show", parameters: parameters, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            
            print("Got the search results!")
            let userDictionary = response as! [NSDictionary]
            
            let entertainments = Entertainment.toArray(userDictionary)
            success(entertainments)
            }) { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                print("Did not get the search results")
        }
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

