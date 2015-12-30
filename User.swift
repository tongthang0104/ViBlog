//
//  User.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import Foundation
import Parse

class User: PFUser {
 

    //MARK: Initializer
    

    
    override init() {
        super.init()
    }
    
    //MARK: Initializer
    class func initalize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
}
