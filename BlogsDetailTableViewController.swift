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


class BlogsDetailTableViewController: UITableViewController {

    
    var videoOfUrl: NSURL?
    var blog: Blog!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var avatarButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
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
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.videoOfUrl = video
                self.playBackgroundMovie(self.videoOfUrl!)
            })
        })
    }
    
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
        
        avPlayer.play()
        self.videoView.addSubview(moviePlayer.view)
    }

    @IBAction func avatarButtonTapped(sender: UIButton) {
        
    }
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        
        
        
        
        
    }

    @IBAction func addCommentButtonTapped(sender: UIButton) {
        
    }

    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }

    
   
    
    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! BlogCommentTableViewCell

//        let comment = blog.comments![indexPath.row]
        cell.textLabel?.text = blog.user.username
        return cell
    }


    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Comments"
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
