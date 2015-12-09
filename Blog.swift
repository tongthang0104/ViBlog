//
//  Blog.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import Foundation
import UIKit

class Blog: PFObject, PFSubclassing {
    
    //MARK: Properties
    
//    @NSManaged var videoEndPoint: String
    
    @NSManaged var image: PFFile
    @NSManaged var user: PFUser
    @NSManaged var caption: String?
    @NSManaged var comments: String?
    @NSManaged var like: String?
    @NSManaged var identifier: String?
    @NSManaged var timeStamps: NSDate?
    
    override class func query() -> PFQuery? {
        let query = PFQuery(className: Blog.parseClassName())
        query.includeKey("user")
        query.orderByAscending("createdAt")
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
    
    init(image: PFFile, user: PFUser, caption: String?, comments: String?, like: String?, identifier: String?, timeStamps: NSDate? = nil) {
        super.init()
        
//        self.videoEndPoint = videoEndPoint
        self.caption = caption
        self.comments = comments
        self.like = like
        self.identifier = identifier
        self.timeStamps = timeStamps
        self.image = image
    }
    
    override init() {
        super.init()
    }
}
