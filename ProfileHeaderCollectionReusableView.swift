//
//  ProfileHeaderCollectionReusableView.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/25/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView{
    
    // MARK: Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var avatarButton: UIButton!
    
    var user: User?
    var delegate: ProfileHeaderCollectionReusableViewDelegate?

    
    // MARK: Action
    
    @IBAction func followButtonTapped(sender: UIButton) {
        self.delegate?.followButtonTapped(sender)
    }
    
    
    
    @IBAction func avatarButtonTapped(sender: AnyObject) {
      
    }
   
    
    func updateWithUsers(user: User) {
        self.user = user
        self.nameLabel.text = user.username
        // set followingLabel = "\(followering.count) followings"
        // set followersLabel = "\(followers.count) followers"
        if user == UserController.shareController.currentUser {
            followButton.removeFromSuperview()
        } else {
            UserController.userFollowUser(UserController.shareController.currentUser, followee: user, completion: { (follows) -> Void in
                if follows {
                    self.followButton.setTitle("Unfollow", forState: .Normal)
                } else {
                    self.followButton.setTitle("Follow", forState: .Normal)
                }
            })
        }
    }
}

protocol ProfileHeaderCollectionReusableViewDelegate {
    func followButtonTapped(sender: UIButton)
    
}

