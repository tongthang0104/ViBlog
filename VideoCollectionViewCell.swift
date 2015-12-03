//
//  VideoCollectionViewCell.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/27/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import UIKit
import AVFoundation


class VideoCollectionViewCell: UICollectionViewCell {
    
    var blog: Blog?
    var video: AVPlayer?
    //TODO: Need to add Video Properties
    @IBOutlet weak var captionLabel: UILabel!
    
    func updateWithBlogs(blog: Blog) {
        
        self.blog = blog
        self.captionLabel.text = blog.caption
        
        
        //TODO: Update Video
        
        
    }
}
