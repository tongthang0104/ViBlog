//
//  BlogsDetailTableViewController.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit

class BlogsDetailTableViewController: UITableViewController {

    var blog: Blog!
    @IBOutlet weak var videoView: UIView!
    

    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var avatarButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func updateWithBlog(blog: Blog){
        
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
        
        return blog.comments.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! BlogCommentTableViewCell

        let comment = blog.comments[indexPath.row]
        cell.updateWithComment(comment)
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
