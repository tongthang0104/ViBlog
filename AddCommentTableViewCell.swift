//
//  AddCommentTableViewCell.swift
//  ViBlog
//
//  Created by Thang H Tong on 12/28/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit

class AddCommentTableViewCell: UITableViewCell, BlogsDetailTableViewControllerDelegate {
    
    //MARK: - Properties
    
    var blog: Blog!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Add Comment Function
    
    func addComment() {
        
        if self.commentTextField.text == "" {
   
        } else {
            BlogController.addComment(self.blog, text: self.commentTextField.text!) { (success, comment) -> Void in
                if success {
                    NSNotificationCenter.defaultCenter().postNotificationName("updateComment", object: comment)
                    self.blog.comment = comment
                    self.commentTextField.text = ""
                } else {
                    print("failed to upload")
                }
            }
        }
    }
    
    //MARK: - Keyboard customize
    
    func addDoneButtonOnKeyboard() {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = .Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "ADD", style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneButtonAction"))
    
        var items: [UIBarButtonItem] = []
        items.append(flexSpace)
        items.append(done)

        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.commentTextField.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction() {
       self.addComment()
    }
    
    //MARK: - Update With User
    
    func updateWithUser(blog: Blog, user: User) {
        self.blog = blog
        if let avatar = user["avatar"] as? PFFile {
            ImageController.fetchImageAtURL(NSURL(string: avatar.url!)!) { (image) -> () in
                //dispatch main queue to load image in main thread for faster speed
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.avatarImage.image = image
                })
            }
        }
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}






