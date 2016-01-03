//
//  ForgetPasswordViewController.swift
//  ViBlog
//
//  Created by Thang H Tong on 1/2/16.
//  Copyright © 2016 Thang. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = UIColor.myBlueColor()
        Color.blurEffect(self.backgroundImage, image: UIImage(named: "lens")!)
    }

    @IBAction func resetButtonTapped(sender: UIButton) {
        if self.emailTextField.text != "" {
        UserController.resetPassword(self.emailTextField.text!) { (success, error) -> Void in
            if success {
                self.resetPasswordAlert("Your request already proccessed", message: "Please check your email to reset your password", completion: { () -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            } else {
                self.resetPasswordAlert("\(error!.localizedDescription)", message: "", completion: { () -> Void in
                     print(error?.localizedDescription)
                })
            }
        }
        } else {
            self.resetPasswordAlert("Please enter your email address", message: "", completion: { () -> Void in
                 //Display animation
            })
        }
        
    }
    
    func resetPasswordAlert(title: String, message: String, completion: () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
