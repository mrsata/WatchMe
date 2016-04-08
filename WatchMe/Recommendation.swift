//
//  Recommendation.swift
//  WatchMe
//
//  Created by Labuser on 4/7/16.
//  Copyright © 2016 Grace. All rights reserved.
//

import UIKit

class Recommendation: NSObject {
    
    var title: String?
    var year: Int?
    var type: String?
    var posterImageUrl: NSURL?
    var ids: NSDictionary?

    init(dictionary: NSDictionary)
    {
        
        title = dictionary["title"] as? String
        
        year = dictionary["year"] as? Int
        
        type = dictionary["type"] as? String
        
        ids = dictionary["ids"] as? NSDictionary
        
        let posterString = dictionary["images"]!["poster"]!!["full"] as? String
        
        if let posterString = posterString
        {
            posterImageUrl = NSURL(string: posterString)
        }
        else
        {
            posterImageUrl = nil
        }
        
    }

    class func toArray(array: [NSDictionary]) -> [Recommendation]{
        var recommendations = [Recommendation]()
        
        for dictionary in array {
            recommendations.append(Recommendation(dictionary: dictionary))
        }
        
        return recommendations
    }
}
