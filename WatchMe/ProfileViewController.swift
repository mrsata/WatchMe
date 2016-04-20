//
//  ProfileViewController.swift
//  WatchMe
//
//  Created by Grace Egbo on 4/2/16.
//  Copyright © 2016 Grace. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var numCollection: Int?
    
    var user: User!
    
    var createdAt: NSDate?

    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var numCollected: UILabel!
    
    @IBOutlet weak var joinTime: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Client.sharedInstance.getSettings("IodineXXY", success: { (response: NSDictionary) -> () in
            // Time format
            var formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sss'Z'"
            print(response["user"]!["joined_at"])
            
            let createdAtString = response["user"]!["joined_at"] as? String
            self.createdAt = formatter.dateFromString(createdAtString!)
            //print(self.createdAt)
            
            let calendar = NSCalendar.currentCalendar()
            let comp = calendar.components([.Hour, .Minute, .Month, .Day, .Year], fromDate: self.createdAt!)
            
            self.joinTime.text = "\(comp.month)/\(comp.day)/\(comp.year)"
            
            }) { (error: NSError) -> () in
            
        }
        
        Client.sharedInstance.getStats("IodineXXY", success: { (response: NSDictionary) -> () in
            
            let movNum = response["movies"]!["collected"] as? Int
            print(movNum)
            
            let showNum = response["shows"]!["collected"] as? Int
            
            let epiNum = response["episodes"]!["collected"] as? Int
            
            self.numCollection = (movNum! + showNum! + epiNum!) as Int
          
            self.numCollected.text = "\(self.numCollection!)"
            }) { (error: NSError) -> () in
           
        }
        
        
    
    }
    
    
    @IBAction func onLogout(sender: AnyObject) {
        
        Client.sharedInstance.logout({ () -> () in
            self.performSegueWithIdentifier("logoutSegue", sender: sender)
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
