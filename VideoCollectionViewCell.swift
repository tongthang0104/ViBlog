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
    
    @IBOutlet weak var videoThumbnails: UIImageView!
    var blog: Blog?
    var video: NSURL?
    //TODO: Need to add Video Properties
    @IBOutlet weak var captionLabel: UILabel!
    
    func updateWithBlogs(identifier: String) {
   
        self.videoThumbnails.image = nil
        self.captionLabel.text = blog!.caption
        
//        ImageController.imageForIdentifier(identifier) { (image) -> Void in
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.videoThumbnails.image = image
//            })
//        }
        
        //TODO: Update Video
        
        
    }
}
