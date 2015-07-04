//
//  WheelCVC.swift
//  CoolCollections
//
//  Created by Brad Heintz on 6/28/15.
//  Copyright (c) 2015 Brad Heintz. All rights reserved.
//

import UIKit


class WheelCVC: UICollectionViewController {
    let reuseIdentifier = "WheelCell"
    
    var rockers : [Rocker]?
    var wedgeLayer : CAShapeLayer?
    
    var firstTimeLayingOut : Bool = true
    
    var lastContentOffset : CGFloat = 0
    

    var wheelLayout : WheelLayout {
        get {
            return self.collectionView!.collectionViewLayout as! WheelLayout
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(WheelCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        self.rockers = Rocker.getCollection()
        self.makeWedgeTemplate()
    }
    
    override func viewWillLayoutSubviews() {
        if self.firstTimeLayingOut {
            self.collectionView!.setContentOffset(CGPointMake(self.wheelLayout.initialOffset, 0), animated: false)
            self.lastContentOffset = self.collectionView!.contentOffset.x
            self.firstTimeLayingOut = false
        }
    }

    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let rockers = self.rockers {
            return rockers.count * 2 + 2 * self.wheelLayout.extraWedgesOnEachEnd
        }
        
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! WheelCell

        cell.layer.anchorPoint = CGPointMake(0.5, 1.0) // helps with rotation in layout file
        
        let rockerIndex = self.rockerIndexForRow(indexPath.row)
        let gbPortion = CGFloat(rockerIndex + 1) / CGFloat(self.rockers!.count + 2)
        self.addWedgeToCell(cell, color: UIColor(red: 1.0, green: gbPortion, blue: gbPortion, alpha: 1.0))
        cell.updateCellText(self.rockers![rockerIndex].name)
    
        return cell
    }
    
    func rockerIndexForRow(row : Int) -> Int {
        var rockerIndex = (row - self.wheelLayout.extraWedgesOnEachEnd) % self.rockers!.count
        while rockerIndex < 0 { rockerIndex += self.rockers!.count }
        return rockerIndex
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

    
    // MARK: duplicated with layout file
    // TODO: fix
    var wheelRadius : CGFloat {
        get {
            if let cv = self.collectionView {
                return wheelDiameterToScreenWidthRatio * (cv.frame.size.width / 2.0)
            }
            
            return wheelDiameterToScreenWidthRatio *  (UIScreen.mainScreen().bounds.width / 2.0); // probably right anyway
        }
    }

    
    // MARK: collection view helpers
    
    func makeWedgeTemplate() {
        let r = self.wheelRadius
        let θ = 2.0 * π / CGFloat(numberOfWedges) // angle of a one-twelfth wedge
        let θ_2 = θ / 2.0
        let startAngle = π_2 - θ_2 + π
        let endAngle = π_2 + θ_2 + π
        let arcCenter = CGPointZero

        var arc = UIBezierPath(arcCenter: arcCenter, radius: r, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        arc.lineWidth = 0;
        arc.addLineToPoint(arcCenter)
        arc.closePath()
        
        var wedge = CAShapeLayer()
        wedge.path = arc.CGPath
        wedge.lineWidth = 0

        // self.wedgeHeight = arc.bounds.size.height;
        
        self.wedgeLayer = wedge;
    }
    
    func addWedgeToCell(cell : WheelCell, color : UIColor) {
        if cell.wedgeLayer == nil {
            if self.wedgeLayer == nil {
                self.makeWedgeTemplate()
            }
            
            let copyWedge = CAShapeLayer()
            copyWedge.path = self.wedgeLayer!.path
            copyWedge.lineWidth = 0
            
            cell.wedgeLayer = copyWedge
            cell.layer.addSublayer(copyWedge)
            cell.wedgeLayer!.position = CGPointMake(cell.bounds.size.width / 2, cell.bounds.size.height);
        }
        
        cell.wedgeLayer!.fillColor = color.CGColor
        cell.bringSubviewToFront(cell.label)
    }
    
    
    // MARK: UIScrollViewDelegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        // TODO: send delegate message about currently selected rocker
        self.performCircularScrollTrick()
        // println("\(self.collectionView!.contentSize.width) \(self.collectionView!.contentOffset.x) \(self.wheelLayout.cellWidth)")
        self.lastContentOffset = self.collectionView!.contentOffset.x
    }
    
    
    // MARK: scroll view helpers
    func performCircularScrollTrick() {
        let offset = self.collectionView!.contentOffset.x
        let fullRockerSetWidth = CGFloat(self.rockers!.count) * self.wheelLayout.cellWidth
        if self.firstWedgeIsShowing() && self.nowScrollingRight() {
            self.collectionView!.contentOffset = CGPointMake(offset + fullRockerSetWidth, 0)
        } else if self.lastWedgeIsShowing() && self.nowScrollingLeft() {
            self.collectionView!.contentOffset = CGPointMake(offset - fullRockerSetWidth, 0)
        }
    }
    
    var endCellDetectionWindow : CGFloat {
        get {
            return self.wheelLayout.cellWidth * 2.0 // NOTE: kludge
        }
    }
    
    func firstWedgeIsShowing() -> Bool {
        let offset = self.collectionView!.contentOffset.x
        return offset < self.endCellDetectionWindow
    }
    
    func nowScrollingRight() -> Bool {
        return self.collectionView!.contentOffset.x < self.lastContentOffset
    }
    
    func lastWedgeIsShowing() -> Bool {
        let offset = self.collectionView!.contentOffset.x
        let contentWidth = self.collectionView!.contentSize.width
        let viewWidth = self.collectionView!.frame.size.width
        return offset > (contentWidth - viewWidth - self.endCellDetectionWindow)
    }
    
    func nowScrollingLeft() -> Bool {
        if self.firstTimeLayingOut {
            return false
        }
        return self.collectionView!.contentOffset.x > self.lastContentOffset
    }
}
