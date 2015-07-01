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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(WheelCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        self.rockers = Rocker.getCollection()
        self.makeWedgeTemplate()
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! WheelCell

        // cell.backgroundColor = UIColor(white: 0.1 * CGFloat(indexPath.row + 1), alpha: 1.0)
        cell.layer.anchorPoint = CGPointMake(0.5, 1.0)
        
        let gbPortion = CGFloat(indexPath.row + 1) / CGFloat(rockers!.count + 2)
        self.addWedgeToCell(cell, color: UIColor(red: 1.0, green: gbPortion, blue: gbPortion, alpha: 1.0))
    
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

    
    // MARK: helpers
    
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
        if let cellWedge = cell.wedgeLayer {
            // TODO: color
            return; // our work here is done
        }
        
        if let templateWedge = self.wedgeLayer {
            let copyWedge = CAShapeLayer()
            copyWedge.path = templateWedge.path
            // TODO: color
            copyWedge.fillColor = color.CGColor
            copyWedge.lineWidth = 0
            
            cell.wedgeLayer = copyWedge
            cell.layer.addSublayer(copyWedge)
            cell.wedgeLayer!.position = CGPointMake(cell.bounds.size.width / 2, cell.bounds.size.height);
        }
    }
}
