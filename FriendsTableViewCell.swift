//
//  FriendsTableViewCell.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/23/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    var user: User?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selfImage: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    
    //MARK: Action
    
    @IBAction func followButtonTapped(sender: UIButton) {
        guard let currentUser = UserController.shareController.current else {return}
        
        if let user = user {
            
            UserController.userFollowUser(currentUser, followee: user) { (follows) -> Void in
                if follows {
                    
                    UserController.unfollowUser(user, completion: { (success) -> Void in
                        
                        var followingUser = ProfileViewController.following?.filter(){ $0 != user }
                        ProfileViewController.following = followingUser
                        
                        print("unfollowed")
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
        self.nameLabel.text = user.username
        self.selfImage.image = nil
        
        guard let currentUser = UserController.shareController.current else {return}
        
        if self.user == currentUser {
            
            self.followButton.enabled = false
            self.followButton.setTitle("", forState: .Normal)
            
        } else if let user = self.user {
            
            UserController.userFollowUser(currentUser, followee: user, completion: { (follows) -> Void in
                if follows {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.followButton.setTitle("UnFollow", forState: .Normal)
                    })
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.followButton.setTitle("Follow", forState: .Normal)
                    })
                }
            })
            
        }
        
        
        if let avatar = user["avatar"] as? PFFile {
            ImageController.fetchImageAtURL(NSURL(string: avatar.url!)!, completion: { (image) -> () in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.selfImage.image = image
                })
            })
        } else {
            self.selfImage.image = ImageController.defaultImage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
