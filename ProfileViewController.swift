//
//  ProfileViewController.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate , ProfileHeaderCollectionReusableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: Properties
    var user: User?
    var userBlogs: [Blog] = []
    var avatarImage: UIImage?
    
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
        
        if user == nil {
            user = UserController.shareController.currentUser
        }
       
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
    
    
    func avatarButtonTapped(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let avatarAlert = UIAlertController(title: "Select avatar location", message: nil, preferredStyle: .Alert)
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            avatarAlert.addAction(UIAlertAction(title: "Library", style: .Default, handler: { (_) -> Void in
                imagePicker.sourceType = .PhotoLibrary
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            avatarAlert.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (_) -> Void in
                imagePicker.sourceType = .Camera
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true) { () -> Void in
            self.view.window?.endEditing(true)
            if let avatarImage = self.avatarImage {
                UserController.addAvatar(avatarImage, completion: { (user, success) -> Void in
                    if success {
                        
                    }
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
