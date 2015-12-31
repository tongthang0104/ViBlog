//
//  BlogsDetailTableViewController.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import iAd


class BlogsDetailTableViewController: UITableViewController, ADBannerViewDelegate {
    
    //MARK: - Properties
    
    var adBannerView: ADBannerView = ADBannerView()
    var isAdsDisplayed = false
    var videoOfUrl: NSURL?
    var delegate: BlogsDetailTableViewControllerDelegate?
    var blog: Blog!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var avatarButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    //MARK: - Update With Blog
    
    func updateWithBlog(blog: Blog){
        
        self.blog = blog
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
    }
    
   
    //MARK: - AV Player
    
    var avPlayer = AVPlayer()
    func playBackgroundMovie(url: NSURL){
        
        avPlayer = AVPlayer(URL: url)
        
        let moviePlayer = AVPlayerViewController()
        self.addChildViewController(moviePlayer)
        moviePlayer.player = avPlayer
        moviePlayer.view.bounds = self.videoView.bounds
        moviePlayer.view.center = self.videoView.center
        moviePlayer.view.frame = CGRectMake(0, 0, self.videoView.frame.size.width, self.videoView.frame.size.height)
        moviePlayer.view.sizeToFit()
        moviePlayer.videoGravity = AVLayerVideoGravityResizeAspect
        moviePlayer.showsPlaybackControls = true
        self.videoView.addSubview(moviePlayer.view)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "playerReachedEnd",
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object: nil)
    }
    
    func playerReachedEnd() {
        avPlayer.seekToTime(CMTimeMakeWithSeconds(0, 1))
        avPlayer.pause()
    }
    
    //MARK: - ViewController cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.canDisplayBannerAds = true
        adBannerView.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadCommentTableView", name: "updateComment", object: nil)
    }
    
    func reloadCommentTableView () {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    
    
    //MARK: - Action
    
    @IBAction func avatarButtonTapped(sender: UIButton) {
    }
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        default:
            return blog.comment.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("addComment", forIndexPath: indexPath) as! AddCommentTableViewCell
            let user = UserController.shareController.current! as! User
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                cell.updateWithUser(self.blog, user: user)
            })
            self.delegate = cell
            self.nameLabel.text = user.username

            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! BlogCommentTableViewCell
            
            let comment = blog.comment[indexPath.row]
            cell.updateWithComment(comment, nameLabel: self.nameLabel)
            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                
//            })
//            
            
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Add your comments"
        default:
            return "Comments"
        }
    }
    

    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        isAdsDisplayed = false
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

protocol BlogsDetailTableViewControllerDelegate {
    func addComment()
    func addDoneButtonOnKeyboard()
}

extension BlogsDetailTableViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.delegate?.addDoneButtonOnKeyboard()
    }
   
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
