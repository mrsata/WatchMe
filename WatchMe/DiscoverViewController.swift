//
//  DiscoverViewController.swift
//  WatchMe
//
//  Created by Labuser on 3/22/16.
//  Copyright © 2016 Grace. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var trendingTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var pageControl: UIPageControl!
    var frame: CGRect = CGRectMake(0, 0, 0, 0)
    var trending: [Entertainment]!
    var trendingMovies: [Entertainment]!
    var trendingShows:  [Entertainment]!
    var subViews: [UIImageView]! = []
    var topIndexs: [Int]! = [0,1,2,3,4]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getTrendingMovies()
        getTrendingShows()
        
        // Initiate scrollView:
        scrollView.delegate = self
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 7, scrollView.frame.size.height)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        for index in 0..<7 {
            frame.origin.x = self.view.frame.size.width * CGFloat(index)
            frame.size = CGSizeMake(self.view.frame.size.width, scrollView.frame.size.height)
            scrollView.pagingEnabled = true
            let subView = UIImageView(frame: frame)
            subViews.append(subView)
            scrollView.addSubview(subViews[index])
        }
        
        configurePageControl()
        pageControl.addTarget(self, action: Selector("changePage:"), forControlEvents: UIControlEvents.ValueChanged)
        
        // Initiate trendingTableView:
        trendingTableView.dataSource = self
        trendingTableView.delegate = self
        view.bringSubviewToFront(trendingTableView)
        
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
            self.reloadScrollViewData()
            self.scrollView.setContentOffset(CGPointMake(self.view.frame.size.width, 0), animated: true)
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
    
    
    // Functions supporting scrollView:
    func configurePageControl() {
        self.pageControl = UIPageControl(frame: CGRectMake(0,scrollView.frame.origin.y + scrollView.frame.height - 25,self.view.frame.size.width, 25))
        self.pageControl.numberOfPages = 5
        self.pageControl.currentPage = 0
        self.view.addSubview(pageControl)
    }
    
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * self.view.frame.size.width
        scrollView.setContentOffset(CGPointMake(x, 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if let scrollView = self.scrollView{
            var pageNumber = Int(round(scrollView.contentOffset.x / self.view.frame.size.width)) - 1
            if(pageControl.currentPage == 4 && pageNumber == 5){
                pageNumber = 0
                scrollView.setContentOffset(CGPointMake(self.view.frame.size.width, 0), animated: false)
            } else if(pageControl.currentPage == 0 && pageNumber == -1){
                pageNumber = 4
                scrollView.setContentOffset(CGPointMake(self.view.frame.size.width * 5, 0), animated: false)
            }
            pageControl.currentPage = Int(pageNumber)
        }
    }

    func reloadScrollViewData() {
        
        for index in 0..<5 {
            var i:Int
            if(index==0){
                i = topIndexs[index]
            } else {
                i = topIndexs[index-1] + 1
            }
            while(self.trending[i].thumbImageUrl == nil){
                i += 1
            }
            topIndexs[index] = i
            let imageUrl:NSURL = self.trending[i].thumbImageUrl!
            self.subViews[index + 1].setImageWithURL(imageUrl)
            if(index==0){
                self.subViews[6].setImageWithURL(imageUrl)
            } else if(index==4){
                self.subViews[0].setImageWithURL(imageUrl)
            }
        }
    }
    
    // Functions supporting tableView:
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
            reloadScrollViewData()
            scrollView.setContentOffset(CGPointMake(self.view.frame.size.width, 0), animated: false)
            pageControl.currentPage = 0
        case 1:
            trending = trendingShows
            trendingTableView.reloadData()
            reloadScrollViewData()
            scrollView.setContentOffset(CGPointMake(self.view.frame.size.width, 0), animated: false)
            pageControl.currentPage = 0
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
        
        if let gesture = sender as? UITapGestureRecognizer{
            
            let index = topIndexs[pageControl.currentPage]
            let trendingEntertainment = trending[index]
            
            let detailViewController = segue.destinationViewController as! ItemDetailViewController
            
            detailViewController.entertainment = trendingEntertainment
        }
        
    }
    
    
}
