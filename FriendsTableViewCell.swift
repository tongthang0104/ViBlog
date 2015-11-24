//
//  FriendsTableViewCell.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/23/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selfImage: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    
    
    
    
    @IBAction func followButtonTapped(sender: UIButton) {
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
