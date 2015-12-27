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
    static func fetchBlogsForUser(user: PFUser, completion: (blog: [Blog]?) -> Void) {
        
        let query = Blog.query()!
        query.findObjectsInBackgroundWithBlock { (object, error) -> Void in
            if let object = object as? [Blog] {
                completion(blog: object)
            } else {
                completion(blog: nil)
                print(error?.localizedDescription)
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
        let blogQuery = Blog.query()
        blogQuery?.getObjectInBackgroundWithId(identifier, block: { (object, error) -> Void in
            if let object = object as? Blog {
                completion(blog: object)
            } else {
                completion(blog: nil)
                print(error?.localizedDescription)
            }
        })
    }
    
    static func blogsForUser(user: User, completion: (blogs: [Blog]?) -> Void) {
        let blogQuery = Blog.query()
        blogQuery?.whereKey("user", equalTo: user)
        blogQuery?.includeKey("user")
        blogQuery?.findObjectsInBackgroundWithBlock({ (object, error) -> Void in
            if let object = object as? [Blog] {
                completion(blogs: object)
            } else {
                completion(blogs: nil)
                print(error?.localizedDescription)
            }
        })
    }
    
    // remove Blog
    //    static func removeBlog(blog: Blog?, completion: (success: Bool) -> Void) {
    //
    //        completion(success: true)
    //    }
    
    // add comment Blogs
    static func addCommentToBlog(text: String, blog: Blog, completion: (blog: Blog?, success: Bool) -> Void) {
        completion(blog: currentBlog.first, success: true)
    }
    
    // like Blogs
    
    static func likeBlogs(blog: Blog, completion: (success: Bool, blog: Blog?) -> Void) {
        
        let like = Like(fromUser: UserController.shareController.current! as! User, blog: blog)
        like.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success {
                completion(success: true, blog: blog)
            }else {
                completion(success: false, blog: nil)
            }
        })
        
        BlogController.blogFromIdentifier(blog.objectId!) { (blog) -> Void in
            completion(success: true, blog: blog)
        }
    }
    //fetch like
    
    static func likeForBlog(blog: Blog, completion: (like: [Like]) -> Void) {
        let query = Like.query()
        query?.whereKey("blog", equalTo: blog)
        query?.includeKey(ParseHelper.kActivityFromUser)
        query?.findObjectsInBackgroundWithBlock({ (object, error) -> Void in
            if let like = object as? [Like] {
                completion(like: like)
            } else {
                completion(like: [])
            }
        })
       
    }
    
    //TODO: Needto review
    static func countLike(blog: Blog, completion: (like: Int32)-> Void ) {
        let query = Like.query()
        query?.whereKey("blog", equalTo: blog)
        query?.countObjectsInBackgroundWithBlock({ (likeNumber, error) -> Void in
            if error == nil {
                completion(like: likeNumber)
            } else {
                print(error?.localizedDescription)
            }
        })
    }
 
    // Check Liked Blog
    
    static func userLikeBlog(user: PFUser, blog: Blog, completion: (liked: Bool) -> Void) {
        let query = Like.query()
        query?.whereKey(ParseHelper.kActivityFromUser, equalTo: user)
        query?.whereKey("blog", equalTo: blog)
        
        query?.findObjectsInBackgroundWithBlock({ (object, error) -> Void in
            if let object = object {
                if object.count > 0 {
                    completion(liked: true)
                } else {
                    completion(liked: false)
                }
            }
        })
    }
    
    // Unlike Blog
    
    static func unlikeBlog(user: PFUser, blog: Blog, completion: (success: Bool) -> Void) {
        let query = Like.query()
        query?.whereKey(ParseHelper.kActivityFromUser, equalTo: user)
        query?.whereKey("blog", equalTo: blog)
        query?.findObjectsInBackgroundWithBlock { (object, error) -> Void in
            if error == nil {
                if let like = object?.first {
                    like.deleteInBackground()
                }
                completion(success: true)
            } else {
                completion(success: false)
                print(error?.localizedDescription)
            }
        }
    }
    
    static func likeForBlog (blog: Blog, completion: (blog: [Blog]?) -> Void) {
        let query = PFQuery(className: ParseHelper.ParseLikeClass)
        query.whereKey(ParseHelper.kLikeToPost, equalTo: blog)
        query.includeKey(ParseHelper.kLikeFromUser)
        query.findObjectsInBackgroundWithBlock { (object, error) -> Void in
            if let blogs = object as? [Blog] {
                completion(blog: blogs)
            } else {
                completion(blog: [])
                print(error?.localizedDescription)
            }
        }
    }
    
    // Add comment
    
    static func addComment (blog: Blog, text: String, completion: (success: Bool, blog: Blog?) -> Void) {
        
        let comment = Comment(fromUser: UserController.shareController.current! as! User, blog: blog, text: text)
        comment.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                completion(success: true, blog: blog)
            } else {
                completion(success: false, blog: nil)
                print(error?.localizedDescription)
            }
        }
    }
}