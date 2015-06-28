//
//  Rocker.swift
//  CoolCollections
//
//  Created by Brad Heintz on 6/28/15.
//  Copyright (c) 2015 Brad Heintz. All rights reserved.
//

import UIKit

class Rocker {
    let name, band : String
    // let photo : UIImage?
    
    init(name : String, band : String/*, photo : UIImage*/) {
        self.name = name
        self.band = band
        // self.photo = photo
    }
    
    class func getCollection() -> [Rocker] {
        var collection : [Rocker] = []
        
        collection.append(Rocker(name: "Janis Joplin", band: "Big Brother and the Holding Company"/*, photo: nil*/))
        collection.append(Rocker(name: "Ann Wilson", band: "Heart"))
        collection.append(Rocker(name: "Nancy Wilson", band: "Heart"))
        collection.append(Rocker(name: "Joan Jett", band: "The Blackhearts"))
        collection.append(Rocker(name: "Chrissy Hynde", band: "The Pretenders"))
        collection.append(Rocker(name: "Grace Slick", band: "Jefferson Airplane"))
        collection.append(Rocker(name: "Christine McVie", band: "Fleetwood Mac"))
        collection.append(Rocker(name: "Stevie Nicks", band: "Fleetwood Mac"))
        
        return collection;
    }
}