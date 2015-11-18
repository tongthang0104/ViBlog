//
//  UserController.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import Foundation

class UserController {
    
    static let shareController = UserController()
    static var currentUser: [User] = UserController.mockUsers()
    
    // mock User
    static func mockUsers() -> [User] {
        
        let user1 = User(username: "superman", password: "1234", email: "superman@yahoo.com")
        let user2 = User(username: "batman", password: "2345", identifier: "12341424")
        let user3 = User(username: "catwoman", password: "4929", email: "catwoman@yahoo.com")

        return [user1, user2, user3]
    }
    
    // user For Identifier

    static func userForIdentifier(identifier: String, completion: (user: User?) -> Void) {
        completion(user: currentUser.first)
    }
    
    // authenticate User
    static func authenticateUsers(username: String, password: String, completion: (user: User?, success: Bool) -> Void) {
        completion(user: currentUser.first, success: true)
    }
    
    // fetch all Users
    
    static func fetchAllUsers(completion: (user: [User]) -> Void) {
        completion(user: currentUser)
    }
    
    // create User
    
    static func addUser(username: String, password: String, email: String?, completion: (user: User?, success: Bool) -> Void) {
        completion(user: currentUser.first, success: true)
    }
    
    // update User
    
    static func updateUser(user: User, username: String, email: String?, completion: (user: User?, success: Bool) -> Void) {
        completion(user: currentUser.first, success: true)
    }
    
    // follow User
    static func followUser(user: User, completion: (success: Bool) -> Void) {
        completion(success: true)
    }
    
    // followed by User
    
    static func followedByUser(user: User, completion: (user: [User]?) -> Void) {
        completion(user: currentUser)
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
    
    static func logouCurrentUser() {
        
    }
    
    // block User (add later)
    static func blockUser(user1: User, user2: User, completion: (success: Bool) -> Void) {
    
    }
}





