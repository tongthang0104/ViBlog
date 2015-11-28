//
//  ProfileHeaderCollectionReusableView.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/25/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: Properties
    @IBOutlet weak var selfImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var user: User?
    var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
    // MARK: Action
    
    @IBAction func followButtonTapped(sender: UIButton) {
        self.delegate?.followButtonTapped(sender)
    }
    
    func updateWithUsers(user: User) {
        self.user = user
        self.nameLabel.text = user.username
        self.selfImage = nil
        
        if let selfImage = user.imageEndpoint {
            ImageController.imageForIdentifier(selfImage) { (image) -> Void in
                self.selfImage.image = image
            }
        }
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

