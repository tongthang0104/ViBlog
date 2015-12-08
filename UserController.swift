//
//  UserController.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import Foundation
import UIKit

class UserController {

    static let shareController = UserController()
    
    var currentUser: User! = UserController.mockUsers().first

    
    // mock User
    static func mockUsers() -> [User] {
        
        let sampleImageIdentifier = "-K1l4125TYvKMc7rcp5e"
        
        let user1 = User(username: "superman", password: "1234", email: "superman@yahoo.com", identifier: "12312")
        let user2 = User(username: "batman", password: "2345", identifier: "12341424")
        let user3 = User(username: "catwoman", password: "4929", email: "catwoman@yahoo.com")
        let user4 = User(username: "robinhood", password: "23123", email: "robinhood@gmail.com", avatarEndPoint: sampleImageIdentifier, identifier: "31232")

        return [user1, user2, user3, user4]
    }
    
    // user For Identifier

    static func userForIdentifier(identifier: String, completion: (user: User?) -> Void) {
        completion(user: mockUsers().first)
    }
    
    // authenticate User
    static func authenticateUsers(username: String, password: String, completion: (user: User?, success: Bool) -> Void) {
        completion(user: mockUsers().first, success: true)
    }
    
    // fetch all Users
    
    static func fetchAllUsers(completion: (users: [User]) -> Void) {
        completion(users: mockUsers())
    }
    
    // create User
    
    static func createUser(username: String, password: String, email: String?, completion: (user: User?, success: Bool) -> Void) {
        completion(user: mockUsers().first, success: true)
        
        
        
        
        
        
        
        
        
        
        
    }
    // add image to User
    
    static func addAvatar(image: UIImage, completion: (user: User?, success: Bool) -> Void) {
        completion(user: mockUsers().first, success: true)
    }
    
    // update User
    
    static func updateUser(user: User, username: String, email: String?, completion: (user: User?, success: Bool) -> Void) {
        completion(user: mockUsers().first, success: true)
    }
    
    // follow User
    static func followUser(user: User, completion: (success: Bool) -> Void) {
        completion(success: true)
    }
    
    // followed by User
    
    static func followedByUser(user: User, completion: (followers: [User]?) -> Void) {
        completion(followers: mockUsers())
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
        
    }
    
    // block User (add later)
    static func blockUser(user1: User?, user2: User?, completion: (success: Bool) -> Void) {
    
    }
}





