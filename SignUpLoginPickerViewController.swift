//
//  SignUpLoginPickerViewController.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit

class SignUpLoginPickerViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationController = segue.destinationViewController as? SignUpLoginViewController {
            if segue.identifier == "toSignUpView" {
                destinationController.mode = .Signup
            } else if segue.identifier == "toLoginView" {
                destinationController.mode = .Login
            }
        }
    }
}

