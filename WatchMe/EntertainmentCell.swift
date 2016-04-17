//
//  EntertainmentCell.swift
//  WatchMe
//
//  Created by Grace Egbo on 4/2/16.
//  Copyright © 2016 Grace. All rights reserved.
//

import UIKit

class EntertainmentCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var entertainment: Entertainment! {
        didSet {
            let scorePercentage = entertainment.score! * 0.40
            scoreLabel.text = String(format: "%.0f",scorePercentage)+"%"
            titleLabel.text = entertainment.title
            typeLabel.text = entertainment.type?.uppercaseString
            descriptionLabel.text = entertainment.content
            if let year = entertainment.year {
                yearLabel.text = "(\(year))"
            } else {
                yearLabel.text = "no year"
            }
            if let posterImageUrl = entertainment.posterImageUrl {
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
        
        descriptionLabel.sizeToFit()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
