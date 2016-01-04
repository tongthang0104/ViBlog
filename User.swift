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
    @NSManaged var blog: [Blog]
    
   
//    override class func query() -> PFQuery? {
//        let query = User.query()
//        query?.includeKey("Blog")
//
//        //        query.includeKey("comment")
//        ////        query.includeKey("like")
//        return query
//    }
    init(blog: [Blog] = []) {
        super.init()
        self.blog = blog
    }
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
