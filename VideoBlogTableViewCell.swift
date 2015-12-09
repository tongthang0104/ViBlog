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
    
    @IBOutlet weak var videoThumbnailView: UIImageView!
    
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
        
    
        self.nameLabel.text = blog.user.username
        if self.caption == blog.caption {
            self.captionLabel.text = self.caption
        }
        
//        self.videoThumbnailView.image = nil
        
//        ImageController.imageForIdentifier(blog.videoSnapShot) { (image) -> Void in
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.videoThumbnailView.image = image
//            })
//        }
//        self.videoThumbnailView.image = UIImage(named: blog.videoSnapShot)
        
//        self.likeLabel.text = "\(blog.like!.count) likes"
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
