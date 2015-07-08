//
//  BottomPinnedVHLayout.swift
//  CoolCollections
//
//  Created by Brad Heintz on 7/7/15.
//  Copyright (c) 2015 Brad Heintz. All rights reserved.
//

import UIKit


class BottomPinnedVHLayout: UICollectionViewFlowLayout {
    
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
        return CGSizeMake(self.collectionView!.frame.size.width, CGFloat(self.itemCount) * hMax)
    }
 
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint) -> CGPoint {
            return proposedContentOffset
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
        let viewportTop = self.collectionView!.contentOffset.y + navHeight
        let viewportBottom = viewportTop + self.collectionView!.frame.size.height
        
        let bottomOfLastCellInUnpinnedMode = self.bottomOfLastCellInUnpinnedModeForViewportTop(viewportTop)
        let isPinningToBottom = (bottomOfLastCellInUnpinnedMode <= viewportBottom)

        for attr in attributes {
            var cellHeight : CGFloat
            var cellTop : CGFloat

            let maxPossibleCellTop = CGFloat(attr.indexPath.row) * hMax

            if isPinningToBottom {
                let indexFromBottom = self.itemCount - attr.indexPath.row - 1
                
                if maxPossibleCellTop <= viewportTop { // fully expanded by virtue of being above viewport
                    cellTop = maxPossibleCellTop
                    cellHeight = hMax + 1
                } else { // fit everything into space from heightOfAllMaxedCells to viewportBottom
                    let minPossibleHeightForAllCellsBelow = CGFloat(indexFromBottom) * hMin
                    let maxPossibleHeightForAllCellsAbove = CGFloat(attr.indexPath.row) * hMax
                    let spaceThisCellCouldBeIn = (viewportBottom - minPossibleHeightForAllCellsBelow) - maxPossibleHeightForAllCellsAbove
                    if spaceThisCellCouldBeIn >= hMax { // max out, because we have that much room
                        cellTop = maxPossibleCellTop
                        cellHeight = hMax + 1
                    } else if spaceThisCellCouldBeIn <= hMin { // crammed in, minimize
                        cellTop = viewportBottom - CGFloat(indexFromBottom + 1) * hMin
                        cellHeight = hMin
                    } else { // in between
                        cellTop = maxPossibleCellTop
                        cellHeight = viewportBottom - minPossibleHeightForAllCellsBelow - maxPossibleHeightForAllCellsAbove
                    }
                }
            } else {
                if maxPossibleCellTop <= viewportTop { // maximized
                    cellTop = maxPossibleCellTop
                    cellHeight = hMax
                } else if maxPossibleCellTop < (viewportTop + hMax) { // expanding
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
            }
            
            attr.frame = CGRectMake(attr.frame.origin.x, cellTop, attr.size.width, cellHeight)
        }
        
        return attributes
    }
    
    func bottomOfLastCellInUnpinnedModeForViewportTop(viewportTop : CGFloat) -> CGFloat {
        let maxHeightCellCount = Int(ceil(viewportTop / hMax))
        let heightOfAllMaxedCells = hMax * CGFloat(maxHeightCellCount)
        
        let topOfExpandingCellInViewport = heightOfAllMaxedCells - viewportTop
        let heightOfExpandingCell = self.scaledHeightForOffset(topOfExpandingCellInViewport)
        
        let minHeightCellCount = (self.itemCount - 1) - maxHeightCellCount - 1
        let heightOfMinCellsAboveMe = CGFloat(minHeightCellCount) * hMin
        
        let cellTop = heightOfAllMaxedCells + heightOfExpandingCell + heightOfMinCellsAboveMe
        
        return cellTop + hMin
    }

    // NOTE: height scales linearly from min to max over scaling region
    func scaledHeightForOffset(offset : CGFloat) -> CGFloat {
        let scalingFactor = 1.0 - offset / hMax
        return hMin + deltaH * scalingFactor
    }

    var itemCount : Int {
        get {
            return self.collectionView!.numberOfItemsInSection(0)
        }
    }
}
