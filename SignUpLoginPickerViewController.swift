//
//  SignUpLoginPickerViewController.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit

class SignUpLoginPickerViewController: UIViewController {
    
    
    @IBOutlet weak var backgroundImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.tintColor = UIColor.myBlueColor()
        Color.blurEffect(self.backgroundImage, image: UIImage(named: "lens")!)
//        UINavigationBar.appearance().hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

