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


class BlogsDetailTableViewController: UITableViewController, ADBannerViewDelegate, LikeCommentShowTableViewCellDelegate {
    
    //MARK: - Properties
    
    var adBannerView: ADBannerView = ADBannerView()
    var isAdsDisplayed = false
    var videoOfUrl: NSURL?
    var delegate: BlogsDetailTableViewControllerDelegate?
    var user: User?
    var avPlayer = AVPlayer()
    let session = AVAudioSession.sharedInstance()
    
    var blog: Blog!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var avatarButton: UIButton!
    
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var reportButton: UIBarButtonItem!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    //MARK: - Update With Blog
    
    func updateWithBlog(blog: Blog){
        
        self.blog = blog
        self.addCustomSeperator(UIColor.grayColor())
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
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.playBackgroundMovie(video)
            })
        })
        
        
        
        
        // Like update
        
        
        BlogController.checkReport(blog) { (isReported) -> Void in
            if isReported {
                self.reportButton.enabled = false
            } else {
                self.reportButton.enabled = true
            }
        }
        
    }
    
    
    //MARK: - AV Player
    
    func playBackgroundMovie(url: NSURL){
        
        self.avPlayer = AVPlayer(URL: url)
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setActive(true)
        }
        catch {
            print("Audio session setCategory failed")
        }
        
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
        
        //round Button
        
        self.avatarButton.layer.cornerRadius = 15
        self.avatarButton.layer.borderWidth = 1
        self.avatarButton.layer.borderColor = UIColor.blackColor().CGColor
        self.avatarButton.clipsToBounds = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadCommentTableView", name: "updateComment", object: nil)
        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.avPlayer.pause()
    }
    
    
  
    
    func reloadCommentTableView () {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    
    //MARK: - Action
    
    
    @IBAction func reportButtonTapped(sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Report", style: .Default, handler: { (_) -> Void in
            self.reportAlert("Why are you reporting this video" , message: "")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Report Function
    
    var textField: UITextField = UITextField()
    var isReported: Bool = false
    
    func reportAlert(title: String, message: String) {
        let reportAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        reportAlert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            self.textField = textField
            self.textField.placeholder = "Please enter your reason here"
        }
        
        reportAlert.addAction(UIAlertAction(title: "Submit", style: .Default, handler: { (_) -> Void in
            
            BlogController.reportBlog(UserController.shareController.current! as! User, blog: self.blog!, text: self.textField.text!, isReported: self.isReported, completion: { (success) -> Void in
                if success {
                    
                    self.isReported = true
                    self.reportButton.enabled = false
                    
                    self.noticeAlert("Report succeed", message: "")
                } else {
                    self.noticeAlert("Report Unsuccessful", message: "Please try again")
                }
            })
        }))
        
        reportAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(reportAlert, animated: true, completion: nil)
    }
    
    
    func noticeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (_) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func avatarButtonTapped(sender: UIButton) {
    }
    
    // Like Button
    
    func likeButtonTapped(sender: UITableViewCell) {
        guard let currentUser = UserController.shareController.current else {return}
        BlogController.userLikeBlog(currentUser, blog: self.blog) { (liked) -> Void in
            if liked {
                print("already liked")
                BlogController.unlikeBlog(currentUser, blog: self.blog, completion: { (success) -> Void in
                    if success {
                        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
                    } else {
                        print("failed to unlike")
                    }
                })
            } else {
                BlogController.likeBlogs(self.blog, completion: { (success, blog, like) -> Void in
                    if let _ = blog {
                        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
                    }
                })
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return blog.comment.count
        }
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 2 {
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 180.0
            return tableView.rowHeight
        } else {
            return 44
        }
    }
    
    var oldIndexPath: NSIndexPath? = nil
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("likeCommentCell", forIndexPath: indexPath) as! LikeCommentShowTableViewCell
            
            self.oldIndexPath = indexPath
            cell.updateLikeWithBlog(self.blog)
            cell.delegate = self
            
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("addComment", forIndexPath: indexPath) as! AddCommentTableViewCell
            let user = UserController.shareController.current! as! User
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                cell.updateWithUser(self.blog, user: user)
                
            })
            self.nameLabel.text = self.blog.user.username
            self.delegate = cell
            
            cell.backgroundView = UIView(frame: cell.bounds)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! BlogCommentTableViewCell
            
            let comment = blog.comment[indexPath.row]
            cell.updateWithComment(comment)
            
            cell.backgroundView = UIView(frame: cell.bounds)
            return cell
        }
        
        
    }
    
    func addCustomSeperator(lineColor: UIColor) {
        let seperatorView = UIView(frame: CGRect(x: 0, y: self.headerView.frame.height - 1, width: self.headerView.frame.width, height: 1))
        seperatorView.backgroundColor = lineColor
        self.headerView.addSubview(seperatorView)
    }
    
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        isAdsDisplayed = false
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationController = segue.destinationViewController as? ProfileViewController {
            _ = destinationController.view
            if segue.identifier == "toProfileView" {
                destinationController.user = self.blog.user as! User
            } else if segue.identifier == "toProfileView2" {
                
                if let indexPath = tableView.indexPathForSelectedRow {
                    let comment = blog.comment[indexPath.row]
                    destinationController.user = comment.fromUser
                }
            }
        }
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
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
        self.delegate?.addDoneButtonOnKeyboard()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}


