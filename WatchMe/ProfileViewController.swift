//
//  ProfileViewController.swift
//  WatchMe
//
//  Created by Grace Egbo on 4/2/16.
//  Copyright © 2016 Grace. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIScrollViewDelegate {
    //Test Scroll View
    
    @IBOutlet weak var foreground: UIScrollView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var numCollect: UILabel!
    
    
    
   
    
    var user: User!
    var item: Entertainment!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = user!.name
        numCollect.text = "\(user!.numCollection)"
        
        

        
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let foregroundHeight = foreground.contentSize.height - CGRectGetHeight(foreground.bounds)
        let percentageScroll = foreground.contentOffset.y / foregroundHeight
        foreground.contentOffset = CGPoint(x: 0, y: foregroundHeight * percentageScroll)
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
