//
//  VideoBlogTableViewCell.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/28/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit
import AVKit


class VideoBlogTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var user: User?
    var like: [Like] = []
    var caption: String?
    var blog: Blog?
    
    
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var likeLabel: UILabel!
    
    //MARK: Action
    
    @IBAction func avatarButtonTapped(sender: AnyObject) {
    }
    
    
    func updateWithBlogs(blog: Blog) {
        self.blog = blog
        
        if let avatarImage = blog.avatarEndPoint {
            self.avatarButton.setBackgroundImage(UIImage(named: avatarImage), forState: UIControlState.Normal)
        }
        let playerController = AVPlayerViewController()
      
        self.nameLabel.text = blog.username
        if self.caption == blog.caption {
            self.captionLabel.text = self.caption
        }
        
        VideoController.videoForID(blog.videoEndPoint) { (video) -> Void in
            playerController.player = video
            playerController.view = self.videoView
        }
        self.likeLabel.text = "\(blog.like.count) likes"
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
