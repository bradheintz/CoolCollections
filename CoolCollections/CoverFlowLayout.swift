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
        self.scrollDirection = .Horizontal
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        // NOTE: Docs say this is already [UICollectionViewLayoutAttributes]? - but header says otherwise
        var attributes = super.layoutAttributesForElementsInRect(rect) as! [UICollectionViewLayoutAttributes]

        for attr in attributes {
            let distance = self.collectionView!.frame.midX - (attr.center.x - self.collectionView!.contentOffset.x)
            let scaledDistance = distance / self.rotationZone
            let boundedScaledDistance = min(max(scaledDistance, -1.0), 1.0)
            attr.transform3D.m34 = -1.0 / (4.0 * self.itemSize.width) // perspective magic
            attr.transform3D = CATransform3DRotate(attr.transform3D, 0.3 * π * boundedScaledDistance, 0, 1.0, 0)
            
            attr.alpha = 1.0 - 0.7 * abs(boundedScaledDistance)
        }

        return attributes
    }

    var rotationZone : CGFloat { // on either side
        get {
            if let cv = self.collectionView {
                return 0.3 * cv.frame.size.width
            } else {
                return 0
            }
        }
    }
}
