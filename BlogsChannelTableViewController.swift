//
//  BlogsChannelTableViewController.swift
//  ViBlog
//
//  Created by Thang H Tong on 1/1/16.
//  Copyright © 2016 Thang. All rights reserved.
//

import UIKit
import iAd

class BlogsChannelTableViewController: UITableViewController {

    var adBannerView: ADBannerView = ADBannerView()
    var isAdsDisplayed = false
    var  blogs: [Blog] = []
    var blog: Blog!

    override func viewDidLoad() {
        super.viewDidLoad()

        interstitialPresentationPolicy = .Manual
        UIViewController.prepareInterstitialAds()
        
        let timer = NSTimer(fireDate: NSDate(timeIntervalSinceNow: 10), interval: 0, target: self, selector: "displayAds", userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    func displayAds() {
        if displayingBannerAd {
            canDisplayBannerAds = false
        }
        requestInterstitialAdPresentation()
        canDisplayBannerAds = true
    }

    //MARK: - Action
 
    
    @IBAction func userRefreshTableView(sender: UIRefreshControl) {
        loadBlogChannels(UserController.shareController.current!)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Check if there is User, if there is no user, go to SignUpLoginPickerView
        if let currentUser = UserController.shareController.current {
            if blogs.count > 0 {
                // loadBlogChannels(currentUser)
                
                
            }
        } else {
            tabBarController?.performSegueWithIdentifier("noCurrentUserSegue", sender: nil)
        }
    }
    
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toVideoDetail" {
            if let videoDetailViewDestination = segue.destinationViewController as? BlogsDetailTableViewController {
                _ = videoDetailViewDestination.view
                
                if let indexPath = tableView.indexPathForSelectedRow {
                    let blog = self.blogs[indexPath.row]
                    videoDetailViewDestination.updateWithBlog(blog)
                }
            }
        }
    }

}

