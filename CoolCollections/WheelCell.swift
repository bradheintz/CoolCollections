//
//  WheelCell.swift
//  CoolCollections
//
//  Created by Brad Heintz on 6/29/15.
//  Copyright (c) 2015 Brad Heintz. All rights reserved.
//

import UIKit

class WheelCell: UICollectionViewCell {
    
    var wedgeLayer : CAShapeLayer?
    var label : UILabel

    override init(frame: CGRect) {
        let labelHeight : CGFloat = 20.0
        let x : CGFloat = 0//frame.size.width / 2.0
        let y : CGFloat = 0-labelHeight / 2.0
        let w : CGFloat = frame.size.height * 0.75
        let h : CGFloat = 21.0
        self.label = UILabel(frame: CGRectMake(x, y, w, h))
        self.label.font = UIFont.systemFontOfSize(16, weight: UIFontWeightBold)
        self.label.layer.anchorPoint = CGPointMake(0.0, -0.5)
        self.label.layer.setAffineTransform(CGAffineTransformRotate(self.label.transform, 90.0 * CGFloat(M_PI) / 180.0))
        
        super.init(frame: frame)
        
        self.addSubview(self.label)
    }

    required init(coder aDecoder: NSCoder) {
        self.label = UILabel(frame:CGRectZero)
        super.init(coder: aDecoder)
    }

    func updateCellText(newText: String) {
        self.label.text = newText
    }
}
