//
//  ProfileCollectionViewController.swift
//  WatchMe
//
//  Created by XXY on 16/4/14.
//  Copyright © 2016年 Grace. All rights reserved.
//

import UIKit

class ProfileCollectionViewController: UIViewController {

    @IBOutlet weak var collection1: UIImageView!

    @IBOutlet weak var collection2: UIImageView!
    
    @IBOutlet weak var collection3: UIImageView!
    
    @IBOutlet weak var collection4: UIImageView!
    
    @IBOutlet weak var collection5: UIImageView!
    
    @IBOutlet weak var collection6: UIImageView!
    
    @IBOutlet weak var name1: UILabel!
    
    @IBOutlet weak var name2: UILabel!

    @IBOutlet weak var name3: UILabel!
    
    @IBOutlet weak var name4: UILabel!
    
    @IBOutlet weak var name5: UILabel!
    
    @IBOutlet weak var name6: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Load top 6 from collections.
        Client.sharedInstance.getCollection({ (response: [Entertainment]) -> () in
            self.collection1.setImageWithURL(response[0].posterImageUrl!)
            self.collection2.setImageWithURL(response[1].posterImageUrl!)
            self.collection3.setImageWithURL(response[2].posterImageUrl!)
            self.collection4.setImageWithURL(response[3].posterImageUrl!)
            self.collection5.setImageWithURL(response[4].posterImageUrl!)
            self.collection6.setImageWithURL(response[5].posterImageUrl!)
            
            self.name1.text = response[0].title
            self.name2.text = response[1].title
            self.name3.text = response[2].title
            self.name4.text = response[3].title
            self.name5.text = response[4].title
            self.name6.text = response[5].title
            
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
