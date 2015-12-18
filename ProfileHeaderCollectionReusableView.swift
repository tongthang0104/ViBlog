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
    var user: User?
//    var delegate: ProfileHeaderCollectionReusableViewDelegate?

    
    // MARK: Action
    
    @IBAction func followButtonTapped(sender: UIButton) {
//        self.delegate?.followButtonTapped(sender)
        guard let currentUser = UserController.shareController.current else {return}
        
        if let user = user {
            
            UserController.userFollowUser(currentUser, followee: user) { (follows) -> Void in
                if follows {
                    
                    UserController.unfollowUser(user, completion: { (success) -> Void in
                        
                        let followingUser = ProfileViewController.following?.filter(){ $0 != user }
                        ProfileViewController.following = followingUser
                        self.updateWithUsers(user)
                    })
                } else {
                    UserController.followUser(user, completion: { (success, error) -> Void in
                        
                        if success {
                            ProfileViewController.following?.append(user)
                            self.updateWithUsers(user)
                        } else {
                            print(error?.localizedDescription)
                        }
                    })
                }
            }
        }
    }
    
    
 
    
    func updateWithUsers(user: User) {
        
        self.user = user

        if let avatar = user["avatar"] as? PFFile {
            ImageController.fetchImageAtURL(NSURL(string: avatar.url!)!, completion: { (image) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.avatarImage.image = image
            })
           })
        } else {
            avatarImage.image = ImageController.defaultImage
        }
        
//         set followingLabel = "\(followering.count) followings"
//         set followersLabel = "\(followers.count) followers"
        
        if user == UserController.shareController.current {
            followButton.setTitle(user.username, forState: .Normal)
            followButton.enabled = false
            followButton.backgroundColor = UIColor.myRedColor()
        } else {
            guard let currentUser = UserController.shareController.current else {return}
            if let user = self.user {
            UserController.userFollowUser(currentUser, followee: user, completion: { (follows) -> Void in
                if follows {
                    self.followButton.setTitle("UnFollow", forState: .Normal)
                    self.followButton.setBackgroundImage(UIImage(named: "buttonFollowing"), forState: .Normal)
                    print("Already followed")
                } else {
                    self.followButton.setTitle("Follow", forState: .Normal)
                     self.followButton.setBackgroundImage(UIImage(named: "unfollowButton"), forState: .Normal)
                    print("Not followed yet")
                }
            })
        }
        }
    }
}

//protocol ProfileHeaderCollectionReusableViewDelegate {
//    func followButtonTapped(sender: UIButton)
//    
//}

