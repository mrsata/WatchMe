//
//  CollectionViewController.swift
//  WatchMe
//
//  Created by Labuser on 3/22/16.
//  Copyright © 2016 Grace. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate{

    @IBOutlet weak var collectionView: UICollectionView!

    
    var collection: [Entertainment]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        Client.sharedInstance.getCollection({ (entertainment: [Entertainment]) -> () in
            
            self.collection = entertainment
            self.collectionView.reloadData()
            }) { (error: NSError) -> () in
                
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if(collection != nil)
        {
            print(collection.count)
            return collection.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! CollectionViewCell
        
        let entertainment = collection![indexPath.row]
        print("I got here!")
        print(entertainment)
        
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
