//
//  ProfileViewController.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate , ProfileHeaderCollectionReusableViewDelegate{
    
    // MARK: Properties
    var user: User?
    var userBlogs: [Blog] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    // UpdateWithUser
    
    func updateWithUser(user: User) {
        self.user = user
        self.title = user.username
        
        BlogController.blogsForUser(user.username) { (blogs) -> Void in
            if let blogs = blogs {
                self.userBlogs = blogs
                self.collectionView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: -UICollectionDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userBlogs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCellWithReuseIdentifier("videoCell", forIndexPath: indexPath) as! VideoCollectionViewCell
        let blogs = userBlogs[indexPath.item]
        item.updateWithBlogs(blogs)
        
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
    
    func followButtonTapped(sender: UIButton) {
        
        guard let user = self.user else {return}
        UserController.userFollowUser(UserController.shareController.currentUser, followee: user) { (follows) -> Void in
            if follows {
                UserController.unfollowUser(user, completion: { (success) -> Void in
                    self.updateWithUser(user)
                })
            } else {
                UserController.followUser(user, completion: { (success) -> Void in
                    self.updateWithUser(user)
                })
            }
        }
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
