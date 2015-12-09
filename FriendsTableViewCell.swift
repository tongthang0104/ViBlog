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
        followButton.setTitle("Follow", forState: .Normal)
    }
    
    func updateWithUsers(user: User) {
        self.user = user
        self.nameLabel.text = user.username
        self.selfImage.image = nil
        
        if let selfImage = user.avatarEndpoint{
//            ImageController.imageForIdentifier(selfImage) { (image) -> Void in
//                self.selfImage.image = image
//            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
