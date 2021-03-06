//
//  SignUpLoginViewController.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit
import Parse
import SafariServices

class SignUpLoginViewController: UIViewController {
    
    //MARK: Properties
    
    var user: PFUser?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView ()
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginSignUpButton: UIButton!
    
    @IBOutlet weak var agreementLabel: UILabel!
    
    //MARK: - ViewMode
    
    enum ViewMode {
        case Login
        case Signup
    }
    var mode: ViewMode = .Signup
    
    var isValidOrNot: Bool {
        get {
            switch mode {
            case .Login:
                return !((usernameTextField.text == "") || (passwordTextField.text == ""))
            case .Signup:
                return !((usernameTextField.text == "") || (passwordTextField.text == "") || (confirmPasswordTextField.text == "") || (emailTextField.text == ""))
            }
        }
    }
    
    func updateWithMode(mode: ViewMode) {
        switch mode {
        case .Login:
            emailTextField.removeFromSuperview()
            confirmPasswordTextField.removeFromSuperview()
            self.agreementLabel.text = "By Signing in, you agree to the"
            loginSignUpButton.setTitle("", forState: .Normal)
            loginSignUpButton.setBackgroundImage(UIImage(named: "loginButton"), forState: .Normal)
            
            
        case .Signup:
            loginSignUpButton.setTitle("", forState: .Normal)
            loginSignUpButton.setBackgroundImage(UIImage(named: "signup"), forState: .Normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.tintColor = UIColor.myBlueColor()
        Color.blurEffect(self.backgroundImageView, image: UIImage(named: "lens")!)
        
        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        
        self.updateWithMode(mode)
        //        Color.blurEffect(self.tableView.backgroundView, image: UIImage(named: "lens")!)
        
        
    }
    
    func termPolicy(url: NSURL) {
        let termOfServiceVC = SFSafariViewController(URL: url)
        presentViewController(termOfServiceVC, animated: true, completion: nil)

    }
    //MARK: Action
    
    @IBAction func eulaTapped(sender: UIButton) {
        termPolicy(NSURL(string: "http://visnap.co/category/eula/")!)
    }
    @IBAction func termOfServiceTapped(sender: UIButton) {
       termPolicy(NSURL(string: "http://visnap.co/2016/01/21/terms-of-service/")!)
    }
    @IBAction func privacyPolicyTapped(sender: UIButton) {
        termPolicy(NSURL(string: "http://visnap.co/category/privacy-policy/")!)
    }
    
    @IBAction func loginSignupButtonTapped(sender: UIButton) {
        
        //Activity Indicator View
        
        self.activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = .Gray
        self.view.addSubview(self.activityIndicator)
        
        
        if isValidOrNot {
            
            self.activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            switch mode {
                
                //Login
                
            case .Login:
                UserController.authenticateUsers(usernameTextField.text!, password: passwordTextField.text!, completion: { (user, success) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if success {
                        
                        UserController.shareController.current = PFUser.currentUser()
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                        
                        
                    } else {
                        self.alertNotification("Invalid Information", message: "Please check your information and try again")
                    }
                })
                
                // Signup
                
            case .Signup:
                
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if (self.passwordTextField.text?.characters.count <= 5){
                    self.alertNotification("Password too short", message: "Please enter a password that has more than 5 characters")
                } else if self.confirmPasswordTextField.text != self.passwordTextField.text {
                    self.alertNotification("Password must match", message: "Please try again")
                    
                } else {
                    UserController.createUser(usernameTextField.text!, password: passwordTextField.text!, email: emailTextField.text!, completion: { (user, success, error) -> Void in
                        if success {
                            UserController.shareController.current = PFUser.currentUser()
                            self.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            self.alertNotification("\(error!.localizedDescription)", message: "Please try again")
                        }
                    })
                }
            }
            
        } else {
            
            self.alertNotification("Missing Information", message: "Please check your information and try again")
            
        }
    }
    
    func alertNotification(title: String, message: String) {
        let failedAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        failedAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(failedAlert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SignUpLoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let yCoordinate = self.view.frame.origin.y + 160
        let scrollDestination = CGPointMake(0.0, yCoordinate)
        scrollView.setContentOffset(scrollDestination, animated: true)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let yNewCoordinate = self.view.frame.origin.y
        let scrollNewDestination = CGPointMake(0.0, yNewCoordinate)
        scrollView.setContentOffset(scrollNewDestination, animated: true)
    }
}
