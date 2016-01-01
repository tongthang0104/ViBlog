//
//  BlogsChannelTableViewController.swift
//  ViBlog
//
//  Created by Thang H Tong on 1/1/16.
//  Copyright © 2016 Thang. All rights reserved.

import UIKit
import iAd

class BlogsChannelTableViewController: UITableViewController {

    // MARK: - Properties
    
    var adBannerView: ADBannerView = ADBannerView()
    var isAdsDisplayed = false
    var  blogs: [Blog] = []
    var blog: Blog!
    var oldIndexPath: NSIndexPath? = nil

    //MARK: - Action

    @IBAction func userRefreshTableView(sender: UIRefreshControl) {
        loadBlogChannels(UserController.shareController.current!)
    }
    
    //MARK: - ViewController Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if let indexPath = oldIndexPath as NSIndexPath! {
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Check if there is User, if there is no user, go to SignUpLoginPickerView
        if let currentUser = UserController.shareController.current {
            if blogs.count > 0 {
                print(currentUser)
//                 loadBlogChannels(currentUser)
            }
        } else {
            tabBarController?.performSegueWithIdentifier("noCurrentUserSegue", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interstitialPresentationPolicy = .Manual
        UIViewController.prepareInterstitialAds()
        let timer = NSTimer(fireDate: NSDate(timeIntervalSinceNow: 10), interval: 0, target: self, selector: "displayAds", userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    // MARK: - All Functions
    
    func loadBlogChannels(user: PFUser) {
        BlogController.fetchBlogsForUser(user) { (blog) -> Void in
            if let blog = blog {
                self.blogs = blog
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    func displayAds() {
        if displayingBannerAd {
            canDisplayBannerAds = false
        }
        requestInterstitialAdPresentation()
        canDisplayBannerAds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let indexSet = NSIndexSet(index: 0)
//        tableView.reloadSections(indexSet, withRowAnimation: .Automatic)
//        indexPath.row == 1
        let cell = tableView.dequeueReusableCellWithIdentifier("videoBlogCell", forIndexPath: indexPath) as! VideoBlogTableViewCell
        let blog = blogs[indexPath.row]
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            cell.updateWithBlogs(blog)
        })
        return cell
    }

    //MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toVideoDetail" {
            if let videoDetailViewDestination = segue.destinationViewController as? BlogsDetailTableViewController {
                _ = videoDetailViewDestination.view
                
                if let indexPath = tableView.indexPathForSelectedRow {
                    self.oldIndexPath = indexPath
                    let blog = self.blogs[indexPath.row]
                    videoDetailViewDestination.updateWithBlog(blog)
                }
            }
        }
    }
}

