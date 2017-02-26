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
let clientBaseUrl = URL(string: "https://api-v2launch.trakt.tv")

class Client: AFOAuth2Manager {
    
    var accessToken: String!
    var userMovieDictionary: [NSMutableDictionary] = []
    var userShowDictionary: [NSMutableDictionary] = []
    
    class var sharedInstance: Client {
        struct Static{
            static let instance = Client(baseURL: clientBaseUrl!, clientID: clientKey, secret:
                clientSecret)
        }
        
        return Static.instance
    }
    
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(_ code: String){
        
        var parameters: [String: String] = ["code": code]
        parameters["client_id"] =  clientKey
        parameters["client_secret"] = clientSecret
        parameters["redirect_uri"] = "watchme://oauth"
        parameters["grant_type"] = "authorization_code"
        Client.sharedInstance.authenticateUsingOAuth(withURLString: "https://api-v2launch.trakt.tv/oauth/token", parameters: parameters, success: { (token: AFOAuthCredential!) -> Void in
            //print("Was successful!")
            self.accessToken = token.accessToken
            self.loginSuccess!()
        }) { (error: Error!) -> Void in
            print("Was not successful!")
            self.loginFailure!(error)
            print(error!)
            
        }
        
    }
    
    func loginWithCallback(_ success: @escaping () -> (), failure: @escaping (Error) -> ()){
        UIApplication.shared.openURL(URL(string: "https://api-v2launch.trakt.tv/oauth/authorize?response_type=code&client_id=\(clientKey)&redirect_uri=watchme://oauth")!)
        loginSuccess = success
        loginFailure = failure
    }
    
