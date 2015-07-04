//
//  WheelContainerVC.swift
//  CoolCollections
//
//  Created by Brad Heintz on 7/1/15.
//  Copyright (c) 2015 Brad Heintz. All rights reserved.
//

import UIKit


class WheelContainerVC: UIViewController, WheelDelegate {

    @IBOutlet weak var rockerImage: UIImageView!
    var rockers : [Rocker]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.rockers = Rocker.getCollection()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationWheel = segue.destinationViewController as! WheelCVC
        destinationWheel.wheelDelegate = self
    }

    
    // MARK: WheelDelegate
    func selectionChanged(idx: Int) {
        self.rockerImage.image = self.rockers![idx].photo
    }
}
