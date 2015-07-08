//
//  CoverFlowLayout.swift
//  CoolCollections
//
//  Created by bradheintz on 7/8/15.
//  Copyright (c) 2015 Brad Heintz. All rights reserved.
//

import UIKit


class CoverFlowLayout: UICollectionViewFlowLayout {

    override func prepareLayout() {
        self.minimumInteritemSpacing = 30
        self.minimumLineSpacing = 10
        self.itemSize = CGSizeMake(200, 150)
        self.scrollDirection = .Horizontal
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        // NOTE: Docs say this is already [UICollectionViewLayoutAttributes]? - but header says otherwise
        var attributes = super.layoutAttributesForElementsInRect(rect) as! [UICollectionViewLayoutAttributes]

        println("\(NSDate()) \(self.collectionView!.contentOffset.x))")
        for attr in attributes {
            let distance = (rect.midX - self.collectionView!.contentOffset.x) - attr.center.x
            let scaledDistance = distance / self.rotationZone
            let boundedScaledDistance = min(max(scaledDistance, -1.0), 1.0)
            println("\(attr.indexPath.row) \(distance) \(scaledDistance) \(boundedScaledDistance) \(attr.frame)")
            attr.transform3D.m34 = -1.0 / (3.0 * self.itemSize.width) // perspective magic
            attr.transform3D = CATransform3DRotate(attr.transform3D, 0.4 * π * boundedScaledDistance, 0, 1.0, 0)
        }

        return attributes
    }

    var rotationZone : CGFloat {
        get {
            if let cv = self.collectionView {
                return 0.3 * cv.frame.size.width
            } else {
                return 0
            }
        }
    }
}
