//
//  CoverFlowVC.swift
//  CoolCollections
//
//  Created by bradheintz on 7/8/15.
//  Copyright (c) 2015 Brad Heintz. All rights reserved.
//

import UIKit

class CoverFlowVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let reuseIdentifier = "CFCell"

    @IBOutlet weak var collectionView: UICollectionView!
    
    var rockers : [Rocker]?
    var otherLayout : UICollectionViewLayout?

    override func viewDidLoad() {
        super.viewDidLoad()

        let cellXib = UINib(nibName: "CoverFlowCell", bundle: nil)
        self.collectionView!.registerNib(cellXib, forCellWithReuseIdentifier: reuseIdentifier)

        self.rockers = Rocker.getCollection()

        self.otherLayout = CoverFlowLayout()

        self.addLayoutToggle()
    }

    func addLayoutToggle() {
        var toggleButtonItem = UIBarButtonItem(title: "Toggle Layout", style: .Plain, target: self, action: "toggleLayout")
        self.navigationItem.rightBarButtonItem = toggleButtonItem
    }

    func toggleLayout() {
        let dummyLayout = otherLayout!
        self.otherLayout = self.collectionView.collectionViewLayout
        self.collectionView.collectionViewLayout = dummyLayout
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
}
