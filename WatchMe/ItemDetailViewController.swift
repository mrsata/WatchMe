//
//  ItemDetailViewController.swift
//  WatchMe
//
//  Created by Labuser on 3/22/16.
//  Copyright © 2016 Grace. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var mainDescriptionLabel: UILabel!
    @IBOutlet weak var showtimes1Label: UILabel!
    @IBOutlet weak var showtimes2Label: UILabel!
    @IBOutlet weak var showtimes3Label: UILabel!
    @IBOutlet weak var showtimes4Label: UILabel!
    @IBOutlet weak var showtimes5Label: UILabel!
    @IBOutlet weak var recommended1ImageView: UIImageView!
    @IBOutlet weak var recommended2ImageView: UIImageView!
    @IBOutlet weak var recommended3ImageView: UIImageView!
    @IBOutlet weak var recommended4ImageView: UIImageView!
    @IBOutlet weak var recommended1TitleLabel: UILabel!
    @IBOutlet weak var recommended2TitleLabel: UILabel!
    @IBOutlet weak var recommended3TitleLabel: UILabel!
    @IBOutlet weak var recommended4TitleLabel: UILabel!
    
    

    var entertainment: Entertainment!
    
    var recommendations: [Entertainment]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mainTitleLabel.text = entertainment.title
        mainImageView.setImageWithURL(entertainment.posterImageUrl!)
        mainDescriptionLabel.text = entertainment.content
        mainDescriptionLabel.sizeToFit()
        
        Client.sharedInstance.getMovieRecommendation({ (response: [Entertainment]) -> () in
            self.recommendations = response
            }) { (error: NSError) -> () in
                
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
