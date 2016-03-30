//
//  LoginViewController.swift
//  WatchMe
//
//  Created by Labuser on 3/29/16.
//  Copyright © 2016 Grace. All rights reserved.
//

import UIKit


//let clientKey = "aa88988e98c9f1c01ee9b2b2a85fb7744894d9ce0bf931dcc4bbdb5fb3b73694"

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    @IBAction func onSignIn(sender: AnyObject) {
        let url = NSURL(string: "https://api-v2launch.trakt.tv/oauth/authorize?response_type=code&client_id=\(clientKey)&redirect_uri=trakt://oauth")!
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if let response = response, data = data {
                print(response)
                print(String(data: data, encoding: NSUTF8StringEncoding))
            } else {
                print(error)
            }
        }
        
        task.resume()
    }

}
