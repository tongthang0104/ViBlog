//
//  VideoCollectionViewCell.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/27/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit
import AVFoundation
import Parse


class VideoCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var videoThumbnails: UIImageView!
    var blog: Blog?
    var video: NSURL?
    //TODO: Need to add Video Properties
    @IBOutlet weak var captionLabel: UILabel!
    
    //MARK: - UpdateWithBlog
    
    func updateWithBlogs(blog: Blog) {
        
        self.blog = blog
        self.videoThumbnails.image = nil
        self.captionLabel.text = blog.caption
        
        if let thumbnails = blog["thumbnails"] as? PFFile {
            ImageController.fetchImageAtURL(NSURL(string: thumbnails.url!)!, completion: { (image) -> () in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.videoThumbnails.image = image
                })
            })
        }
        
        //TODO: Update Video
    }
}
