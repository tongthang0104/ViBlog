//
//  SignUpLoginViewController.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit

class SignUpLoginViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginSignUpButton: UIButton!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
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
                return !((usernameTextField.text == "") || (passwordTextField.text == ""))
            }
        }
    }
    
    func updateWithMode(mode: ViewMode) {
        switch mode {
        case .Login:
            emailTextField.removeFromSuperview()
            emailLabel.removeFromSuperview()
            loginSignUpButton.setTitle("Login", forState: .Normal)
        case .Signup:
            loginSignUpButton.setTitle("Signup", forState: .Normal)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateWithMode(mode)
        // Do any additional setup after loading the view.
    }
    
    //MARK: Action
    
    @IBAction func loginSignupButtonTapped(sender: UIButton) {
        if isValidOrNot {
            switch mode {
            case .Login:
                UserController.authenticateUsers(usernameTextField.text!, password: passwordTextField.text!, completion: { (user, success) -> Void in
                    if success {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.alertNotification("Invalid Information", message: "Please check your information and try again")
                    }
                })
            case .Signup:
                UserController.createUser(usernameTextField.text!, password: passwordTextField.text!, email: emailTextField.text, completion: { (user, success) -> Void in
                    if success {
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                        // If success maybe lead user to Login Mode so he can login or automatically logging in
                    } else if (self.passwordTextField.text?.characters.count <= 5){
                        self.alertNotification("Password too short", message: "Please enter a password that has more than 5 characters")
                    } else {
                        self.alertNotification("Invalid Information", message: "Please check your information and try again")
                                           
                    }
                })
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
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
