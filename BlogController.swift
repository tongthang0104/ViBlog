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
    static func fetchBlogs(user: User, completion: (blog: [Blog]) -> Void) {
        completion(blog: currentBlog)
    }

    // create Blog
    static func createBlog(user: User, videoEndPoint: String, caption: String?, completion: (blog: Blog?, success: Bool) -> Void){
        completion(blog: currentBlog.first, success: true)
    }
    // Blog From Identifier
    static func blogFromIdentifier(identifier: String, completion: (blog: Blog?) -> Void) {
        completion(blog: currentBlog.first)
    }
    
    
    // remove Blog
    static func removeBlog(blog: Blog?, completion: (success: Bool) -> Void) {
        completion(success: true)
    }

    // add comment Blogs
    static func addCommentToBlog(user: User, comment: [Comment]?, completion: (blog: Blog?, success: Bool) -> Void) {
        completion(blog: currentBlog.first, success: true)
    }
    
    // like Blogs
    static func likeBlogs(user: User, like: [Like]?, completion: (blog: Blog?, success: Bool) -> Void) {
        completion(blog: currentBlog.first, success: true)
    }
    
    
    
    
    
    
    
}