//
//  DiscoverViewController.swift
//  WatchMe
//
//  Created by Labuser on 3/22/16.
//  Copyright © 2016 Grace. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    var searchBar:UISearchBar = UISearchBar()
    
    var entertainments: [Entertainment]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Initialize searchBar:
        searchBar.delegate = self
        searchBar.placeholder = "Discover something new"
        searchBar.sizeToFit()
        self.navigationItem.titleView = searchBar
        
        tableView.dataSource = self
        tableView.delegate = self      
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Functions for searchBar:
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("Search button has been clicked")
        
        Client.sharedInstance.search(searchBar.text, type: nil, year: nil, success: { (data: [Entertainment]) -> () in
            self.entertainments = data
            self.tableView.reloadData()
            }) { (error: NSError) -> () in
                print(error)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if entertainments != nil {
            return entertainments.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("entertainmentCell", forIndexPath: indexPath) as! EntertainmentCell
        
        cell.entertainment = entertainments[indexPath.row]
        
        return cell
        
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
