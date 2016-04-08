//
//  LoginViewController.swift
//  WatchMe
//
//  Created by Labuser on 3/29/16.
//  Copyright © 2016 Grace. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.hidden = true;
        enterButton.hidden = true;
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
        
        let webView: UIWebView = UIWebView()
        webView.frame = CGRectMake(0, 120, 320, 420)
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://api-v2launch.trakt.tv/oauth/authorize?response_type=code&client_id=\(clientKey)&redirect_uri=urn:ietf:wg:oauth:2.0:oob")!))
        self.view!.addSubview(webView)
        textField.hidden = false;
        enterButton.hidden = false;
        textField.placeholder = "Enter pin here"
    }
    
    @IBAction func onEnter(sender: AnyObject) {
        let pin = textField.text
        
        Client.sharedInstance.login(pin!, success: { () -> () in
            
            self.performSegueWithIdentifier("loginSegue", sender: nil)
            }) { (error: NSError) -> () in
                
        }
    }
    

}
