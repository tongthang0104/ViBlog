//
//  ProfileHeaderCollectionReusableView.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/25/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    var user: User?
    var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
    @IBOutlet weak var selfImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    
    @IBAction func followButtonTapped(sender: UIButton) {
        
    }
    
    
    func updateWithUsers(user: User) {
        self.user = user
        self.nameLabel.text = user.username
    }
}

protocol ProfileHeaderCollectionReusableViewDelegate {
    func followButtonTapped(sender: UIButton)
}
