//
//  BlogCommentTableViewCell.swift
//  ViBlog
//
//  Created by Thang H Tong on 12/7/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit

class BlogCommentTableViewCell: UITableViewCell {
    

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateWithComment(comment: Comment) {
        self.addCustomSeperator(UIColor.grayColor())
        let query = Comment.query()
        query?.includeKey("fromUser")
      
        query?.getObjectInBackgroundWithId(comment.objectId!, block: { (object, error) -> Void in
            if let comment = object as? Comment {
                self.commentTextView.text = comment.text
                self.usernameLabel.text = comment.fromUser.username
                if let avatar = comment.fromUser["avatar"] as? PFFile {
                    ImageController.fetchImageAtURL(NSURL(string: avatar.url!)!) { (image) -> () in
                        //dispatch main queue to load image in main thread for faster speed
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.avatarImage.image = image
                        })
                    }
                }
//                self.user = comment.fromUser
            }
        })
    }

}
