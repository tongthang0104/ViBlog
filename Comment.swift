//
//  Comment.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import Foundation

class Comment {
    
    //MARK: Properties
    
    var username: String
    var text: String
    var blogID: String?
    var identifier: String?
    
    //MARK: Initializer
    
    init(username: String, text: String, blogID: String? = nil, identifier: String? = nil) {
        self.username = username
        self.text = text
        self.blogID = blogID
        self.identifier = identifier
    }
}
func ==(lhs: Comment, rhs: Comment) -> Bool{
    return (lhs.identifier == rhs.identifier) && (lhs.username == rhs.username)
}