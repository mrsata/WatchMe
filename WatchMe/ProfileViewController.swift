//
//  ProfileViewController.swift
//  WatchMe
//
//  Created by Grace Egbo on 4/2/16.
//  Copyright © 2016 Grace. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var numCollected: UILabel!
    @IBOutlet weak var joinTime: UILabel!
    
    var numCollection: Int?
    var user: User!
    var createdAt: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let frame = self.view.frame
        let backgroundImageView = UIImageView(frame: frame)
        backgroundImageView.image = UIImage(named: "BG")
        backgroundImageView.alpha = 0.6
        self.view.insertSubview(backgroundImageView, at: 0)
        
        Client.sharedInstance.getSettings("IodineXXY", success: { (response: NSDictionary) -> () in
            // Time format
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sss'Z'"
            let user = response["user"] as! NSDictionary
            
            let createdAtString = user["joined_at"] as? String
            self.createdAt = formatter.date(from: createdAtString!)
            print(self.createdAt ?? "no joined_at")
            
            let calendar = Calendar.current
            let comp = (calendar as NSCalendar).components([.hour, .minute, .month, .day, .year], from: self.createdAt!)
            
            self.joinTime.text = "\(comp.month)/\(comp.day)/\(comp.year)"
            
            }) { (error: NSError) -> () in
            
        }
        
        Client.sharedInstance.getStats("IodineXXY", success: { (response: NSDictionary) -> () in
            
            let movies = response["movies"] as! NSDictionary
            let shows = response["shows"] as! NSDictionary
            let episodes = response["episodes"] as! NSDictionary
            
            let movNum = movies["collected"] as! Int
            let showNum = shows["collected"] as! Int
            let epiNum = episodes["collected"] as! Int
            
            self.numCollection = (movNum + showNum + epiNum)
            self.numCollected.text = "\(self.numCollection!)"
            }) { (error: NSError) -> () in
           
        }
        
        
    
    }
    
    
    @IBAction func onLogout(_ sender: AnyObject) {
        
        Client.sharedInstance.logout({ () -> () in
            self.performSegue(withIdentifier: "logoutSegue", sender: sender)
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
