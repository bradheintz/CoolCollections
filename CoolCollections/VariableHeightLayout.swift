//
//  VariableHeightLayout.swift
//  CoolCollections
//
//  Created by Brad Heintz on 6/28/15.
//  Copyright (c) 2015 Brad Heintz. All rights reserved.
//

import UIKit

class VariableHeightLayout: UICollectionViewFlowLayout {

    let hMin : CGFloat = 100
    let hMax : CGFloat = 200
    var deltaH : CGFloat {
        return hMax - hMin
    }
    
    // YOLO: hard-coded nav bar height
    let navHeight : CGFloat = 64.0
    
    override func prepareLayout() {
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        self.itemSize = CGSizeMake(self.collectionView!.frame.size.width, hMax)
    }
    
    override func collectionViewContentSize() -> CGSize {
        let itemCount = self.collectionView!.numberOfItemsInSection(0)
        let h : CGFloat = CGFloat(itemCount - 1) * hMax + self.collectionView!.frame.size.height - navHeight
        return CGSizeMake(self.collectionView!.frame.size.width, h)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        // TODO: do this better - only figure out visible elements
        let wholeSize = self.collectionViewContentSize()
        let layoutRect = CGRectMake(0, 0, wholeSize.width, wholeSize.height)
        
        // NOTE: Docs say this is already [UICollectionViewLayoutAttributes]? - but header says otherwise
        var attributes = super.layoutAttributesForElementsInRect(layoutRect) as! [UICollectionViewLayoutAttributes]
        
        // NOTE: top of visible portion of collection
        var viewportTop = self.collectionView!.contentOffset.y + navHeight
        
        for attr in attributes {
            var cellHeight : CGFloat
            var cellTop : CGFloat
            
            var maxPossibleCellTop = CGFloat(attr.indexPath.row) * hMax
            
            if (maxPossibleCellTop <= viewportTop) { // maximized
                cellTop = maxPossibleCellTop
                cellHeight = hMax
            } else if (maxPossibleCellTop < (viewportTop + hMax)) { // expanding
                cellTop = maxPossibleCellTop
                cellHeight = self.scaledHeightForOffset(cellTop - viewportTop)
            } else { // minimized
                let maximizedCellCount = Int(ceil(viewportTop / hMax)) // WAT: how does ceil not return Int?
                let heightOfMaxedCells = CGFloat(maximizedCellCount) * hMax
                
                let offsetOfExpandingCell = heightOfMaxedCells - viewportTop
                let heightOfExpandingCell = self.scaledHeightForOffset(offsetOfExpandingCell)
                
                let minimizedCellsAboveMeCount = attr.indexPath.row - maximizedCellCount - 1
                let heightOfMinimizedCellsAbove = CGFloat(minimizedCellsAboveMeCount) * hMin
                
                cellTop = heightOfMaxedCells + heightOfExpandingCell + heightOfMinimizedCellsAbove
                cellHeight = hMin
            }
            
            attr.frame = CGRectMake(attr.frame.origin.x, cellTop, attr.size.width, cellHeight)
        }
        
        // self.dumpAttrs(attributes)
        return attributes
    }

    
    // MARK: layout helpers
    
    // NOTE: height scales linearly from min to max over scaling region
    func scaledHeightForOffset(offset : CGFloat) -> CGFloat {
        let scalingFactor = 1.0 - offset / hMax
        return hMin + deltaH * scalingFactor
    }
    
    
    // MARK: debugging
    func dumpAttr(attr : UICollectionViewLayoutAttributes) {
        println("\(attr.indexPath.row) : (\(attr.frame.origin.x), \(attr.frame.origin.y)) ; \(attr.frame.size.width) x \(attr.frame.size.height)")
    }
    
    func dumpAttrs(attrs : [UICollectionViewLayoutAttributes]) {
        for attr in attrs {
            self.dumpAttr(attr)
        }
    }
}
