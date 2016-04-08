//
//  ItemDetailViewController.swift
//  WatchMe
//
//  Created by Labuser on 3/22/16.
//  Copyright © 2016 Grace. All rights reserved.
//

import UIKit
import Social

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
    
    
    @IBAction func facebookBtn(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            
            print("ready to share on Facebook")

            var fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            self.presentViewController(fbShare, animated: true, completion: nil)
            
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func twitterBtn(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            
            print("ready to share on Twitter")
            
            var tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            self.presentViewController(tweetShare, animated: true, completion: nil)
            
        } else {
            
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
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
