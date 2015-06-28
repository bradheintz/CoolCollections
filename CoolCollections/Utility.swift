//
//  Utility.swift
//  CoolCollections
//
//  Created by Brad Heintz on 6/28/15.
//  Copyright (c) 2015 Brad Heintz. All rights reserved.
//

class Utility {
    class func classNameAsString(obj: Any) -> String {
        //prints more readable results for dictionaries, arrays, Int, etc
        return _stdlib_getDemangledTypeName(obj).componentsSeparatedByString(".").last!
    }
}
