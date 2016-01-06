//
//  UserSearchResultTableViewController.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit

class UserSearchResultTableViewController: UITableViewController {

    var filterUsers = [User] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterUsers.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userSearchCell", forIndexPath: indexPath) as! FriendsTableViewCell
        let users = filterUsers[indexPath.row]
        cell.updateWithUsers(users)
        
        return cell
    }
  
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.backgroundView == nil {
            let cellBackgroundView = UIImageView()
            cellBackgroundView.image = UIImage(named: "friendBackground")
            cell.backgroundView = cellBackgroundView
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sender = tableView.cellForRowAtIndexPath(indexPath)
        self.presentingViewController?.performSegueWithIdentifier("toProfileView", sender: sender)
    }
}
