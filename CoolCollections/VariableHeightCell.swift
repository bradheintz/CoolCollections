//
//  VariableHeightCell.swift
//  CoolCollections
//
//  Created by Brad Heintz on 6/28/15.
//  Copyright (c) 2015 Brad Heintz. All rights reserved.
//

import UIKit

class VariableHeightCell: UICollectionViewCell {

    // NOTE: This is duplicated with VariableHeightLayout, and that is horrible.
    // Are height bounds an attribute of the cell type or the layout?
    let hMin : CGFloat = 100
    let hMax : CGFloat = 200
    var deltaH : CGFloat {
        return hMax - hMin
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var photoScrim: UIView!
    
    func configureWithRocker(rocker : Rocker) {
        self.titleLabel.text = rocker.name
        self.subtitleLabel.text = rocker.band
        self.photoView.image = rocker.photo
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        super.applyLayoutAttributes(layoutAttributes)
        
        let scalingFactor = (layoutAttributes.frame.size.height - hMin) / deltaH
        
        self.subtitleLabel.alpha = scalingFactor
        
        let textColor = UIColor(white: scalingFactor, alpha: 1.0)
        self.titleLabel.textColor = textColor
        self.subtitleLabel.textColor = textColor
        
        self.photoScrim.alpha = 0.75 - 0.75 * scalingFactor
    }
}
