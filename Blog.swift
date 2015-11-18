//
//  Blog.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import Foundation

class Blog: Equatable {
    
    //MARK: Properties
    
    var videoEndPoint: String
    var username: String
    var image: String?
    var caption: String?
    var comments: [Comment]
    var like: [Like]
    var identifier: String?
    var timeStamps: NSDate?
    
    //MARK: Initializer
    
    init(videoEndPoint: String, username: String, image: String, caption: String? = nil, comments: [Comment] = [], like: [Like] = [], identifier: String? = nil, timeStamps: NSDate? = nil) {
        
        self.videoEndPoint = videoEndPoint
        self.username = username
        self.image = image
        self.caption = caption
        self.comments = comments
        self.like = like
        self.identifier = identifier
        self.timeStamps = timeStamps
    }
}

func ==(lhs: Blog, rhs: Blog) -> Bool{
    return (lhs.identifier == rhs.identifier) && (lhs.username == rhs.username)
}