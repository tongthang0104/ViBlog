//
//  UserController.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import Foundation
import UIKit
import Parse
class UserController {
    
    static let shareController = UserController()
    
    var current = PFUser.currentUser()
    var currentUser: User! = nil
    static let user: User = User()
    
    // user For Identifier
    
    static func userForIdentifier(identifier: String, completion: (user: User?) -> Void) {
        
        let query = User.query()
//        query?.getObjectInBackgroundWithId(<#T##objectId: String##String#>, block: <#T##((PFObject?, NSError?) -> Void)?##((PFObject?, NSError?) -> Void)?##(PFObject?, NSError?) -> Void#>)
        query?.getObjectInBackgroundWithId(identifier, block: { (object, error) -> Void in
            if let user = object as? User {
                completion(user: user)
            } else {
                completion(user: nil)
                print(error?.localizedDescription)
            }
        })
    }
    
    // authenticate User
    static func authenticateUsers(username: String, password: String, completion: (user: User?, success: Bool) -> Void) {
       
        PFUser.logInWithUsernameInBackground(username, password: password) { (user, error) -> Void in
            if user != nil {
                completion(user: self.user, success: true)
            } else {
                print(error?.localizedDescription)
                completion(user: nil, success: false)
            }
        }
    }
    
    // fetch all Users
    
    static func fetchAllUsers(completion: (users: [User]?) -> Void) {
        let query = User.query()!
        query.findObjectsInBackgroundWithBlock({ (object, error) -> Void in
            if let users = object as? [User] {
                completion(users: users)
            } else {
                completion(users: [])
                print(error?.localizedDescription)
            }
        })
    }
    
    // create User
    
    static func createUser(username: String, password: String, email: String?, completion: (user: User?, success: Bool) -> Void) {
        
        user.username = username
        user.password = password
        user.email = email
        
        user.signUpInBackgroundWithBlock({ (success, error) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                print(errorString)
                completion(user: nil, success: false)
            } else {
                completion(user: user, success: true)
            }
        })
    }
    // add image to User
    
    static func addAvatar(image: UIImage, completion: (user: User?, success: Bool) -> Void) {
        
        
    }
    
    // update User
    
    static func updateUser(user: User, username: String, email: String?, completion: (user: User?, success: Bool) -> Void) {
        
    }
    
    // follow User
    static func followUser(user: User, completion: (success: Bool) -> Void) {
        
    }
    
    // followed by User
    
    static func followedByUser(user: User, completion: (followers: [User]?) -> Void) {
        
    }
    
    // User follow User
    static func userFollowUser(follower: User, followee: User, completion: (follows: Bool) -> Void) {
        
        
        
        
        
        
        
        completion(follows: true)
    }
    
    // Unfollow User
    static func unfollowUser(user: User, completion: (success: Bool) -> Void) {
        completion(success: true)
    }
    
    // logout User
    
    static func logoutCurrentUser() {
        PFUser.logOut()
        
    }
    
    // block User (add later)
    static func blockUser(user1: User?, user2: User?, completion: (success: Bool) -> Void) {
        
    }
}





