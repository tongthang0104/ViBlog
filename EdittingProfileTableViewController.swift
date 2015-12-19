//
//  EdittingProfileTableViewController.swift
//  ViBlog
//
//  Created by Thang H Tong on 12/4/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit

class EdittingProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var avatarImage: UIImage?

    //MARK: ViewController Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        self.avatarButton.imageView?.contentMode = .ScaleAspectFill
        if let currentUser = UserController.shareController.current {
            self.updateWithUser(currentUser)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.avatarButton.imageView?.contentMode = .ScaleAspectFill
        if let currentUser = UserController.shareController.current {
        self.updateWithUser(currentUser)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.myWhiteColor()]
        }
    }
    
    //MARK: - Action
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func submitButtonTapped(sender: UIButton) {
        
        // Avatar Picker
        self.view.window?.endEditing(true)
        if let avatarImage = avatarImage {
            
          UserController.addAvatar(avatarImage, completion: { (success) -> Void in
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.presentAlert("Failed to upload image", message: "Press OK to dismiss")
            }
          })
//            UserController.addAvatar(avatarImage, completion: { (user, success) -> Void in
//                if success {
//                    self.dismissViewControllerAnimated(true, completion: nil)
//                } else {
//                    self.presentAlert("Failed to upload image", message: "Press OK to dismiss")
//                }
//            })
        }
        
        // Edit Profile Information
        
        if let usernameTextField = self.usernameTextField.text {
//            UserController.updateUser(self.user!, username: usernameTextField, email: self.emailTextField.text) { (user, success) -> Void in
//                if success {
//                    self.dismissViewControllerAnimated(true, completion: nil)
//                } else {
//                    self.presentAlert("Failed to updated", message: "Press OK to dismiss")
//                }
//            }
        }
        
        if self.usernameTextField.text == "" || self.emailTextField.text == "" {
            presentAlert("Missing Information", message: "Please enter a valid information and retry")
        }
    }
    
    // Alert
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func avatarButtonTapped(sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let avatarAlert = UIAlertController(title: "Select avatar location", message: nil, preferredStyle: .ActionSheet)
        
        //Library Picker
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            avatarAlert.addAction(UIAlertAction(title: "Library", style: .Default, handler: { (_) -> Void in
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
        }
        //Camera
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            avatarAlert.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (_) -> Void in
                imagePicker.sourceType = .Camera
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
        }
        
        avatarAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(avatarAlert, animated: true, completion: nil)
        })
    }
    
    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.avatarImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.avatarButton.setBackgroundImage(self.avatarImage, forState: .Normal)
        })
        
        avatarButton.setTitle("", forState: .Normal)
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        default:
            return 1
        }
    }
    
    //MARK: - Update With User
    
    func updateWithUser(user: PFUser) {
//        self.user = user
        self.usernameTextField.text = user.username
//        self.companyTextField.text = user.username
        self.emailTextField.text = user.email
    }
 
}

extension EdittingProfileTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
