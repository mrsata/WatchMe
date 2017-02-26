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
    
    var headerView: UIView!
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var scrollTimer: Timer!
    var frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var trending: [Entertainment]!
    var trendingMovies: [Entertainment]!
    var trendingShows:  [Entertainment]!
    var subViews: [UIImageView]! = []
    var topIndexs: [Int]! = [0,1,2,3,4]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        let logoItem = UIBarButtonItem()
//        logoItem.image = UIImage(named:"watchme")
//        navigationItem.leftBarButtonItem = logoItem
        let backgroundImageViewFrame = self.view.frame
        let backgroundImageView = UIImageView(frame: backgroundImageViewFrame)
        backgroundImageView.image = UIImage(named: "BG")
        backgroundImageView.alpha = 0.4
        self.view.insertSubview(backgroundImageView, at: 0)
        getTrendingMovies()
        getTrendingShows()
        
        // Initiate scrollView:
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.frame.size = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.width * 0.562)
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * 7, height: scrollView.frame.size.height)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        for index in 0..<7 {
            frame.origin.x = self.view.frame.size.width * CGFloat(index)
            frame.size = CGSize(width: self.view.frame.size.width, height: scrollView.frame.size.height)
            scrollView.isPagingEnabled = true
            let subView = UIImageView(frame: frame)
            subViews.append(subView)
            scrollView.addSubview(subViews[index])
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(DiscoverViewController.pushItem(_:)))
        scrollView.addGestureRecognizer(gesture)
        
        // Initiate trendingTableView:
        trendingTableView.dataSource = self
        trendingTableView.delegate = self
        trendingTableView.showsVerticalScrollIndicator = false
        headerView = UIView(frame: frame)
        trendingTableView.sectionHeaderHeight = scrollView.frame.height
        trendingTableView.tableHeaderView = headerView
        headerView.addSubview(scrollView)
        trendingTableView.bounces = false
        trendingTableView.backgroundColor = UIColor.clear
        
        // Initiate pageControl:
        configurePageControl()
        pageControl.addTarget(self, action: #selector(DiscoverViewController.changePage(_:)), for: UIControlEvents.valueChanged)
        
        // Initiate timer:
        scrollTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(DiscoverViewController.autoScroll(_:)), userInfo: nil, repeats: true)
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
            self.scrollView.setContentOffset(CGPoint(x: self.view.frame.size.width, y: 0), animated: true)
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
        pageControl = UIPageControl(frame: CGRect(x: 0, y: headerView.frame.height - 25, width: headerView.frame.width, height: 25))
        pageControl.numberOfPages = 5
        pageControl.currentPage = 0
        headerView.addSubview(pageControl)
    }
    
    func changePage(_ sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * self.view.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let scrollView = self.scrollView{
            var pageNumber = Int(round(scrollView.contentOffset.x / self.view.frame.size.width)) - 1
            if(pageControl.currentPage == 4 && pageNumber == 5){
                pageNumber = 0
                scrollView.setContentOffset(CGPoint(x: self.view.frame.size.width, y: 0), animated: false)
            } else if(pageControl.currentPage == 0 && pageNumber == -1){
                pageNumber = 4
                scrollView.setContentOffset(CGPoint(x: self.view.frame.size.width * 5, y: 0), animated: false)
            }
            pageControl.currentPage = Int(pageNumber)
            resetTimer()
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
//            while(self.trending[i].thumbImageUrl == nil){
//                i += 1
//            }
//            topIndexs[index] = i
//            let imageUrl:URL = self.trending[i].thumbImageUrl! as URL
            let noImageUrl: URL = URL(string: "http://1vyf1h2a37bmf88hy3i8ce9e.wpengine.netdna-cdn.com/wp-content/themes/public/img/noimgavailable.jpg")!
            let imageUrl:URL = noImageUrl
            //
            self.subViews[index + 1].setImageWith(imageUrl)
            if(index==0){
                self.subViews[6].setImageWith(imageUrl)
            } else if(index==4){
                self.subViews[0].setImageWith(imageUrl)
            }
        }
    }
    
    func autoScroll(_ sender: AnyObject) -> (){
        let x = scrollView.contentOffset.x + self.view.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        var pageNumber = pageControl.currentPage + 1
        if(pageControl.currentPage == 4 && pageNumber == 5){
            pageNumber = 0
            scrollView.setContentOffset(CGPoint(x: self.view.frame.size.width, y: 0), animated: false)
        } else if(pageControl.currentPage == 0 && pageNumber == -1){
            pageNumber = 4
            scrollView.setContentOffset(CGPoint(x: self.view.frame.size.width * 5, y: 0), animated: false)
        }
        pageControl.currentPage = Int(pageNumber)
    }
    
    func resetTimer(){
        scrollTimer.invalidate()
        scrollTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(DiscoverViewController.autoScroll(_:)), userInfo: nil, repeats: true)
    }
    
    func pushItem(_ gesture: UIGestureRecognizer){
        self.performSegue(withIdentifier: "pushItem", sender: gesture)
    }
    
    // Functions supporting tableView:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingCell", for: indexPath) as! TrendingCell
        
        cell.trending = trending[indexPath.row]
        cell.backgroundColor = UIColor.clear
        
        return cell
        
    }

    // Functions for segementedControll
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            trending = trendingMovies
            trendingTableView.reloadData()
            trendingTableView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
            reloadScrollViewData()
            scrollView.setContentOffset(CGPoint(x: self.view.frame.size.width, y: 0), animated: false)
            pageControl.currentPage = 0
        case 1:
            trending = trendingShows
            trendingTableView.reloadData()
            trendingTableView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
            reloadScrollViewData()
            scrollView.setContentOffset(CGPoint(x: self.view.frame.size.width, y: 0), animated: false)
            pageControl.currentPage = 0
        default:
            break;
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let cell = sender as? TrendingCell{
            
            cell.isSelected = false
            
            let indexPath = trendingTableView.indexPath(for: cell)
            let trendingEntertainment = trending[indexPath!.row]
            
            let detailViewController = segue.destination as! ItemDetailViewController
            
            detailViewController.entertainment = trendingEntertainment
        }
        
        if (segue.identifier == "pushItem"){
            
            let index = topIndexs[pageControl.currentPage]
            let trendingEntertainment = trending[index]
            
            let detailViewController = segue.destination as! ItemDetailViewController
            
            detailViewController.entertainment = trendingEntertainment
        }
        
    }
    
    
}
