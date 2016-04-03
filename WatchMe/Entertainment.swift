//
//  Entertainment.swift
//  WatchMe
//
//  Created by Grace Egbo on 4/2/16.
//  Copyright © 2016 Grace. All rights reserved.
//

import UIKit

class Entertainment: NSObject {

    var title: String?
    var year: Int?
    var type: String?
    var content: String?
    var posterImageUrl: NSURL?
    var score:  Double?
    var ids: NSDictionary?
    
    init(dictionary: NSDictionary)
    {
        score = dictionary["score"] as? Double
        type = dictionary["type"] as? String
    
        if(type == "movie")
        {
            title = dictionary["movie"]!["title"] as? String
            
            year = dictionary["movie"]!["year"] as? Int
            
            content = dictionary["movie"]!["overview"] as? String
            
            ids = (dictionary["movie"]!["ids"] as? NSDictionary)!
            
            var posterString = dictionary["movie"]!["images"]!!["poster"]!!["full"] as? String
            
            if let posterString = posterString
            {
                posterImageUrl = NSURL(string: posterString)
            }
            else
            {
                posterString = nil
            }

        }
        else
        {
            title = dictionary["show"]!["title"] as? String
            
            year = dictionary["show"]!["year"] as? Int
            
            content = dictionary["show"]!["overview"] as? String
            
            ids = (dictionary["show"]!["ids"] as? NSDictionary)!
            
            var posterString = dictionary["show"]!["images"]!!["poster"]!!["full"] as? String
            
            if let posterString = posterString
            {
                posterImageUrl = NSURL(string: posterString)
            }
            else
            {
                posterString = nil
            }

        }
        
        
    }
    
    class func toArray(array: [NSDictionary]) -> [Entertainment]{
        var entertainments = [Entertainment]()
        
        for dictionary in array {
            entertainments.append(Entertainment(dictionary: dictionary))
        }
        
        return entertainments
    }
}
