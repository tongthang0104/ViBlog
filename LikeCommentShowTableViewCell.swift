//
//  LikeCommentShowTableViewCell.swift
//  ViBlog
//
//  Created by Thang H Tong on 1/24/16.
//  Copyright © 2016 Thang. All rights reserved.
//

import UIKit

class LikeCommentShowTableViewCell: UITableViewCell {

    
    var blog: Blog!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    
    var delegate: LikeCommentShowTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func likeButtonTapped(sender: UITableViewCell) {
        self.delegate?.likeButtonTapped(sender)
    }
    
    func updateLikeWithBlog(blog: Blog) {
        self.blog = blog
        
        self.addCustomSeperator(UIColor.grayColor())
        guard let currentUser = UserController.shareController.current else {return}
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            BlogController.userLikeBlog(currentUser, blog: blog) { (liked) -> Void in
                if liked {
                    self.likeButton.setBackgroundImage(UIImage(named: "thumbupFilled"), forState: .Normal)
                } else {
                    self.likeButton.setBackgroundImage(UIImage(named: "thumbup"), forState: .Normal)
                }
            }
        })
        
        self.likeCount.text =  "\(blog.likeFromUser.count)"
        self.commentCount.text = "\(blog.comment.count)"
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

protocol LikeCommentShowTableViewCellDelegate {
    func likeButtonTapped(sender: UITableViewCell)
}