//
//  SearchViewController.swift
//  WatchMe
//
//  Created by LH on 16/4/14.
//  Copyright © 2016年 Grace. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var searchTableView: UITableView!
    var entertainments: [Entertainment]!
    var searchBar:UISearchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let backgroundImageViewFrame = self.view.frame
        let backgroundImageView = UIImageView(frame: backgroundImageViewFrame)
        backgroundImageView.image = UIImage(named: "BG")
        backgroundImageView.alpha = 0.4
        self.view.insertSubview(backgroundImageView, atIndex: 0)
        
        // Initialize searchBar:
        searchBar.delegate = self
        searchBar.placeholder = "Discover something new"
        searchBar.sizeToFit()
        self.navigationItem.titleView = searchBar
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.hidden = true
        searchTableView.backgroundColor = UIColor.clearColor()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Functions for searchBar:
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchTableView.hidden = false
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        Client.sharedInstance.search(searchText, type: nil, year: nil, success: { (data: [Entertainment]) -> () in
            self.entertainments = data
            self.searchTableView.reloadData()
        }) { (error: NSError) -> () in
            print(error)
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("Search button has been clicked")
        searchBar.endEditing(true)
        Client.sharedInstance.search(searchBar.text, type: nil, year: nil, success: { (data: [Entertainment]) -> () in
            
            self.entertainments = data
            self.searchTableView.reloadData()
            
        }) { (error: NSError) -> () in
            print(error)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        
        count = 0
        
        if tableView == self.searchTableView {
            if entertainments != nil {
                count = entertainments.count
            }
        }
        
        return count!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("entertainmentCell", forIndexPath: indexPath) as! EntertainmentCell
        
        cell.entertainment = entertainments[indexPath.row]
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
        
    }
    
    @IBAction func addCollection(sender: AnyObject) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! EntertainmentCell
        
        let indexPath = searchTableView.indexPathForCell(cell)
        
        let entertainment = entertainments[indexPath!.row]
        
        Client.sharedInstance.addToCollection(entertainment, success: { () -> () in
            print("I got here!")
        }) { (error: NSError) -> () in
            
        }
    }
    
    @IBAction func onTouch(sender: AnyObject) {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.performSegueWithIdentifier("cancelSearch", sender: nil)
        
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let cell = sender as? UITableViewCell{
            
            let indexPath = searchTableView.indexPathForCell(cell)
            let trendingEntertainment = entertainments[indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! ItemDetailViewController
            
            detailViewController.entertainment = trendingEntertainment
        }
        
    }
    
}
