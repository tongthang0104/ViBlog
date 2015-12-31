//
//  FriendsSearchTableViewController.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit
import iAd

class FriendsSearchTableViewController: UITableViewController, UISearchResultsUpdating {
    
    // MARK: Properties
    
    var searchController: UISearchController!
    //    var user: User?
    var userDataSource: [User] = []
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    enum ViewMode: Int {
        case Friends = 0
        case AllChannels = 1
        
        func users(completion: (users: [User]?) -> Void) {
            switch self {
            case .Friends:
                UserController.followedByUser(UserController.shareController.current!, completion: { (followed) -> Void in
                    if let followed = followed{
                        completion(users: followed)
                    }
                })
            case .AllChannels:
                UserController.fetchAllUsers({ (users) -> Void in
                    completion(users: users)
                })
            }
        }
    }
    
    var mode: ViewMode {
        get {
            return ViewMode(rawValue: segmentControl.selectedSegmentIndex)!
        }
    }
    
    // MARK: Search Controller
    
    func setUpSearchController() {
        let resultsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("userSearchResult")
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text?.lowercaseString else {return}
        let resultsViewController = searchController.searchResultsController as! UserSearchResultTableViewController
        resultsViewController.filterUsers = self.userDataSource.filter({$0.username!.lowercaseString.containsString(searchTerm)})
        resultsViewController.tableView.reloadData()
    }
    
    // MARK: Update With Function
    
    func updateBaseOnMode(mode: ViewMode) {
        mode.users { (users) -> Void in
            if let users = users {
                self.userDataSource = users
            } else {
                self.userDataSource = []
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        self.canDisplayBannerAds = true
        updateBaseOnMode(mode)
        setUpSearchController()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        self.tableView.reloadData()
    }
    
    @IBAction func selectIndexChanged(sender: UISegmentedControl) {
        updateBaseOnMode(mode)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDataSource.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("friendsCell", forIndexPath: indexPath) as! FriendsTableViewCell
        // cell.backgroundView = UIImageView(image: UIImage(named: "friendBackground"))
        let users = userDataSource[indexPath.row]
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            cell.updateWithUsers(users)
        })
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.backgroundView == nil {
            let cellBackgroundView = UIImageView()
            cellBackgroundView.image = UIImage(named: "friendBackground")
            cell.backgroundView = cellBackgroundView
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toProfileView" {
            
            guard let cell = sender as? UITableViewCell else {return}
            var selectedUser: User?
            
            // Check to see if indexPath is from searchResultsController or not ?
            
            if let indexPath = (searchController.searchResultsController as? UserSearchResultTableViewController)?.tableView.indexPathForCell(cell) {
                
                // IndexPath is from UserSearchResultTableVC
                
                if let filterUsers = (searchController.searchResultsController as? UserSearchResultTableViewController)?.filterUsers {
                    selectedUser = filterUsers[indexPath.row]
                }
            } else {
                
                // IndexPath from friendSearchTableViewController
                if let indexPath = tableView.indexPathForCell(cell) {
                    selectedUser = self.userDataSource[indexPath.row]
                }
            }
            if let profileDestionationViewController = segue.destinationViewController as? ProfileViewController {
                profileDestionationViewController.user = selectedUser!
            }
        }
    }
}
