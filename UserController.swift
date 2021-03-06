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
import Bolts

class UserController {
    
    static let shareController = UserController()
    
    var following: [PFUser] = []
    var current = PFUser.currentUser()
    var currentUser: User! = nil
        static let user: User = User()
    
    // User For Identifier
    
    static func userForIdentifier(identifier: String, completion: (user: User?) -> Void) {
        let query = User.query()
        query?.getObjectInBackgroundWithId(identifier, block: { (object, error) -> Void in
            if let user = object as? User {
                completion(user: user)
            } else {
                completion(user: nil)
                print(error?.localizedDescription)
            }
        })
    }
    
    // Authenticate User
    static func authenticateUsers(username: String, password: String, completion: (user: User?, success: Bool) -> Void) {
        
        PFUser.logInWithUsernameInBackground(username, password: password) { (user, error) -> Void in
            if user != nil {
                completion(user: user as? User, success: true)
            } else {
                print(error?.localizedDescription)
                completion(user: nil, success: false)
            }
        }
    }
    
    // Fetch all Users
    
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
    
    // Create User
    
    static func createUser(username: String, password: String, email: String?, completion: (user: User?, success: Bool, error: NSError?) -> Void) {
//        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        
        user.signUpInBackgroundWithBlock({ (success, error) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                print(errorString)
                
               
                completion(user: nil, success: false, error: error)
            } else {
//                UserController.authenticateUsers(username, password: password, completion: { (user, success) -> Void in
//                    if success {
//                        UserController.shareController.current = user
//                        completion(user: user, success: true, error: nil)
//                    }
//                })
                completion(user: user, success: true, error: nil)
            }
        })
    }
    
    // Add Profile Picture to User
    
    static func addAvatar(image: UIImage, completion: (success: Bool) -> Void) {
        
        let imageData: NSData = UIImageJPEGRepresentation(image, 0.5)!
        let imageFile: PFFile = PFFile(name: "image.jpg", data: imageData)!
        do {
            try imageFile.save()
        } catch {
            
        }
        UserController.shareController.current?.setObject(imageFile, forKey: "avatar")
        UserController.shareController.current?.saveInBackgroundWithBlock({ (success, error) -> Void in
            completion(success: success)
        })
    }
    
    // update User
    
    static func updateUser(user: User, newUsername: String, newEmail: String, completion: (success: Bool, error: NSError?) -> Void) {
        
        let oldUsernameValue = user.username
        let oldEmailValue = user.email
        
        user.email = newEmail
        user.username = newUsername
        user.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                user.username = newUsername
                user.email = newEmail
                user.saveInBackground()
                completion(success: true, error: nil)
            } else {
                user.username = oldUsernameValue
                user.email = oldEmailValue
                user.saveInBackground()
                completion(success: false, error: error)
            }
        }
    }
    
    // follow User
    static func followUser(user: PFUser, completion: (success: Bool, error: NSError?) -> Void) {
        
        if let currentUser = UserController.shareController.current {
            let follow = PFObject(className: ParseHelper.kFollowActivity)
            follow.setObject(currentUser.objectId!, forKey: ParseHelper.kFollowFromUser)
            follow.setObject(user, forKey: ParseHelper.kFollowToUser)
            
            follow.setObject(user.username!, forKey: ParseHelper.kUsername)
            follow.fetchIfNeededInBackground()
            
            follow.saveInBackgroundWithBlock({ (success, error) -> Void in
                if success {
                    
                    completion(success: true, error: nil)
                } else {
                    completion(success: false, error: error)
                    print(error?.localizedDescription)
                }
            })
        }
    }
    
    // followed by User
    
    static func followedByUser(user: PFUser, completion: (followed: [User]?) -> Void) {
        
        let query = PFQuery(className: ParseHelper.kFollowActivity)
        query.whereKey(ParseHelper.kFollowFromUser, equalTo: user.objectId!)
        query.includeKey("toUser")
        query.findObjectsInBackgroundWithBlock { (object, error) -> Void in
            var userArray: [User] = []
            if let objects = object {
                for follows in objects {
                    if let user = follows["toUser"] {
                        userArray.append(user as! User)
                    }
                }
                completion(followed: userArray)
            } else {
                completion(followed: [])
            }
        }
    }
    
    //Count followed
    static func countFollowed(user: User, completion: (followed: [PFObject]) -> Void) {
        let query = PFQuery(className: ParseHelper.kFollowActivity)
        query.whereKey(ParseHelper.kFollowFromUser, equalTo: user.objectId!)
        query.includeKey("toUser")
        query.findObjectsInBackgroundWithBlock { (object, error) -> Void in
            if let object = object {
                completion(followed: object)
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    // User follow User
    
    static func userFollowUser(user: PFUser, followee: PFUser, completion: (follows: Bool) -> Void) {
        
        let query = PFQuery(className: ParseHelper.kFollowActivity)
        query.whereKey(ParseHelper.kActivityFromUser, equalTo: user.objectId!)
        query.whereKey(ParseHelper.kActivityToUser, equalTo: followee)
        
        query.findObjectsInBackgroundWithBlock({ (object, error) -> Void in
            if let user = object {
                if user.count > 0 {
                    completion(follows: true)
                } else {
                    completion(follows: false)
                }
            }
        })
    }
    
    // Unfollow User
    
    static func unfollowUser(user: User, completion: (success: Bool) -> Void) {
        
        let query = PFQuery(className: ParseHelper.kFollowActivity)
        query.whereKey(ParseHelper.kActivityFromUser, equalTo: UserController.shareController.current!.objectId!)
        query.whereKey(ParseHelper.kActivityToUser, equalTo: user)
        query.findObjectsInBackgroundWithBlock { (object, error) -> Void in
            print(object)
            if error == nil {
                if let users = object?.first {
                    users.deleteInBackground()
                }
                completion(success: true)
            } else {
                completion(success: false)
                print("failed to unfollow")
            }
        }
    }
    
    // logout User
    
    static func logoutCurrentUser(completion:(success: Bool) -> Void) {
        PFUser.logOutInBackgroundWithBlock { (error) -> Void in
            if error == nil {
                completion(success: true)
                UserController.shareController.current = nil
            } else {
                completion(success: false)
            }
        }
        
    }
    
    // Reset Password
    
    static func resetPassword(email: String, completion: (success: Bool, error: NSError?) -> Void) {
        PFUser.requestPasswordResetForEmailInBackground(email) { (success, error) -> Void in
            if error == nil {
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: error)
            }
        }
    }
    
    
    // block User (add later)
    static func blockUser(user1: User?, user2: User?, completion: (success: Bool) -> Void) {
        
    }
}





