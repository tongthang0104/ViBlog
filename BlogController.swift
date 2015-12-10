//
//  BlogController.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class BlogController {
    
    static var currentBlog: [Blog] = []
    
    // fetch all Blogs
    static func fetchBlogsForUser(user: User, completion: (blog: [Blog]?) -> Void) {
        
        let query = Blog.query()!
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                if let object = objects as? [Blog] {
                    completion(blog: object)
                }
            } else {
                print(error?.localizedDescription)
                completion(blog: nil)
            }
        }
    }

    // create Blog
    static func createBlog(video: PFFile, user: PFUser, caption: String?, completion: (blog: Blog?, success: Bool) -> Void){
      
        let blog = Blog(video: video, user: user, caption: caption)
        blog.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                completion(blog: blog, success: true)
            } else {
                print(error?.localizedDescription)
                completion(blog: nil, success: false)
            }
        }
    }
    
    // Blog From Identifier
    static func blogFromIdentifier(identifier: String, completion: (blog: Blog?) -> Void) {
        
        
        
        
        
        
        
        completion(blog: currentBlog.first)
    }
    
    static func blogsForUser(username: String, completion: (blogs: [Blog]?) -> Void) {
        completion(blogs: currentBlog)
    }
    
    
    // remove Blog
    static func removeBlog(blog: Blog?, completion: (success: Bool) -> Void) {
        
        
        
        
        completion(success: true)
    }

    // add comment Blogs
    static func addCommentToBlog(text: String, blog: Blog, completion: (blog: Blog?, success: Bool) -> Void) {
        completion(blog: currentBlog.first, success: true)
    }
    
    
    // like Blogs
    
    static func likeBlogs(blog: Blog, completion: (blog: Blog?, success: Bool) -> Void) {
        completion(blog: currentBlog.first, success: true)
    }
    
    static func unlikeBlog(like: Like, completion: (blog: Blog?, success: Bool) -> Void) {
        
    }

    static func orderBlogs(blogs: [Blog]) -> [Blog] {
        return currentBlog
    }
}