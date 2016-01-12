//
//  ReportTableViewController.swift
//  ViBlog
//
//  Created by Thang H Tong on 1/12/16.
//  Copyright © 2016 Thang. All rights reserved.
//

import UIKit

class ReportTableViewController: UITableViewController, UITextFieldDelegate {
    
    var blog: Blog?
    
    @IBOutlet weak var reasonTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       }
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(sender: UIButton) {
        
        if self.reasonTextField.text == "" {
            
            submitButton.enabled = false
            
        } else {
            
            self.submitButton.enabled = true
            
            BlogController.reportBlog(UserController.shareController.current! as! User, blog: self.blog!, text: self.reasonTextField.text!, completion: { (success) -> Void in
                if success {
                    self.reasonTextField.text = ""
                    self.noticeAlert("Report succeed", message: "")
                } else {
                    self.noticeAlert("Report Unsuccessful", message: "Please try again")
                }
            })
        }
    }
    
    func noticeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (_) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.text == "" {
            self.submitButton.enabled = false
        } else {
            self.submitButton.enabled = true
        }
        return textField.resignFirstResponder()
    }
    
    
}
