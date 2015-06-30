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
            
            return 160.0; // probably right anyway
        }
    }
    
    
    // MARK: overrides
    
    override func prepareLayout() {
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        self.itemSize = CGSizeMake(150, 600)
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    override func collectionViewContentSize() -> CGSize {
        let itemCount = self.collectionView!.numberOfItemsInSection(0)
        return CGSizeMake(CGFloat(150 * itemCount), self.collectionView!.frame.size.height)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var attributes = super.layoutAttributesForElementsInRect(rect) as! [UICollectionViewLayoutAttributes]
        
        let screenHeight = self.collectionView!.frame.size.height
        for attr in attributes {
            //attr.frame.origin.y = screenHeight - 400
            self.rotateAttr(attr)
        }
        
        
        return attributes
    }
    
    
    // MARK: helpers
    
    func rotateAttr(attr: UICollectionViewLayoutAttributes) {
        // if cell center is at view center, that's our 0 - so use cosine
        // radius of the circle is half the width
        // the chord from peak to edge is π * r / 2
        
        let cv = self.collectionView!
        let frameCenter = CGRectGetMidX(cv.frame)
        let cellCenterInContentSpace = CGRectGetMidX(attr.frame)
        let cellCenter = cellCenterInContentSpace - cv.contentOffset.x
        let distanceAlongChord = cellCenter - frameCenter
        
        let quarterChord = π_2 * self.wheelRadius
        let rotation = distanceAlongChord / quarterChord
        
        // TODO: try a translation here
        attr.transform = CGAffineTransformRotate(attr.transform, rotation)
        // TODO: try a translation here
        
        println("distanceAlongChord for \(attr.indexPath.row): \(distanceAlongChord)")
    }
}
