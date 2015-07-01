//
//  WheelLayout.swift
//  CoolCollections
//
//  Created by Brad Heintz on 6/29/15.
//  Copyright (c) 2015 Brad Heintz. All rights reserved.
//

import UIKit


class WheelLayout: UICollectionViewFlowLayout {
    
    let π = CGFloat(M_PI)
    let π_2 = CGFloat(M_PI_2)
    
    var wheelCenter : CGPoint {
        get {
            if let cv = self.collectionView {
                return CGPointMake(cv.frame.size.width / 2.0, cv.frame.size.height + 0)
            }
            
            return CGPointZero
        }
    }
    
    var wheelRadius : CGFloat {
        get {
            if let cv = self.collectionView {
                return cv.frame.size.width / 2.0
            }
            
            return UIScreen.mainScreen().bounds.width / 2.0; // probably right anyway
        }
    }
    
    var cellWidth : CGFloat {
        get {
            return 2.0 * self.wheelRadius * sin(π / 12.0)
        }
    }
    
    var cellHeight : CGFloat {
        let r = self.wheelRadius
        let w = self.cellWidth
        return sqrt(r * r - w * w / 4.0)
    }
    
    // MARK: overrides
    
    override func prepareLayout() {
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.itemSize = CGSizeMake(self.cellWidth, 600) // height is kludge to make flow layout put all in 1 row
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
        let distanceAlongChord = cellXCenter - frameXCenter
        println("cell \(attr.indexPath.row): contentX \(cellXCenterInContentSpace)  frameX \(cellXCenter)  contentOffset = \(cv.contentOffset.x)")
        
        let rotation = distanceAlongChord / self.wheelRadius
        
        attr.transform = CGAffineTransformTranslate(attr.transform, self.wheelCenter.x - cellXCenter, self.wheelCenter.y - cellYCenter)
        attr.transform = CGAffineTransformRotate(attr.transform, rotation)
    }
}
