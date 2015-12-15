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
    
    @IBOutlet weak var avatarImage: UIImageView!
    var user: PFUser?
    var delegate: ProfileHeaderCollectionReusableViewDelegate?

    
    // MARK: Action
    
    @IBAction func followButtonTapped(sender: UIButton) {
        self.delegate?.followButtonTapped(sender)
    }
    
    
    
    @IBAction func avatarButtonTapped(sender: AnyObject) {
      
    }
   
    
    func updateWithUsers(user: PFUser) {
        self.user = user
        self.nameLabel.text = user.username
        
        if let avatar = user["avatar"] as? PFFile {
            ImageController.fetchImageAtURL(NSURL(string: avatar.url!)!, completion: { (image) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.avatarImage.image = image
            })
           })
        } else {
            avatarImage.image = ImageController.defaultImage
        }
        
        // set followingLabel = "\(followering.count) followings"
        // set followersLabel = "\(followers.count) followers"
        if user == UserController.shareController.current {
            followButton.removeFromSuperview()
        } else {
            print("Changing")
            
            guard let currentUser = UserController.shareController.current else {return}
            if let user = self.user {
            UserController.userFollowUser(currentUser, followee: user, completion: { (follows) -> Void in
                if follows {
                    self.followButton.setTitle("UnFollow", forState: .Normal)
                } else {
                    self.followButton.setTitle("Follow", forState: .Normal)
                }
            })
        }
        }
    }
}

protocol ProfileHeaderCollectionReusableViewDelegate {
    func followButtonTapped(sender: UIButton)
    
}

