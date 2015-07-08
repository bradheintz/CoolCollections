//
//  CoverFlowCell.swift
//  CoolCollections
//
//  Created by bradheintz on 7/8/15.
//  Copyright (c) 2015 Brad Heintz. All rights reserved.
//

import UIKit

class CoverFlowCell: UICollectionViewCell {

    @IBOutlet weak var myImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureWithRocker(rocker : Rocker) {
        self.myImage.image = rocker.photo
    }

}
