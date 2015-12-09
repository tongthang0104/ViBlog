//
//  VideoController.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/16/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class VideoController {
    

    
    // upload Videos
    static func uploadVideo(video: PFFile, completion: (identifier: String?)-> Void) {
        
        completion(identifier: "-k12312492hfnasd")
    }

    // Video for ID
    static func videoForID(identifier: String, completion: (video: AVPlayer?) -> Void) {
        
        let filePath = NSBundle.mainBundle().pathForResource("Sample", ofType: ".m4v", inDirectory: "")
        let url = NSURL(fileURLWithPath: filePath!)
        completion(video: AVPlayer(URL: url))
    }
    
}