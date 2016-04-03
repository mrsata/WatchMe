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
            yearLabel.text = "(\(entertainment.year!))"
            posterImageView.setImageWithURL(entertainment.posterImageUrl!)
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
