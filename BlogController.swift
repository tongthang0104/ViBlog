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
        completion(blog: mockBlogs())
    }

    // create Blog
    static func createBlog(video: NSURL, caption: String?, completion: (blog: Blog?, success: Bool) -> Void){
        completion(blog: currentBlog.first, success: true)
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
    

    static func mockBlogs() -> [Blog] {
        
        let sampleVideoEndPoint = "-k12312492hfnasd"
        let like1 = Like(username: "superman", blogID: "1234")
        let like2 = Like(username: "catwoman", blogID: "4566")
        let like3 = Like(username: "robinhood", blogID: "43212")
        
        let comment1 = Comment(username: "robinhood", text: "hello there", blogID: "1234")
        let comment2 = Comment(username: "catwoman", text: "hi everyone", blogID:  "4566")
        
        
        
        let blog1 = Blog(videoEndPoint: sampleVideoEndPoint, caption: "hello", comments: [comment1, comment2], like: [like1])
        let blog2 = Blog(videoEndPoint: sampleVideoEndPoint)
        let blog3 = Blog(videoEndPoint: sampleVideoEndPoint, caption: "This is mine", comments: [comment2], like: [like1, like2, like3], identifier: "123214")
        
        return [blog1, blog2, blog3]
    }
    
    
    
    
}