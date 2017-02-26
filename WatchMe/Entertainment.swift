//
//  Entertainment.swift
//  WatchMe
//
//  Created by Grace Egbo on 4/2/16.
//  Copyright © 2016 Grace. All rights reserved.
//

import UIKit

class Entertainment: NSObject {
    
    var dictionary: NSDictionary
    var title: String?
    var year: Int?
    var type: String?
    var content: String?
    var score:  Double?
    var ids: NSDictionary?
    var posterImageUrl: URL?
    var posterImageString: String?
    var clearartImageUrl: URL?
    var clearartImageString: String?
    var thumbImageUrl: URL?
    var thumbImageString: String?
    var trailerString: String?
    let noImageUrl: URL = URL(string: "http://1vyf1h2a37bmf88hy3i8ce9e.wpengine.netdna-cdn.com/wp-content/themes/public/img/noimgavailable.jpg")!
    
    init(dictionary: NSDictionary)
    {
        self.dictionary = dictionary
        super.init()
        score = dictionary["score"] as? Double
        
        if(dictionary["type"] as? String ==  "Movie" || dictionary["movie"] != nil )
        {
            type = "Movie"
            
            let movie = dictionary["movie"] as! NSDictionary
            
            title = movie["title"] as? String
            
            year = movie["year"] as? Int
            
            content = movie["overview"] as? String
            
            ids = (movie["ids"] as? NSDictionary)!
            
            if(dictionary["trailer"] != nil)
            {
                trailerString = dictionary["trailer"] as? String
                print(trailerString ?? "no trailer string")
            }
            
            // poster:
//            let posterString = dictionary["movie"]!["images"]!!["poster"]!!["thumb"] as? String
//            
//            if let posterString = posterString
//            {
//                posterImageString = posterString
//                posterImageUrl = URL(string: posterString)
//            }
//            else
//            {
                posterImageUrl = noImageUrl
//            }
            
            // clearart:
//            let clearartString = dictionary["movie"]?["images"]??["clearart"]??["full"] as? String
//            
//            if let clearartString = clearartString
//            {
//                clearartImageString = clearartString
//                clearartImageUrl = URL(string: clearartString)
//            }
//            else
//            {
                clearartImageUrl = nil
//            }
            
            // thumb:
//            let thumbString = dictionary["movie"]?["images"]??["thumb"]??["full"] as? String
//            
//            if let thumbString = thumbString
//            {
//                thumbImageString = thumbString
//                thumbImageUrl = URL(string: thumbString)
//            }
//            else
//            {
                thumbImageUrl = nil
//            }
            
        }
        else if (dictionary["show"] != nil || type == "Show")
        {
            type = "Show"
            
            let show = dictionary["show"] as! NSDictionary
            
            title = show["title"] as? String
            
            year = show["year"] as? Int
            
            content = show["overview"] as? String
            
            ids = (show["ids"] as? NSDictionary)!
            
            if(dictionary["trailer"] != nil)
            {
                trailerString = dictionary["trailer"] as? String
            }
            
            // poster:
//            let posterString = dictionary["show"]?["images"]??["poster"]??["thumb"] as? String
//            
//            if let posterString = posterString
//            {
//                posterImageUrl = URL(string: posterString)
//            }
//            else
//            {
                posterImageUrl = noImageUrl
//            }
            
            // clearart:
//            let clearartString = dictionary["show"]?["images"]??["clearart"]??["full"] as? String
//            
//            if let clearartString = clearartString
//            {
//                clearartImageUrl = URL(string: clearartString)
//            }
//            else
//            {
                clearartImageUrl = noImageUrl
//            }
            
            // thumb:
//            let thumbString = dictionary["show"]?["images"]??["thumb"]??["full"] as? String
//            
//            if let thumbString = thumbString
//            {
//                thumbImageUrl = URL(string: thumbString)
//            }
//            else
//            {
                thumbImageUrl = noImageUrl
//            }
            
        }
        
    }
    
    class func toArray(_ array: [NSDictionary]) -> [Entertainment]{
        var entertainments = [Entertainment]()
        
        for dictionary in array {
            entertainments.append(Entertainment(dictionary: dictionary))
        }
        
        return entertainments
    }
    
}
