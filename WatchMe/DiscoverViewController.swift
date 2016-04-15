//
//  DiscoverViewController.swift
//  WatchMe
//
//  Created by Labuser on 3/22/16.
//  Copyright © 2016 Grace. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var trendingMoviesTableView: UITableView!
    
    var trendingMovies: [Entertainment]!
    var trendingShows:  [Entertainment]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        trendingMoviesTableView.dataSource = self
        trendingMoviesTableView.delegate = self
        
        // displayTrendingMovies()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Display main contents:
    func displayTrendingMovies(){
        Client.sharedInstance.getTrendingMovies( { (data: [Entertainment]) -> () in
            self.trendingMovies = data
            self.trendingMoviesTableView.reloadData()
        }) { (error: NSError) -> () in
            print(error)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var count:Int?
        
        count = 0
        
        if tableView == self.trendingMoviesTableView {
            if trendingMovies != nil {
                count = trendingMovies.count
            }
        }
        
        return count!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("trendingMoviesCell", forIndexPath: indexPath) as! EntertainmentCell
        
        cell.entertainment = trendingMovies[indexPath.row]
        
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
