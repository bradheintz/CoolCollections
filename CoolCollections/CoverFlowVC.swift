//
//  CoverFlowVC.swift
//  CoolCollections
//
//  Created by bradheintz on 7/8/15.
//  Copyright (c) 2015 Brad Heintz. All rights reserved.
//

import UIKit

class CoverFlowVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let reuseIdentifier = "CFCell"

    @IBOutlet weak var collectionView: UICollectionView!
    
    var rockers : [Rocker]?
    var otherLayout : UICollectionViewLayout?

    override func viewDidLoad() {
        super.viewDidLoad()

        let cellXib = UINib(nibName: "CoverFlowCell", bundle: nil)
        self.collectionView!.registerNib(cellXib, forCellWithReuseIdentifier: reuseIdentifier)

        self.rockers = Rocker.getCollection()

        var basicLayout = UICollectionViewFlowLayout()
        basicLayout.scrollDirection = .Horizontal
        self.collectionView.collectionViewLayout = basicLayout
        self.otherLayout = CoverFlowLayout()

        self.addLayoutToggle()
    }

    func addLayoutToggle() {
        var toggleButtonItem = UIBarButtonItem(title: "Toggle Layout", style: .Plain, target: self, action: "toggleLayout")
        self.navigationItem.rightBarButtonItem = toggleButtonItem
    }

    func toggleLayout() {
        let dummyLayout = self.otherLayout!
        self.otherLayout = self.collectionView.collectionViewLayout
        self.collectionView.collectionViewLayout = dummyLayout
        UIView.animateWithDuration(0.5, animations: {
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    

    // MARK: - UICollectionViewDataSource

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let rockers = self.rockers {
            return rockers.count
        }

        return 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CoverFlowCell

        cell.configureWithRocker(self.rockers![indexPath.row])

        return cell
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    let cellWidth : CGFloat = 200
    let cellHeight : CGFloat = 150
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(cellWidth, cellHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let sideInset : CGFloat = (self.collectionView!.frame.width - cellWidth) / 2.0
            return UIEdgeInsetsMake(0, sideInset, 0, sideInset)
        }
        
        return UIEdgeInsetsZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 30
    }
}