    func logout(_ success: ()->(), failure: (NSError) -> ())
    {
        let url = URL(string: "https://api-v2launch.trakt.tv/oauth/revoke")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("2", forHTTPHeaderField: "trakt-api-version")
        request.addValue("\(clientKey)", forHTTPHeaderField: "trakt-api-key")
        
        request.httpBody = "{\n  \"access_token\": \"\(accessToken)\"\n}".data(using: String.Encoding.utf8);
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            if let response = response, let data = data {
                //print(response)
                self.accessToken = nil
                //print(String(data: data, encoding: NSUTF8StringEncoding))
            } else {
                print(error!)
            }
        }) 
        
        task.resume()
    }
    
    func search(_ query: String?, type: String?, year: Int?,success: @escaping ([Entertainment]) -> (), failure: (NSError) -> ()){
        
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestSerializer.setValue("2", forHTTPHeaderField: "trakt-api-version")
        requestSerializer.setValue(clientKey, forHTTPHeaderField: "trakt-api-key")
        
        var parameters: [String: AnyObject] = ["query": query! as AnyObject]
        if type != nil
        {
            parameters["type"] = type as AnyObject?
        }
        if year != nil
        {
            parameters["year"] = year as AnyObject?
        }
        get("https://api-v2launch.trakt.tv/search?type=movie,show", parameters: parameters, progress: nil,success: { (operation, response) -> Void in
            
            //print("Got the search results!")
            let userDictionary = response as! [NSDictionary]
            
            let entertainments = Entertainment.toArray(userDictionary)
            success(entertainments)
        }) { (operation, error) -> Void in
            print("Did not get the search results")
        }
    }
    
    func addToCollection(_ entertainment: Entertainment,success: () -> (), failure: (NSError) -> ()){
        
//                requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
//                requestSerializer.setValue("2", forHTTPHeaderField: "trakt-api-version")
//                requestSerializer.setValue(clientKey, forHTTPHeaderField: "trakt-api-key")
//                requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//        
//                let json: [String: AnyObject] = ["movies":["title": entertainment.title!,"year":entertainment.year!,"ids":entertainment.ids!]]
//                //let jsonData = NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
//                if(entertainment.type == "movie")
//                {
//                    POST("https://api-v2launch.trakt.tv/sync/collection", parameters: json, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
//                        print("Successfully added to collection")
//                        }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
//                            print("Did not add to collection")
//                    })
//                }
        
        let url = URL(string: "https://api-v2launch.trakt.tv/sync/collection")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("2", forHTTPHeaderField: "trakt-api-version")
        request.addValue(clientKey, forHTTPHeaderField: "trakt-api-key")
        
        request.httpBody = "{\n\"movies\": [\n {\n \"collected_at\": \"2014-09-01T09:10:11.000Z\",\n \"title\": \"\(entertainment.title)\",\n \"year\": \(entertainment.year),\n \"ids\": {\n \"trakt\": 1,\n \"slug\": \"\(entertainment.ids?.value(forKey: "slug"))\",\n\"imdb\": \"\(entertainment.ids?.value(forKey: "imdb"))\",\n \"tmdb\": \(entertainment.ids?.value(forKey: "tmdb"))\n }\n }\n ]\n}".data(using: String.Encoding.utf8);
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            if let response = response, let data = data {
                print(response)
                print(String(data: data, encoding: String.Encoding.utf8)!)
            } else {
                print(error!)
            }
        }) 
        
        task.resume()

    }
    
    func getCollection(_ success: @escaping ([Entertainment]) -> (), failure: (NSError) -> ()){
        
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestSerializer.setValue("2", forHTTPHeaderField: "trakt-api-version")
        requestSerializer.setValue(clientKey, forHTTPHeaderField: "trakt-api-key")
        requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        get("https://api-v2launch.trakt.tv/sync/collection/movies?extended=images,full", parameters: nil, progress: nil, success: { (operation, response) -> Void in
            
            //print("Got the collection!")
            let userDictionary = response as! [NSDictionary]
            
            success(Entertainment.toArray(userDictionary))
        }) { (operation, error) -> Void in
            print("Did not get the search results")
        }
        
    }
    
    func getMovieRecommendation(_ id: String,success: @escaping ([Recommendation]) -> (), failure: (NSError) -> ()){
        
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestSerializer.setValue("2", forHTTPHeaderField: "trakt-api-version")
        requestSerializer.setValue(clientKey, forHTTPHeaderField: "trakt-api-key")
        requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        get("https://api-v2launch.trakt.tv/movies/\(id)/related?extended=images,full&limit=5", parameters: nil, progress: nil, success: { (operation, response) -> Void in
            
            print("Got the related movies!")
            let tmpUserMovieDictionary = response as! [NSDictionary]
            
            for i in 0 ..< tmpUserMovieDictionary.count
            {
                self.userMovieDictionary.append(tmpUserMovieDictionary[i].mutableCopy() as! NSMutableDictionary)
                self.userMovieDictionary[i].setValue("Movie", forKey: "type")
            }
            success(Recommendation.toArray(self.userMovieDictionary))
        }) { (operation, error) -> Void in
            print("Did not get the related movies")
        }
    }
    
    func getShowRecommendation(_ id: String,success: @escaping ([Recommendation]) -> (), failure: (NSError) -> ()){
        
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestSerializer.setValue("2", forHTTPHeaderField: "trakt-api-version")
        requestSerializer.setValue(clientKey, forHTTPHeaderField: "trakt-api-key")
        requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        get("https://api-v2launch.trakt.tv/shows/\(id)/related?extended=images,full&limit=5", parameters: nil, progress: nil, success: { (operation, response) -> Void in
            
            print("Got the related shows!")
            let tmpUserShowDictionary = response as! [NSDictionary]
            
            for i in 0 ..< tmpUserShowDictionary.count
            {
                self.userShowDictionary.append(tmpUserShowDictionary[i].mutableCopy() as! NSMutableDictionary)
                self.userShowDictionary[i].setValue("Show", forKey: "type")
            }
            success(Recommendation.toArray(self.userShowDictionary))
            }) { (operation, error) -> Void in
                print("Did not get the related movies")
        }
    }

    
    func getSettings(_ username: String, success: @escaping (NSDictionary) -> (), failure: (NSError) -> ()){
        
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestSerializer.setValue("2", forHTTPHeaderField: "trakt-api-version")
        requestSerializer.setValue(clientKey, forHTTPHeaderField: "trakt-api-key")
        requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        get("https://api-v2launch.trakt.tv/users/settings", parameters: nil, progress: nil, success: { (operation, response) -> Void in
            //print("Got the user settings!")
            success(response as! NSDictionary)
            print(response!)
        }) { (operation, error) -> Void in
            print("Did not get user settings")
        }
        
    }
    
    func getStats(_ username: String, success: @escaping (NSDictionary) -> (), failure: (NSError) -> ()){
        
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestSerializer.setValue("2", forHTTPHeaderField: "trakt-api-version")
        requestSerializer.setValue(clientKey, forHTTPHeaderField: "trakt-api-key")
        requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        get("https://api-v2launch.trakt.tv/users/\(username)/stats", parameters: nil, progress: nil, success: { (operation, response) -> Void in
            //print("Got the stats!")
            success(response as! NSDictionary)
        }) { (operation, error) -> Void in
            print("Did not get stats")
        }
    }
    
    func getTrendingMovies(_ success: @escaping ([Entertainment]) -> (), failure: (NSError) -> ()){
        
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestSerializer.setValue("2", forHTTPHeaderField: "trakt-api-version")
        requestSerializer.setValue(clientKey, forHTTPHeaderField: "trakt-api-key")
        requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        get("https://api-v2launch.trakt.tv/movies/trending?extended=images,full&limit=30", parameters: nil, progress: nil, success: {
            (operation, response) -> Void in
            //print("Succeed in getting trending movies")
            let userDictionary = response as! [NSDictionary]
            let trendingMovies = Entertainment.toArray(userDictionary)
            success(trendingMovies)
        }) { (operation, error) -> Void in
            print("Failed getting trending movies")
        }
        
    }

    func getTrendingShows(_ success: @escaping ([Entertainment]) -> (), failure: (NSError) -> ()){
        
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestSerializer.setValue("2", forHTTPHeaderField: "trakt-api-version")
        requestSerializer.setValue(clientKey, forHTTPHeaderField: "trakt-api-key")
        requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        get("https://api-v2launch.trakt.tv/shows/trending?extended=images,full&limit=30", parameters: nil, progress: nil, success: {
            (operation, response) -> Void in
            //print("Succeed in getting trending shows")
            let userDictionary = response as! [NSDictionary]
            let trendingShows = Entertainment.toArray(userDictionary)
            success(trendingShows)
        }) { (operation, error) -> Void in
            print("Failed getting trending shows")
        }
        
    }
    
    func getNextEpisode(_ success: () -> (), failure: (NSError) ->()){
        
        get("https://api-v2launch.trakt.tv/shows/game-of-thrones/progress/collection?hidden=false&specials=false", parameters: nil, progress: nil, success: { (operation, response) -> Void in
            //print("Got the next episode!")
        }) { (operation, error) -> Void in
            print("Did not get the next episode")
        }
    }
    
    func getMovieSummary(_ id: String, success: @escaping (NSDictionary) -> (), failure: (NSError) -> ()){
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestSerializer.setValue("2", forHTTPHeaderField: "trakt-api-version")
        requestSerializer.setValue(clientKey, forHTTPHeaderField: "trakt-api-key")
        requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        get("https://api-v2launch.trakt.tv/movies/\(id)?extended=images,full", parameters: nil, progress: nil, success: {
            (operation, response) -> Void in
            print("Got the movie summary!")
            let userDictionary = response as! NSDictionary
            //let summary = Entertainment.toArray(userDictionary)
            success(userDictionary)
            }) { (operation, error) -> Void in
                print("Didn't get the movie summary")
        }

    }
    
    func getShowSummary(_ id: String, success: @escaping (NSDictionary) -> (), failure: (NSError) -> ()){
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestSerializer.setValue("2", forHTTPHeaderField: "trakt-api-version")
        requestSerializer.setValue(clientKey, forHTTPHeaderField: "trakt-api-key")
        requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        get("https://api-v2launch.trakt.tv/shows/\(id)?extended=images,full", parameters: nil, progress: nil, success: {
            (operation, response) -> Void in
            print("Got the show summary!")
            let userDictionary = response as! NSDictionary
            //let summary = Entertainment.toArray(userDictionary)
            success(userDictionary)
            }) { (operation, error) -> Void in
                print("Didn't get the show summary")
        }
        
    }

 
   
}

