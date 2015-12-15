//
//  VideoBlogTableViewCell.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/28/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit
import MobileCoreServices
import AVFoundation
import Parse


class VideoBlogTableViewCell: UITableViewCell, BlogChannelTableViewControllerDelegate {
    
    //MARK: Properties
    var user: User?
    var like: [Like] = []
    var caption: String?
    var blog: Blog!
    
    
//    @IBOutlet weak var videoThumbnailView: UIImageView!
    
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var likeLabel: UILabel!
    
    //MARK: Action
    
    @IBAction func avatarButtonTapped(sender: AnyObject) {
    }
    
    func likeButtonTapped(sender: UIButton) {
        BlogController.likeBlogs(self.blog) { (success, blog) -> Void in
            if let blog = blog {
                self.updateWithBlogs(blog)
             
            }
        }
    }
    //TODO: load Like status
    //TODO: load Unfollow function
    
    
    func updateWithBlogs(blog: Blog) {
        self.blog = blog
        
        self.nameLabel.text = blog.user.username
        if self.caption == blog.caption {
            self.captionLabel.text = self.caption
        }
        self.captionLabel.text = blog.caption
//        self.videoThumbnailView.image = nil
        
        
        
//        VideoController.videoForID(<#T##identifier: String##String#>) { (video) -> Void in
//            self.playBackgroundMovie(<#T##url: NSURL##NSURL#>)
//        }
//        self.videoThumbnailView.image = nil
        
//        ImageController.imageForIdentifier(blog.videoSnapShot) { (image) -> Void in
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.videoThumbnailView.image = image
//            })
//        }
//        self.videoThumbnailView.image = UIImage(named: blog.videoSnapShot)
        
        self.likeLabel.text = "\(like.count) likes"
    }
    
    var avPlayer = AVPlayer()
    
    func playBackgroundMovie(url: NSURL){
        
        avPlayer = AVPlayer(URL: url)
        
        let moviePlayer = AVPlayerViewController()
//        self.addChildViewController(moviePlayer)
        
        moviePlayer.player = avPlayer
        moviePlayer.view.bounds = self.videoView.bounds
        moviePlayer.view.center = self.videoView.center
        moviePlayer.view.frame = CGRectMake(0, 0, self.videoView.frame.size.width, self.videoView.frame.size.height)
        moviePlayer.view.sizeToFit()
        moviePlayer.videoGravity = AVLayerVideoGravityResizeAspect
        moviePlayer.showsPlaybackControls = true
        
        avPlayer.play()
        videoView.addSubview(moviePlayer.view)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "playerReachedEnd",
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object: nil)
    }
    
    
    
    func playerReachedEnd() {
        avPlayer.seekToTime(CMTimeMakeWithSeconds(0, 1))
        avPlayer.pause()
        
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


