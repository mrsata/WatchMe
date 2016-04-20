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
    
    var userMovieDictionary: [NSMutableDictionary] = []
    
    
    class var sharedInstance: Client {
        struct Static{
            static let instance = Client(baseURL: clientBaseUrl, clientID: clientKey, secret:
                clientSecret)
        }
        
        return Static.instance
    }
    
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(code: String){
        
        var parameters: [String: String] = ["code": code]
        parameters["client_id"] =  clientKey
        parameters["client_secret"] = clientSecret
        parameters["redirect_uri"] = "watchme://oauth"
        parameters["grant_type"] = "authorization_code"
        Client.sharedInstance.authenticateUsingOAuthWithURLString("https://api-v2launch.trakt.tv/oauth/token", parameters: parameters, success: { (token: AFOAuthCredential!) -> Void in
            //print("Was successful!")
            self.accessToken = token.accessToken
            self.loginSuccess!()
        }) { (error: NSError!) -> Void in
            print("Was not successful!")
            self.loginFailure!(error)
        }
        
    }
    
    func loginWithCallback(success: () -> (), failure: (NSError) -> ()){
        UIApplication.sharedApplication().openURL(NSURL(string: "https://api-v2launch.trakt.tv/oauth/authorize?response_type=code&client_id=\(clientKey)&redirect_uri=watchme://oauth")!)
        loginSuccess = success
        loginFailure = failure
    }
    
    func logout(success: ()->(), failure: (NSError) -> ())
    {
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestSerializer.setValue("2", forHTTPHeaderField: "trakt-api-version")
        requestSerializer.setValue(clientKey, forHTTPHeaderField: "trakt-api-key")
        requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        POST("https://api-v2launch.trakt.tv/oauth/revoke", parameters: nil, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            print("Successfully logged out")
            }) { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                print("did not log out")
        }
    }
    
    func search(query: String?, type: String?, year: Int?,success: ([Entertainment]) -> (), failure: (NSError) -> ()){
        
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
            
            //print("Got the search results!")
            let userDictionary = response as! [NSDictionary]
            
            let entertainments = Entertainment.toArray(userDictionary)
            success(entertainments)
        }) { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
            print("Did not get the search results")
        }
    }
    
    func addToCollection(entertainment: Entertainment,success: () -> (), failure: (NSError) -> ()){
        
                requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
                requestSerializer.setValue("2", forHTTPHeaderField: "trakt-api-version")
                requestSerializer.setValue(clientKey, forHTTPHeaderField: "trakt-api-key")
                requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
                let json: [String: AnyObject] = ["movies":["title": entertainment.title!,"year":entertainment.year!,"ids":entertainment.ids!]]
                //let jsonData = NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
                if(entertainment.type == "movie")
                {
                    POST("https://api-v2launch.trakt.tv/sync/collection", parameters: json, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
                        print("Successfully added to collection")
                        }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                            print("Did not add to collection")
                    })
                }

    }
    
    func getCollection(success: ([Entertainment]) -> (), failure: (NSError) -> ()){
        
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestSerializer.setValue("2", forHTTPHeaderField: "trakt-api-version")
        requestSerializer.setValue(clientKey, forHTTPHeaderField: "trakt-api-key")
        requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        GET("https://api-v2launch.trakt.tv/sync/collection/movies?extended=images,full", parameters: nil, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            
            //print("Got the collection!")
            let userDictionary = response as! [NSDictionary]
            
            success(Entertainment.toArray(userDictionary))
        }) { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
            print("Did not get the search results")
        }
        
    }
    
    func getMovieRecommendation(success: ([Recommendation]) -> (), failure: (NSError) -> ()){
        
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestSerializer.setValue("2", forHTTPHeaderField: "trakt-api-version")
        requestSerializer.setValue(clientKey, forHTTPHeaderField: "trakt-api-key")
        requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        GET("https://api-v2launch.trakt.tv/recommendations/movies?extended=images,full&limit=5", parameters: nil, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            
            //print("Got the movie recommendation!")
            self.userMovieDictionary = response as! [NSMutableDictionary]
            
            for i in 0 ..< self.userMovieDictionary.count
            {
                self.userMovieDictionary[i] = self.userMovieDictionary[i].mutableCopy() as! NSMutableDictionary
                self.userMovieDictionary[i].setValue("Movie", forKey: "type")
            }
            success(Recommendation.toArray(self.userMovieDictionary))
        }) { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
            print("Did not get the search results")
        }
    }
    
    func getSettings(success: (User) -> (), failure: (NSError) -> ()){
        
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestSerializer.setValue("2", forHTTPHeaderField: "trakt-api-version")
        requestSerializer.setValue(clientKey, forHTTPHeaderField: "trakt-api-key")
        requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        GET("https://api-v2launch.trakt.tv/users/settings", parameters: nil, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            //print("Got the user settings!")
            success(User.init(dictionary: response as! NSDictionary))
            
        }) { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
            print("Did not get user settings")
        }
        
    }
    
    func getStats(username: String, success: (NSDictionary) -> (), failure: (NSError) -> ()){
        
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestSerializer.setValue("2", forHTTPHeaderField: "trakt-api-version")
        requestSerializer.setValue(clientKey, forHTTPHeaderField: "trakt-api-key")
        requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        GET("https://api-v2launch.trakt.tv/users/\(username)/stats", parameters: nil, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            //print("Got the stats!")
            success(response as! NSDictionary)
        }) { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
            print("Did not get stats")
        }
    }
    
    func getTrendingMovies(success: ([Entertainment]) -> (), failure: (NSError) -> ()){
        
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestSerializer.setValue("2", forHTTPHeaderField: "trakt-api-version")
        requestSerializer.setValue(clientKey, forHTTPHeaderField: "trakt-api-key")
        requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        GET("https://api-v2launch.trakt.tv/movies/trending?extended=images,full&limit=30", parameters: nil, success: {
            (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            //print("Succeed in getting trending movies")
            let userDictionary = response as! [NSDictionary]
            let trendingMovies = Entertainment.toArray(userDictionary)
            success(trendingMovies)
        }) { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
            print("Failed getting trending movies")
        }
        
    }

    func getTrendingShows(success: ([Entertainment]) -> (), failure: (NSError) -> ()){
        
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestSerializer.setValue("2", forHTTPHeaderField: "trakt-api-version")
        requestSerializer.setValue(clientKey, forHTTPHeaderField: "trakt-api-key")
        requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        GET("https://api-v2launch.trakt.tv/shows/trending?extended=images,full&limit=30", parameters: nil, success: {
            (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            //print("Succeed in getting trending shows")
            let userDictionary = response as! [NSDictionary]
            let trendingShows = Entertainment.toArray(userDictionary)
            success(trendingShows)
        }) { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
            print("Failed getting trending shows")
        }
        
    }
    
    func getNextEpisode(success: () -> (), failure: (NSError) ->()){
        
        GET("https://api-v2launch.trakt.tv/shows/game-of-thrones/progress/collection?hidden=false&specials=false", parameters: nil, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            //print("Got the next episode!")
        }) { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
            print("Did not get the next episode")
        }
    }
    
    func getMovieSummary(id: String, success: (NSDictionary) -> (), failure: (NSError) -> ()){
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestSerializer.setValue("2", forHTTPHeaderField: "trakt-api-version")
        requestSerializer.setValue(clientKey, forHTTPHeaderField: "trakt-api-key")
        requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        GET("https://api-v2launch.trakt.tv/movies/\(id)?extended=images,full", parameters: nil, success: {
            (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            print("Got the summary!")
            let userDictionary = response as! NSDictionary
            //let summary = Entertainment.toArray(userDictionary)
            success(userDictionary)
            }) { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                print("Didn't get the shows")
        }

    }
    
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

