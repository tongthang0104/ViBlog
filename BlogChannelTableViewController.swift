//
//  BlogChannelTableViewController.swift
//  ViBlog
//
//  Created by Thang H Tong on 12/3/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit
import Parse

class BlogChannelTableViewController: UITableViewController {
    
    var  blogs: [Blog] = []
    var blog: Blog!
    var delegate: BlogChannelTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadBlogChannels(UserController.shareController.current!)
    }
    
    //MARK: - Action
    
    @IBAction func likeButtonTapped(sender: UIButton) {
        self.delegate?.likeButtonTapped(sender)
    }
    
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
                    self.refreshControl?.endRefreshing()
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return blogs.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("videoBlogCell", forIndexPath: indexPath) as! VideoBlogTableViewCell
        
        let blog = blogs[indexPath.row]
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            cell.updateWithBlogs(blog)
        })
        self.delegate = cell
        return cell
    }
    
    // MARK: - Navigation
    
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

protocol BlogChannelTableViewControllerDelegate {
    func likeButtonTapped (sender: UIButton)
}
