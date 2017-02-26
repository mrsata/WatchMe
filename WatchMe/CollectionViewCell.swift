//
//  CollectionViewCell.swift
//  WatchMe
//
//  Created by Grace Egbo on 4/3/16.
//  Copyright © 2016 Grace. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    var entertainment: Entertainment! {
        didSet{
//            if let posterImageUrl = entertainment.posterImageUrl {
//                posterImageView.setImageWithURL(posterImageUrl)
//            } else {
//                let noImageUrl: NSURL = NSURL(string: "http://1vyf1h2a37bmf88hy3i8ce9e.wpengine.netdna-cdn.com/wp-content/themes/public/img/noimgavailable.jpg")!
//                posterImageView.setImageWithURL(noImageUrl)
//            }
            posterImageView.setImageWith(entertainment.posterImageUrl! as URL)
        }
    }
}
