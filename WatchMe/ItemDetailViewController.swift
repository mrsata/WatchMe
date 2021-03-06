//
//  ItemDetailViewController.swift
//  WatchMe
//
//  Created by Labuser on 3/22/16.
//  Copyright © 2016 Grace. All rights reserved.
//

import UIKit
import Social
import MediaPlayer
import AVKit
import AVFoundation
import YouTubePlayer

class ItemDetailViewController: UIViewController {
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var mainDescriptionLabel: UILabel!
    @IBOutlet weak var recommended1ImageView: UIImageView!
    @IBOutlet weak var recommended2ImageView: UIImageView!
    @IBOutlet weak var recommended3ImageView: UIImageView!
    @IBOutlet weak var recommended4ImageView: UIImageView!
    @IBOutlet weak var yearLabel: UILabel!
    
    
    var trailerString: String!
    var entertainment: Entertainment!
    var recommendations: [Entertainment]!
    var moviePlayer: MPMoviePlayerController!
    
    var gesture1: UITapGestureRecognizer!
    var gesture2: UITapGestureRecognizer!
    var gesture3: UITapGestureRecognizer!
    var gesture4: UITapGestureRecognizer!
    var phantomBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let frame = self.view.frame
        let backgroundImageView = UIImageView(frame: frame)
        backgroundImageView.setImageWith(entertainment.posterImageUrl! as URL)
        backgroundImageView.alpha = 0.3
        self.view.insertSubview(backgroundImageView, at: 0)
        
        mainTitleLabel.text = entertainment.title
        mainDescriptionLabel.text = entertainment.content
        mainDescriptionLabel.sizeToFit()
        
        yearLabel.text = "\(entertainment.year!)"
        
        let id = entertainment.ids?.value(forKey: "imdb") as? String
        
        gesture1 = UITapGestureRecognizer(target: self, action: #selector(ItemDetailViewController.pushItem(_:)))
        gesture2 = UITapGestureRecognizer(target: self, action: #selector(ItemDetailViewController.pushItem(_:)))
        gesture3 = UITapGestureRecognizer(target: self, action: #selector(ItemDetailViewController.pushItem(_:)))
        gesture4 = UITapGestureRecognizer(target: self, action: #selector(ItemDetailViewController.pushItem(_:)))
        recommended1ImageView.addGestureRecognizer(self.gesture1)
        recommended2ImageView.addGestureRecognizer(self.gesture2)
        recommended3ImageView.addGestureRecognizer(self.gesture3)
        recommended4ImageView.addGestureRecognizer(self.gesture4)
        phantomBtn = UIButton()
        
        if(entertainment.type == "Movie")
        {
            Client.sharedInstance.getMovieSummary(id!, success: { (response: NSDictionary) -> () in
                
                if let trailerStr = response["trailer"] as? String
                {
                    self.trailerString = trailerStr
                    print(self.trailerString)
                    
                    //                let videoURL = NSURL(string: self.trailerString!)
                    //                let player = AVPlayer(URL: videoURL!)
                    //                let playerLayer = AVPlayerLayer(player: player)
                    //                playerLayer.frame = CGRect(x: 20, y: 200, width: 280, height: 120)
                    //                self.view.layer.addSublayer(playerLayer)
                    //                player.play()
                    
                    let videoURL = URL(string: self.trailerString!)
                    
                    let w = self.view.frame.width - 40
                    let h = self.view.frame.height * 0.27
                    let moviePlayer = YouTubePlayerView(frame: CGRect(x: 20, y: self.mainDescriptionLabel.frame.maxY + 4, width: w, height: h))
                    
                    moviePlayer.loadVideoURL(videoURL!)
                    self.view.addSubview(moviePlayer)
                    
                }
            }) { (error: NSError) -> () in
                
            }
            
            Client.sharedInstance.getMovieRecommendation(id!, success: { (response: [Recommendation]) -> () in
                //self.recommendations = response
                
                self.recommended1ImageView.setImageWith(response[0].posterImageUrl!)
                self.recommended2ImageView.setImageWith(response[1].posterImageUrl!)
                self.recommended3ImageView.setImageWith(response[2].posterImageUrl!)
                self.recommended4ImageView.setImageWith(response[3].posterImageUrl!)
                
                //                self.recommended1TitleLabel.text = response[0].title
                //                self.recommended2TitleLabel.text = response[1].title
                //                self.recommended3TitleLabel.text = response[2].title
                //                self.recommended4TitleLabel.text = response[3].title
                
            }) { (error: NSError) -> () in
                
            }
            
        }
        else if (entertainment.type == "Show")
        {
            Client.sharedInstance.getShowSummary(id!, success: { (response: NSDictionary) -> () in
                
                if let trailerString = response["trailer"] as? String{
                    self.trailerString = trailerString
                    print(self.trailerString ?? "nil trailerString")
                    
                    //                let videoURL = NSURL(string: self.trailerString!)
                    //                let player = AVPlayer(URL: videoURL!)
                    //                let playerLayer = AVPlayerLayer(player: player)
                    //                playerLayer.frame = CGRect(x: 20, y: 200, width: 280, height: 120)
                    //                self.view.layer.addSublayer(playerLayer)
                    //                player.play()
                    
                    let videoURL = URL(string: self.trailerString!)
                    
                    let w = self.view.frame.width - 40
                    let h = self.view.frame.height * 0.27
                    let moviePlayer = YouTubePlayerView(frame: CGRect(x: 20, y: self.mainDescriptionLabel.frame.maxY, width: w, height: h))
                    
                    moviePlayer.loadVideoURL(videoURL!)
                    self.view.addSubview(moviePlayer)
                }
            }) { (error: NSError) -> () in
                
            }
            
            Client.sharedInstance.getShowRecommendation(id!, success: { (response: [Recommendation]) -> () in
                //self.recommendations = response
                
                self.recommended1ImageView.setImageWith(response[0].posterImageUrl!)
                self.recommended2ImageView.setImageWith(response[1].posterImageUrl!)
                self.recommended3ImageView.setImageWith(response[2].posterImageUrl!)
                self.recommended4ImageView.setImageWith(response[3].posterImageUrl!)
                
                //                self.recommended1TitleLabel.text = response[0].title
                //                self.recommended2TitleLabel.text = response[1].title
                //                self.recommended3TitleLabel.text = response[2].title
                //                self.recommended4TitleLabel.text = response[3].title
                
            }) { (error: NSError) -> () in
                
            }
            
            
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pushItem(_ gesture: UIGestureRecognizer){
        self.performSegue(withIdentifier: "pushItem", sender: gesture)
        print("pushItem")
    }
    
    @IBAction func facebookBtn(_ sender: AnyObject) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            
            print("ready to share on Facebook")
            
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            self.present(fbShare, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func twitterBtn(_ sender: AnyObject) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            
            print("ready to share on Twitter")
            
            let tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            self.present(tweetShare, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "pushItem"){
            
            var index: Int = 0
            
            print("ready for segue")
            
            if let gesture = sender as? UIGestureRecognizer {
                switch gesture{
                case gesture1:
                    index = 0
                    print("gesture1")
                    break
                case gesture2:
                    index = 1
                    print("gesture2")
                    break
                case gesture3:
                    index = 2
                    print("gesture3")
                    break
                case gesture4:
                    index = 3
                    print("gesture4")
                    break
                default:
                    break
                }
                
            }
            
            let entertainment = recommendations[index]
            
            let detailViewController = segue.destination as! ItemDetailViewController
            
            detailViewController.entertainment = entertainment
        }
        
    }
    
}
