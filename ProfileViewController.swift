//  ProfileViewController.swift
//  ViBlog
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.


import UIKit
import iAd
//import BTNavigationDropdownMenu


class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    // MARK: Properties
    
    var user: User!
    
    static let shareController = ProfileViewController()
    var following: [User]? {
        didSet {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.collectionView.reloadData()
            })
        }
    }
    
    var userBlogs: [Blog] = []
    var avatarImage: UIImage?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: UpdateWithUser
    
    func updateWithUser(user: User) {
        
        self.user = user
        self.title = user.username
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.myWhiteColor()]
        
        if user != UserController.shareController.current {
            self.navigationItem.rightBarButtonItem?.enabled = false
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clearColor()
        }
        
        BlogController.blogsForUser(user) { (blogs) -> Void in
            if let blogs = blogs {
                self.userBlogs = blogs
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.collectionView.reloadData()
                })
            }
        }
    }
    
    //MARK: ViewController Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        if user == nil {
            user = UserController.shareController.current as? User
             self.updateWithUser(user)
        } else {
            self.updateWithUser(user)
        }
       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        if user == nil {
//            user = UserController.shareController.current as? User
//        }
        UserController.followedByUser(UserController.shareController.current!) { (followed) -> Void in
            self.following = followed
        }
        
        self.canDisplayBannerAds = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        //        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        //            self.collectionView.reloadData()
        //        })
        
    }
    
    //MARK: - Action:
    
    @IBAction func moreOptionButtonTapped(sender: UIBarButtonItem) {
        let moreOptionAlert = UIAlertController(title: "Select your option", message: "", preferredStyle: .ActionSheet)
        moreOptionAlert.addAction(UIAlertAction(title: "Edit Profile", style: .Default, handler: { (_) -> Void in
            self.performSegueWithIdentifier("editProfile", sender: self)
        }))
        
        moreOptionAlert.addAction(UIAlertAction(title: "Logout", style: .Default, handler: { (_) -> Void in
            UserController.logoutCurrentUser({ (success) -> Void in
                if success {
                    self.user = nil
                    self.tabBarController?.performSegueWithIdentifier("noCurrentUserSegue", sender: nil)
                } else {
                    print("error")
                }
            })
            
        }))
        
        moreOptionAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(moreOptionAlert, animated: true, completion: nil)
    }
    
    //MARK: - CollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userBlogs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCellWithReuseIdentifier("videoCell", forIndexPath: indexPath) as! VideoCollectionViewCell
        let blogs = userBlogs[indexPath.item]
        item.updateWithBlogs(blogs)
        item.backgroundView = UIImageView(image: UIImage(named: "photoFrame2"))
        
        return item
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "profileHeaderView", forIndexPath: indexPath) as! ProfileHeaderCollectionReusableView
        
        view.updateWithUsers(user)
        
        
        return view
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
