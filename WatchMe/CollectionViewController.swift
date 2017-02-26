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
        
        let frame = self.view.frame
        let backgroundImageView = UIImageView(frame: frame)
        backgroundImageView.image = UIImage(named: "BG")
        backgroundImageView.alpha = 0.6
        self.view.insertSubview(backgroundImageView, at: 0)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear

    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if(collection != nil)
        {
            return collection.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        
        cell.entertainment = collection![indexPath.row]            
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let cell = sender as! UICollectionViewCell
        
        let indexPath = collectionView.indexPath(for: cell)
        let movie = collection[indexPath!.row]
        
        let detailViewController = segue.destination as! ItemDetailViewController
        
        detailViewController.entertainment = movie
    }
    

}
