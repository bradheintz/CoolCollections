//
//  VariableHeightCVC.swift
//  CoolCollections
//
//  Created by Brad Heintz on 6/28/15.
//  Copyright (c) 2015 Brad Heintz. All rights reserved.
//

import UIKit


class VariableHeightCVC: UICollectionViewController {
    let reuseIdentifier = "VHCell"

    var rockers : [Rocker]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        let cellXib = UINib(nibName: "VariableHeightCell", bundle: nil)
        self.collectionView!.registerNib(cellXib, forCellWithReuseIdentifier: reuseIdentifier)

        self.rockers = Rocker.getCollection()
    }

    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let rockers = self.rockers {
            return rockers.count
        }
        
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! VariableHeightCell
    
        cell.configureWithRocker(self.rockers![indexPath.row])
        
        return cell
    }

    
    // MARK: UIScrollViewDelegate
    
    /*
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        println("contentOffset \(scrollView.contentOffset.y)")
    }
    */
}
