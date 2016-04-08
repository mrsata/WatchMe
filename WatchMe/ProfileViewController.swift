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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Client.sharedInstance.getSettings({ (info: User) -> () in
            self.user = info
            }) { (error: NSError) -> () in
                
        }
        
        Client.sharedInstance.getStats("IodineXXY", success: { (response: NSDictionary) -> () in
            
            let movNum = response["movies"]!["collected"] as? Int
            print(movNum)
            
            let showNum = response["shows"]!["collected"] as? Int
            
            let epiNum = response["episodes"]!["collected"] as? Int
            
            self.numCollection = (movNum! + showNum! + epiNum!) as Int
            }) { (error: NSError) -> () in
                
        }
        print(numCollection)

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
