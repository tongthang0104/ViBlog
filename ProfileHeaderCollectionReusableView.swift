//
//  ProfileHeaderCollectionReusableView.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/25/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView{
    
    // MARK: - Properties
    
    
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var postCountLabel: UILabel!
    
    var user: User?
    
    // MARK: - Action
    
    @IBAction func followButtonTapped(sender: UIButton) {
        //        self.delegate?.followButtonTapped(sender)
        guard let currentUser = UserController.shareController.current else {return}
        
        if let user = user {
            
            UserController.userFollowUser(currentUser, followee: user) { (follows) -> Void in
                if follows {
                    UserController.unfollowUser(user, completion: { (success) -> Void in
                        // let followingUser = ProfileViewController.shareController.following?.filter(){ $0 != user }
                        // ProfileViewController.shareController.following = followingUser
                        self.updateWithUsers(user)
                    })
                } else {
                    UserController.followUser(user, completion: { (success, error) -> Void in
                        if success {
                            if var followingUser = ProfileViewController.shareController.following {
                                followingUser.append(user)
                            }
                            self.updateWithUsers(user)
                        } else {
                            print(error?.localizedDescription)
                        }
                    })
                }
            }
        }
    }
    
    //MARK: - UpdateWithUser
    
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
        
        UserController.countFollowed(user) { (followed) -> Void in
            if followed.count <= 1 {
                self.followingLabel.text = "\(followed.count) Following"
            } else {
                self.followingLabel.text = "\(followed.count) Followings"
            }
            
        }
        BlogController.countBlog(user) { (blog) -> Void in
            if blog <= 1 {
                self.postCountLabel.text = "\(blog) Blog"
            } else {
                self.postCountLabel.text = "\(blog) Blogs"
            }
        }
        //        self.postCountLabel.text = "\()"
        //                self.followingLabel.text = "\()"
        //         set followersLabel = "\(followers.count) followers"
        
        if user == UserController.shareController.current {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.followButton.setTitle(user.username, forState: .Normal)
                self.followButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
                self.followButton.enabled = false
            })
        } else {
            guard let currentUser = UserController.shareController.current else {return}
            if let user = self.user {
                UserController.userFollowUser(currentUser, followee: user, completion: { (follows) -> Void in
                    if follows {
                        self.followButton.setTitle("Following", forState: .Normal)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.followButton.setBackgroundImage(UIImage(named: "buttonFollowing"), forState: .Normal)
                        })
                    } else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.followButton.setBackgroundImage(UIImage(named: "unfollowButton"), forState: .Normal)
                        })
                        self.followButton.setTitle("Follow", forState: .Normal)
                    }
                })
            }
        }
    }
}


