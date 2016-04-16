//
//  DiscoverViewController.swift
//  WatchMe
//
//  Created by Labuser on 3/22/16.
//  Copyright © 2016 Grace. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var trendingTableView: UITableView!
    
    var trending: [Entertainment]!
    var trendingMovies: [Entertainment]!
    var trendingShows:  [Entertainment]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getTrendingMovies()
        getTrendingShows()
        
        trendingTableView.dataSource = self
        trendingTableView.delegate = self
        trendingTableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Functions getting Data:
    func getTrendingMovies(){
        Client.sharedInstance.getTrendingMovies( { (data: [Entertainment]) -> () in
            self.trendingMovies = data
            self.trending = self.trendingMovies
            self.trendingTableView.reloadData()
            print("succeed")
        }) { (error: NSError) -> () in
            print(error)
        }
    }
    
    func getTrendingShows(){
        Client.sharedInstance.getTrendingShows( { (data: [Entertainment]) -> () in
            self.trendingShows = data
            print("succeed")
        }) { (error: NSError) -> () in
            print(error)
        }
    }
    
    // Functions initiating tableView:
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var count:Int?
        
        count = 0
        
        if tableView == self.trendingTableView {
            if trending != nil {
                count = trending.count
            }
        }
        
        return count!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TrendingCell", forIndexPath: indexPath) as! TrendingCell
        
        cell.trending = trending[indexPath.row]
        
        return cell
        
    }
    
    // Functions for segementedControll
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            trending = trendingMovies
            trendingTableView.reloadData()
        case 1:
            trending = trendingShows
            trendingTableView.reloadData()
        default:
            break;
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let cell = sender as? UITableViewCell{
            
            let indexPath = trendingTableView.indexPathForCell(cell)
            let trendingEntertainment = trending[indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! ItemDetailViewController
            
            detailViewController.entertainment = trendingEntertainment
        }
    }
    
    
}
