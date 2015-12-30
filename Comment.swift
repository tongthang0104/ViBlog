//
//  Comment.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import Foundation
import Parse

class Comment: PFObject, PFSubclassing {
    
    //MARK: Properties
    
    @NSManaged var fromUser: User
    @NSManaged var blog: Blog
    @NSManaged var user: PFUser
    @NSManaged var text: String
    
    //MARK: Initializer
    override class func query() -> PFQuery? {
        let query = PFQuery(className: Comment.parseClassName())
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
        return "Comment"
    }
    
    //MARK: Initializer
    
    init(fromUser: User, blog: Blog, text: String) {
        super.init()
        
        self.fromUser = fromUser
        self.blog = blog
        self.text = text
        
    }
    
    override init() {
        super.init()
    }
}