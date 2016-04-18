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
    var score:  Double?
    var ids: NSDictionary?
    var posterImageUrl: NSURL?
    var posterImageString: String?
    var clearartImageUrl: NSURL?
    var clearartImageString: String?
    var thumbImageUrl: NSURL?
    var thumbImageString: String?
    var trailerString: String?
    
    init(dictionary: NSDictionary)
    {
        super.init()
        score = dictionary["score"] as? Double
        
        if(dictionary["type"] as? String ==  "Movie" || dictionary["movie"] != nil )
        {
            type = "Movie"
            
            title = dictionary["movie"]!["title"] as? String
            
            year = dictionary["movie"]!["year"] as? Int
            
            content = dictionary["movie"]!["overview"] as? String
            
            ids = (dictionary["movie"]!["ids"] as? NSDictionary)!
            
            if(dictionary["trailer"] != nil)
            {
                trailerString = dictionary["trailer"] as? String
                print(trailerString)
            }
            
            // poster:
            let posterString = dictionary["movie"]!["images"]!!["poster"]!!["thumb"] as? String
            
            if let posterString = posterString
            {
                posterImageString = posterString
                posterImageUrl = NSURL(string: posterString)
            }
            else
            {
                let noImageUrl: NSURL = NSURL(string: "http://1vyf1h2a37bmf88hy3i8ce9e.wpengine.netdna-cdn.com/wp-content/themes/public/img/noimgavailable.jpg")!
                posterImageUrl = noImageUrl
            }
            
            // clearart:
            let clearartString = dictionary["movie"]?["images"]??["clearart"]??["full"] as? String
            
            if let clearartString = clearartString
            {
                clearartImageString = clearartString
                clearartImageUrl = NSURL(string: clearartString)
            }
            else
            {
                clearartImageUrl = nil
            }
            
            // thumb:
            let thumbString = dictionary["movie"]?["images"]??["thumb"]??["full"] as? String
            
            if let thumbString = thumbString
            {
                thumbImageString = thumbString
                thumbImageUrl = NSURL(string: thumbString)
            }
            else
            {
                thumbImageUrl = nil
            }
            
        }
        else if (dictionary["show"] != nil || type == "Show")
        {
            type = "Show"
            
            title = dictionary["show"]!["title"] as? String
            
            year = dictionary["show"]!["year"] as? Int
            
            content = dictionary["show"]!["overview"] as? String
            
            ids = (dictionary["show"]!["ids"] as? NSDictionary)!
            
            if(dictionary["trailer"] != nil)
            {
                trailerString = dictionary["trailer"] as? String
            }
            
            // poster:
            let posterString = dictionary["show"]?["images"]??["poster"]??["thumb"] as? String
            
            if let posterString = posterString
            {
                posterImageUrl = NSURL(string: posterString)
            }
            else
            {
                let noImageUrl: NSURL = NSURL(string: "http://1vyf1h2a37bmf88hy3i8ce9e.wpengine.netdna-cdn.com/wp-content/themes/public/img/noimgavailable.jpg")!
                posterImageUrl = noImageUrl
            }
            
            // clearart:
            let clearartString = dictionary["show"]?["images"]??["clearart"]??["full"] as? String
            
            if let clearartString = clearartString
            {
                clearartImageUrl = NSURL(string: clearartString)
            }
            else
            {
                clearartImageUrl = nil
            }
            
            // thumb:
            let thumbString = dictionary["show"]?["images"]??["thumb"]??["full"] as? String
            
            if let thumbString = thumbString
            {
                thumbImageUrl = NSURL(string: thumbString)
            }
            else
            {
                thumbImageUrl = nil
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
