//
//  User.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import Foundation

class User: Equatable {
    
    //MARK: Properties
    
    var username: String
    var password: String
    var email: String?
    var avatarEndpoint: String?
    var identifier: String?
    
    //MARK: Initializer
    
    init(username: String, password: String, email: String? = nil, avatarEndPoint: String? = nil, identifier: String? = nil) {
        self.username = username
        self.password = password
        self.email = email
        self.avatarEndpoint = avatarEndPoint
        self.identifier = identifier
    }
}

func ==(lhs: User, rhs: User) -> Bool{
    return (lhs.identifier == rhs.identifier) && (lhs.username == rhs.username)
}