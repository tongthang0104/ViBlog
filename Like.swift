//
//  Like.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import Foundation
import Parse

class Like: PFObject, PFSubclassing {
    
    //MARK: Properties
    
    @NSManaged var fromUser: User
    @NSManaged var blog: Blog
//    @NSManaged var user: PFUser

    override class func query() -> PFQuery? {
        let query = PFQuery(className: Like.parseClassName())
        query.includeKey("fromUser")
        query.orderByDescending("createdAt")
        query.includeKey("blog")
        
        return query
    }
    
    class func initalize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    class func parseClassName() -> String {
        return "Like"
    }

    //MARK: Initializer
    
    init(fromUser: User, blog: Blog) {
        super.init()
        
        self.fromUser = fromUser
        self.blog = blog
   
    }
    
    
    
    override init() {
        super.init()
    }
}

