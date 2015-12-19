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
    
    @NSManaged var username: String
    @NSManaged var blogID: String
    @NSManaged var user: PFUser

    
    override class func query() -> PFQuery? {
        let query = PFQuery(className: Like.parseClassName())
        query.includeKey("user")
        query.orderByDescending("createdAt")
        query.includeKey("blogID")
        
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
    
    init(username: String, blogID: String, user: User) {
        super.init()
        
        self.username = username
        self.blogID = blogID
        self.user = user
   
    }
    
    override init() {
        super.init()
    }
}

