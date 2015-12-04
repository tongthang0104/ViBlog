//
//  Like.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import Foundation

class Like {
    
    //MARK: Properties
    
    var username: String
    var blogID: String
    var identifier: String?
    
    //MARK: Initializer
    
    init(username: String, blogID: String, identifier: String? = nil) {
        self.username = username
        self.blogID = blogID
        self.identifier = identifier
    }
}

func ==(lhs: Like, rhs: Like) -> Bool{
    return (lhs.identifier == rhs.identifier) && (lhs.username == rhs.username)
}