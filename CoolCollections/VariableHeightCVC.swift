//
//  VariableHeightCVC.swift
//  CoolCollections
//
//  Created by Brad Heintz on 6/28/15.
//  Copyright (c) 2015 Brad Heintz. All rights reserved.
//

import UIKit

let reuseIdentifier = "VHCell"

class VariableHeightCVC: UICollectionViewController {

    var rockers : [Rocker]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // self.collectionView!.registerClass(VariableHeightCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let cellXib = UINib(nibName: "VariableHeightCell", bundle: nil)
        self.collectionView!.registerNib(cellXib, forCellWithReuseIdentifier: reuseIdentifier)

        self.rockers = Rocker.getCollection()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

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
    
        // TODO: replace this crap with actual cell init
        let x = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section) - indexPath.row
        let backgroundTint = CGFloat(x) * 0.1
        cell.backgroundColor = UIColor(white: backgroundTint, alpha: 1.0)
        
        cell.configureWithRocker(self.rockers![indexPath.row])
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

    // MARK: UIScrollViewDelegate
    
    /*
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        println("contentOffset \(scrollView.contentOffset.y)")
    }
    */
}
