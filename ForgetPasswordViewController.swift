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
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView ()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = UIColor.myBlueColor()
        Color.blurEffect(self.backgroundImage, image: UIImage(named: "lens")!)
    }

    @IBAction func resetButtonTapped(sender: UIButton) {
        
        self.activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        self.view.addSubview(self.activityIndicator)

        if self.emailTextField.text != "" {
            
            self.activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
        UserController.resetPassword(self.emailTextField.text!) { (success, error) -> Void in
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if success {
                let alert = UIAlertController(title:"Your request has already successfully proccessed", message: "Please check your email to reset your password", preferredStyle: .Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (_) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.emailTextField.text = ""
                    })

                }))
                self.presentViewController(alert, animated: true, completion: nil)


            } else {
                self.resetPasswordAlert("\(error!.localizedDescription)", message: "")
            }
        }
        } else {
            self.resetPasswordAlert("Please enter your email address", message: "")        }
        
    }
    
    func resetPasswordAlert(title: String, message: String) {
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
