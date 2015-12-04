//
//  EdittingProfileTableViewController.swift
//  ViBlog
//
//  Created by Thang H Tong on 12/4/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit

class EdittingProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var avatarButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    var avatarImage: UIImage?
    var user: User?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.avatarButton.imageView?.contentMode = .ScaleAspectFill
        self.updateWithUser(UserController.shareController.currentUser)
    }
    
    //MARK: - Action
    @IBAction func submitButtonTapped(sender: UIButton) {
        
        self.view.window?.endEditing(true)
        if let avatarImage = avatarImage {
            UserController.addAvatar(avatarImage, completion: { (user, success) -> Void in
                if success {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    let failedAlert = UIAlertController(title: "Failed!", message: "Image failed to post. Please try again.", preferredStyle: .Alert)
                    failedAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(failedAlert, animated: true, completion: nil)
                }
            })
        }
        
        UserController.updateUser(<#T##user: User##User#>, username: <#T##String#>, email: <#T##String?#>, completion: <#T##(user: User?, success: Bool) -> Void#>)
    }
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
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
        avatarImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        avatarButton.setBackgroundImage(avatarImage, forState: .Normal)
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
    
    func updateWithUser(user: User) {
        self.user = user
        self.usernameTextField.text = user.username
//        self.companyTextField.text = user.username
        self.emailTextField.text = user.email
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

//extension EdittingProfileTableViewController: UITextFieldDelegate {
//    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        <#code#>
//    }
//}
