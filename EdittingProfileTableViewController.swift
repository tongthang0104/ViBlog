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
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView ()
    
    var avatarImage: UIImage?
    
    //MARK: ViewController Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        self.avatarButton.imageView?.contentMode = .ScaleAspectFill
        if let currentUser = UserController.shareController.current as? User {
            self.updateWithUser(currentUser)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.avatarButton.imageView?.contentMode = .ScaleAspectFill
        if let currentUser = UserController.shareController.current as? User {
            self.updateWithUser(currentUser)
            self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.myWhiteColor()]
        }
    }
    
    //MARK: - Action
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func submitButtonTapped(sender: UIButton) {
        
        
        self.activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        self.view.addSubview(self.activityIndicator)

        // Avatar Picker
        self.view.window?.endEditing(true)
        
        self.activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        if let avatarImage = avatarImage {
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            UserController.addAvatar(avatarImage, completion: { (success) -> Void in
                if success {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.presentAlert("Failed to upload image", message: "Press OK to dismiss")
                }
            })
        }
        
        // Edit Profile Information
        
        if let usernameTextField = self.usernameTextField.text {
            guard let emailTextField = self.emailTextField.text else {return}
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            UserController.updateUser(UserController.shareController.current! as! User, newUsername: usernameTextField, newEmail: emailTextField  ,completion: { (success, error) -> Void in
                if success {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    print(error?.localizedDescription)
                    self.presentAlert("\(error!.localizedDescription)", message: "")
                    
                    
                }
        })
        //            UserController.updateUser(UserController.shareController.current!.username!, password: UserController.shareController.current!.password!, newUsername: usernameTextField, completion: { (success) -> Void in
        //                if success {
        //                    self.dismissViewControllerAnimated(true, completion: nil)
        //                } else {
        //                    self.presentAlert("Failed to updated", message: "Press OK to dismiss")
        //
        //
        //                }
        //            })
        //            UserController.updateUser(UserController.shareController.current! as! User, username: usernameTextField, completion: { (user, success) -> Void in
        //                if success {
        //                    self.dismissViewControllerAnimated(true, completion: nil)
        //                } else {
        //                    self.presentAlert("Failed to updated", message: "Press OK to dismiss")
        //
        //
        //                }
        //            })
        //            UserController.updateUser(self.user!, username: usernameTextField, email: self.emailTextField.text) { (user, success) -> Void in
        //                if success {
        //                    self.dismissViewControllerAnimated(true, completion: nil)
        //                } else {
        //                    //            }
    }
    
    if self.usernameTextField.text == "" || self.emailTextField.text == "" {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
             self.presentAlert("Missing Information", message: "Please enter a valid information and retry")
        })
   
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
    return 2
}

override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
        return 1
    default:
        return 1
    }
}

//MARK: - Update With User

func updateWithUser(user: User) {
//            self.user = user
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
