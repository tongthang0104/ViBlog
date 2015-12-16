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
    //    let users: [User] = []
    var delegate: BlogChannelTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//         loadBlogChannels(UserController.shareController.current!)
        
    }
    
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
                loadBlogChannels(currentUser)
            }
        } else {
            tabBarController?.performSegueWithIdentifier("noCurrentUserSegue", sender: nil)
        }
    }
    
    func loadBlogChannels(user: PFUser) {
        BlogController.fetchBlogsForUser(user) { (blog) -> Void in
            if let blog = blog {
                self.blogs = blog
                
                self.tableView.reloadData()
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

protocol BlogChannelTableViewControllerDelegate {
    func likeButtonTapped (sender: UIButton)
}
