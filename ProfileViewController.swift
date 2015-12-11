//
//  ProfileViewController.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit
//import BTNavigationDropdownMenu


class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate , ProfileHeaderCollectionReusableViewDelegate  {
    
    // MARK: Properties
    var user: User?
    var userBlogs: [Blog] = []
    var avatarImage: UIImage?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    // UpdateWithUser
    
    func updateWithUser(user: User) {
        //        self.user = user
        self.title = user.username
        
        if user != UserController.shareController.current {
            
            // as of writing there is no system way to remove a bar button item
            // disables and hides the button
            
            self.navigationItem.rightBarButtonItem?.enabled = false
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clearColor()
            
            self.navigationItem.leftBarButtonItem?.enabled = false
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clearColor()
            
            self.navigationItem.leftBarButtonItem?.enabled = false
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.clearColor()
            
            self.navigationItem.leftBarButtonItem?.enabled = false
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.clearColor()
        }
        BlogController.blogsForUser(user.objectId!) { (blogs) -> Void in
            if let blogs = blogs {
                self.userBlogs = blogs
                self.collectionView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if user == nil {
//                    user = PFUser.currentUser()
//                }
        
        //        tabBarController?.tabBar(<#T##tabBar: UITabBar##UITabBar#>, didSelectItem: self.tabBarItem) {
        
        
    }
    
    @IBAction func moreOptionButtonTapped(sender: UIBarButtonItem) {
        let moreOptionAlert = UIAlertController(title: "Select your option", message: "", preferredStyle: .ActionSheet)
        moreOptionAlert.addAction(UIAlertAction(title: "Edit Profile", style: .Default, handler: { (_) -> Void in
            self.performSegueWithIdentifier("editProfile", sender: self)
        }))
        
        moreOptionAlert.addAction(UIAlertAction(title: "Logout", style: .Default, handler: { (_) -> Void in
            UserController.logoutCurrentUser()
            self.tabBarController?.performSegueWithIdentifier("noCurrentUserSegue", sender: nil)
        }))
        
        moreOptionAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(moreOptionAlert, animated: true, completion: nil)
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = user {
            
            UserController.userForIdentifier(user.objectId!) { (user) -> Void in
                if let user = user {
                self.user = user
                self.updateWithUser(user)
                }
            }
        
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userBlogs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCellWithReuseIdentifier("videoCell", forIndexPath: indexPath) as! VideoCollectionViewCell
        let blogs = userBlogs[indexPath.item]
        //        item.updateWithBlogs(blogs.videoSnapShot)
        
        return item
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "profileHeaderView", forIndexPath: indexPath) as! ProfileHeaderCollectionReusableView
        view.delegate = self
        if let user = self.user {
            view.updateWithUsers(user)
        }
        
        return view
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func followButtonTapped(sender: UIButton) {
        
        //        UserController.userFollowUser(UserController.shareController.currentUser, followee: user) { (follows) -> Void in
        //            if follows {
        //                UserController.unfollowUser(user, completion: { (success) -> Void in
        //                    self.updateWithUser(user)
        //                })
        //            } else {
        //                UserController.followUser(user, completion: { (success) -> Void in
        //                    self.updateWithUser(user)
        //                })
        //            }
        //        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toDetailVideo" {
            
            let cell = sender as! UICollectionViewCell
            if let selectedIndex = collectionView.indexPathForCell(cell)?.item {
                
                if let detailViewDestionation = segue.destinationViewController as? BlogsDetailTableViewController {
                    _ = detailViewDestionation.view
                    detailViewDestionation.updateWithBlog(userBlogs[selectedIndex])
                }
            }
        }
    }
    
    
}
