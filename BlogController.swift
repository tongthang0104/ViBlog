//
//  BlogController.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import Foundation

class BlogController {
    
    static var currentBlog: [Blog] = []
    // fetch all Blogs
    static func fetchPosts(user: User, completion: (post: [Blog]) -> Void) {
        
    }

    // create Blog
    static func createBlog(user: User, videoEndPoint: String, caption: String?, completion: (blog: Blog?, success: Bool) -> Void){
        
    }
    // Blog From Identifier
    static func blogFromIdentifier(identifier: String, completion: (blog: Blog?) -> Void) {
        
    }
    
    
    // remove Blog
    

    // add comment Blogs
    static func addCommentToBlog(user: User, comment: [Comment]?, completion: (blog: Blog?, success: Bool) -> Void) {
        
    }
    
    // like Blogs
    
    
    
    
    
    
    
}