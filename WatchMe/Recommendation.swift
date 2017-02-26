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
    var posterImageUrl: URL?
    var ids: NSDictionary?
    let noImageUrl: URL = URL(string: "http://1vyf1h2a37bmf88hy3i8ce9e.wpengine.netdna-cdn.com/wp-content/themes/public/img/noimgavailable.jpg")!

    init(dictionary: NSDictionary)
    {
        
        title = dictionary["title"] as? String
        
        year = dictionary["year"] as? Int
        
        type = dictionary["type"] as? String
        
        ids = dictionary["ids"] as? NSDictionary
        
//        let posterString = dictionary["images"]!["poster"]!!["thumb"] as? String
//        
//        if let posterString = posterString
//        {
//            posterImageUrl = URL(string: posterString)
//        }
//        else
//        {
            posterImageUrl = noImageUrl
//        }
        
    }

    class func toArray(_ array: [NSDictionary]) -> [Recommendation]{
        var recommendations = [Recommendation]()
        
        for dictionary in array {
            recommendations.append(Recommendation(dictionary: dictionary))
        }
        
        return recommendations
    }
}
