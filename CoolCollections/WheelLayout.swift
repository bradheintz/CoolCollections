//
//  WheelLayout.swift
//  CoolCollections
//
//  Created by Brad Heintz on 6/29/15.
//  Copyright (c) 2015 Brad Heintz. All rights reserved.
//

import UIKit


let π = CGFloat(M_PI)
let π_2 = CGFloat(M_PI_2)


class WheelLayout: UICollectionViewFlowLayout {
    
    var wheelCenter : CGPoint {
        get {
            if let cv = self.collectionView {
                return CGPointMake(cv.frame.size.width / 2.0, cv.frame.size.height + 50)
            }
            
            return CGPointZero
        }
    }
    
    var wheelRadius : CGFloat {
        get {
            if let cv = self.collectionView {
                return wheelDiameterToScreenWidthRatio * (cv.frame.size.width / 2.0)
            }
            
            return wheelDiameterToScreenWidthRatio *  (UIScreen.mainScreen().bounds.width / 2.0); // probably right anyway
        }
    }
    
    var cellWidth : CGFloat {
        get {
            return 2.0 * self.wheelRadius * sin(π / CGFloat(numberOfWedges))
        }
    }
    
    var cellHeight : CGFloat {
        get {
            let r = self.wheelRadius
            let w = self.cellWidth
            return sqrt(r * r - w * w / 4.0)
        }
    }
    
    var initialOffset : CGFloat {
        get {
            return self.cellWidth
        }
    }
    

    // MARK: overrides
    
    override func prepareLayout() {
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.itemSize = CGSizeMake(self.cellWidth, 500) // NOTE: height is kludge to make flow layout put all in 1 row
    }
    
    override func collectionViewContentSize() -> CGSize {
        let itemCount = self.collectionView!.numberOfItemsInSection(0)
        return CGSizeMake(self.cellWidth * CGFloat(itemCount), self.collectionView!.frame.size.height)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var attributes = super.layoutAttributesForElementsInRect(rect) as! [UICollectionViewLayoutAttributes]
        if attributes.count == 0 { // should never happen, BUT will crash code below if it does
            return []
        }

        // assumes one section
        let firstRow = attributes.first!.indexPath.row
        if firstRow > 0 {
            var attr = super.layoutAttributesForItemAtIndexPath(NSIndexPath(forRow: firstRow - 1, inSection: 0))
            attributes = [attr] + attributes
        }
        
        let lastRow = attributes.last!.indexPath.row
        let maxIndex = self.collectionView!.dataSource!.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
        if lastRow < maxIndex {
            var attr = super.layoutAttributesForItemAtIndexPath(NSIndexPath(forRow: lastRow + 1, inSection: 0))
            attributes = attributes + [attr]
        }
        
        
        let screenHeight = self.collectionView!.frame.size.height
        let w = self.cellWidth
        let h = self.cellHeight
        for attr in attributes {
            attr.frame.size.width = w
            attr.frame.size.height = h
            self.translateAndRotateAttr(attr)
        }
        
        
        return attributes
    }
    
    
    // MARK: helpers
    
    func translateAndRotateAttr(attr: UICollectionViewLayoutAttributes) {
        let cv = self.collectionView!
        let frameXCenter = CGRectGetMidX(cv.frame)
        let cellXCenterInContentSpace = CGRectGetMidX(attr.frame)
        let cellYCenterInContentSpace = CGRectGetMidY(attr.frame)
        let cellXCenter = cellXCenterInContentSpace - cv.contentOffset.x
        let cellYCenter = cellYCenterInContentSpace - cv.contentOffset.y
        let distanceAlongArc = cellXCenter - frameXCenter
        
        let rotation = distanceAlongArc / self.wheelRadius
        
        attr.transform = CGAffineTransformTranslate(attr.transform, self.wheelCenter.x - cellXCenter, self.wheelCenter.y - cellYCenter)
        attr.transform = CGAffineTransformRotate(attr.transform, rotation)
    }
}
