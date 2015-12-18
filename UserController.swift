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
    
    
    // user For Identifier
    
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
    
    static func updateUser(user: User, username: String, email: String?, completion: (user: User?, success: Bool) -> Void) {
        
    }
    
    // follow User
    static func followUser(user: PFUser, completion: (success: Bool, error: NSError?) -> Void) {
        
        if let currentUser = UserController.shareController.current {
            let follow = PFObject(className: User.kFollowActivity)
            
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
        
        let query = PFQuery(className: ParseHelper.parseFollowClass)
        query.whereKey(ParseHelper.kFollowFromUser, equalTo: user.objectId!)
        query.includeKey("toUser")
//        query.selectKeys([ParseHelper.kFollowFromUser, ParseHelper.kFollowToUser])
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
    
    // User follow User
    static func userFollowUser(user: PFUser, followee: PFUser, completion: (follows: Bool) -> Void) {
        
        let query = PFQuery(className: User.kFollowActivity)
        query.whereKey(User.kActivityFromUser, equalTo: user.objectId!)
        query.whereKey(User.kActivityToUser, equalTo: followee)
        
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
        let query = PFQuery(className: User.kFollowActivity)
        query.whereKey(User.kActivityFromUser, equalTo: UserController.shareController.current!.objectId!)
        //        query.whereKey(User.kActivityToUser, containedIn: user)
        query.whereKey(User.kActivityToUser, equalTo: user)
//        query.whereKey(User.kUsername, equalTo: user.username!)
        
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
    
    static func logoutCurrentUser() {
        PFUser.logOut()
        UserController.shareController.current = PFUser.currentUser()
    }
    
    // block User (add later)
    static func blockUser(user1: User?, user2: User?, completion: (success: Bool) -> Void) {
        
    }
}





