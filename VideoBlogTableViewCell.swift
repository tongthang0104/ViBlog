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
    var like: Like?
        var likeArray: [Like] = []
    var caption: String?
    var blog: Blog!
    var videoOfUrl: NSURL?
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var likeLabel: UILabel!
    
    //MARK: Action
    
    @IBAction func avatarButtonTapped(sender: AnyObject) {
        
        
        
    }
    
    func likeButtonTapped(sender: UIButton) {
        
        guard let currentUser = UserController.shareController.current else {return}
        BlogController.userLikeBlog(currentUser, blog: self.blog) { (liked) -> Void in
            if liked {
                print("already liked")
                if let blog = self.blog {
                    self.updateWithBlogs(blog)
                }
                
                BlogController.unlikeBlog(currentUser, blog: self.blog, completion: { (success) -> Void in
                    if success {
                        self.updateWithBlogs(self.blog)
                    } else {
                        print("failed to unlike")
                    }
                })
            } else {
                BlogController.likeBlogs(self.blog) { (success, blog) -> Void in
                    if let blog = blog {
                        self.updateWithBlogs(blog)
                        // self.likeArray.append(like)
                    }
                }
            }
        }
        
    }
    
    //MARK: - Update Blog
    
    func updateWithBlogs(blog: Blog) {
        self.blog = blog
        
        self.nameLabel.text = blog.user.username
        
        if let caption = blog.caption {
            if self.caption == caption {
                self.captionLabel.text = self.caption
            }
        } else {
            self.captionLabel.text = " "
        }
        self.captionLabel.text = blog.caption
        if let avatar = blog.user["avatar"] as? PFFile {
            ImageController.fetchImageAtURL(NSURL(string: avatar.url!)!, completion: { (image) -> () in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.avatarButton.setBackgroundImage(image, forState: .Normal)
                })
            })
        } else {
            self.avatarButton.setBackgroundImage(ImageController.defaultImage, forState: .Normal)
        }
        VideoController.fetchImageAtURL(NSURL(string: blog.video.url!)!, completion: { (video) -> () in
            
            self.videoOfUrl = video
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.playBackgroundMovie(self.videoOfUrl!)
            })
        })
        
        guard let currentUser = UserController.shareController.current else {return}
        BlogController.userLikeBlog(currentUser, blog: self.blog) { (liked) -> Void in
            if liked {
                self.likeButton.setBackgroundImage(UIImage(named: "unlikeButton"), forState: .Normal)
            } else {
                self.likeButton.setBackgroundImage(UIImage(named: "likeButton"), forState: .Normal)
            }
        }
        
        self.likeLabel.text = "\(likeArray.count) likes"

//        if let  like = BlogChannelTableViewController.shareController.like {
//        self.likeLabel.text = "\(like.count) likes"
//        } else {
//            BlogChannelTableViewController.shareController.like = []
//        }

            BlogController.likeForBlog(blog) { (like) -> Void in
               self.likeArray = like
            }
    }
    
    //MARK: - AV Player
    
    var avPlayer = AVPlayer()
    func playBackgroundMovie(url: NSURL){
        
        avPlayer = AVPlayer(URL: url)
        
        let moviePlayer = AVPlayerViewController()
        //self.addChildViewController(moviePlayer)
        moviePlayer.player = avPlayer
        moviePlayer.view.bounds = self.videoView.bounds
        moviePlayer.view.center = self.videoView.center
        moviePlayer.view.frame = CGRectMake(0, 0, self.videoView.frame.size.width, self.videoView.frame.size.height)
        moviePlayer.view.sizeToFit()
        moviePlayer.videoGravity = AVLayerVideoGravityResizeAspect
        moviePlayer.showsPlaybackControls = true
        
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


