//
//  Blog.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import Foundation
import UIKit
import Parse

class Blog: PFObject, PFSubclassing {
    
    //MARK: Properties
    
    @NSManaged var video: PFFile
    @NSManaged var user: PFUser
    @NSManaged var caption: String?
//    @NSManaged var comments: String?

    override class func query() -> PFQuery? {
        let query = PFQuery(className: Blog.parseClassName())
        query.includeKey("user")
        query.orderByDescending("createdAt")

        return query
    }
    
    //MARK: Initializer
    
    class func parseClassName() -> String {
        return "Blog"
    }
    class func initalize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    init(video: PFFile, user: PFUser, caption: String?) {
        super.init()
        
        self.video = video
        self.caption = caption
        self.user = user

    }
    
    override init() {
        super.init()
    }
}
