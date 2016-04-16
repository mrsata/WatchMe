//
//  TrendingCell.swift
//  WatchMe
//
//  Created by LH on 16/4/16.
//  Copyright © 2016年 Grace. All rights reserved.
//

import UIKit

class TrendingCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var trending: Entertainment! {
        didSet {
            
            titleLabel.text = trending.title
            descriptionLabel.text = trending.content
            if let posterImageUrl = trending.posterImageUrl {
                posterImageView.setImageWithURL(posterImageUrl)
            } else {
                let noImageUrl: NSURL = NSURL(string: "http://1vyf1h2a37bmf88hy3i8ce9e.wpengine.netdna-cdn.com/wp-content/themes/public/img/noimgavailable.jpg")!
                posterImageView.setImageWithURL(noImageUrl)
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
