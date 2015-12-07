//
//  Blog.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import Foundation
import UIKit

class Blog: Equatable {
    
    //MARK: Properties
    
    var videoEndPoint: String
    var videoSnapShot: String
    var username: String
    var avatarEndPoint: String?
    var caption: String?
    var comments: [Comment]
    var like: [Like]
    var identifier: String?
    var timeStamps: NSDate?
    
    //MARK: Initializer
    
    init(videoEndPoint: String, videoSnapShot: String, username: String = UserController.shareController.currentUser.username, avatarEndPoint: String? = nil, caption: String? = nil, comments: [Comment] = [], like: [Like] = [], identifier: String? = nil, timeStamps: NSDate? = nil) {
        
        self.videoEndPoint = videoEndPoint
        self.username = username
        self.caption = caption
        self.comments = comments
        self.like = like
        self.identifier = identifier
        self.timeStamps = timeStamps
        self.avatarEndPoint = avatarEndPoint
        self.videoSnapShot = videoSnapShot
        
    }
}

func ==(lhs: Blog, rhs: Blog) -> Bool{
    return (lhs.identifier == rhs.identifier) && (lhs.username == rhs.username)
}