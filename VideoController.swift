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
import Parse

class VideoController {
        
    // download videos
    
//    static func getVideo(url: NSURL, completion: (video: NSURL) -> ()) {
//        let blogQuery = Blog.query()
//        
//        blogQuery?.findObjectsInBackgroundWithBlock({ (object, error) -> Void in
//            if let object = object {
//                for videoObject in object {
//                    let theVideo = videoObject.objectForKey("video")
//                    theVideo?.getDataInBackgroundWithBlock({ (data, error) -> Void in
//                        if let data = data {
//                            let video = NSURL(string:  "\(url)")
//                            completion(video: video!)
//                        }
//                    })
//                }
//            }
//        })
//    }
    
    static func fetchImageAtURL(url: NSURL, completion: (video: NSURL) -> ()) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let _ = data {
                let video = NSURL(string: "\(url)")
                completion(video: video!)
            } else {
                completion(video: url)
            }
            }
            .resume()
    }

    // Take snapshot
    
    static func takeSnapshot(url: NSURL) -> UIImage {
        let asset: AVAsset = AVAsset(URL: url)
        let duration: CMTime = asset.duration
        
//        let timeStamp = CMTime(seconds: 1.0, preferredTimescale: 60)
        let snapshot = CMTimeMake(duration.value / 2, duration.timescale)
        let generator = AVAssetImageGenerator(asset: asset)
        
        // This will help the image in right shape , otherwise it will automatically rotate 90 degree
        generator.appliesPreferredTrackTransform = true
        
        let imageRef: CGImageRef = try! generator.copyCGImageAtTime(snapshot, actualTime: nil)
        let thumbnail: UIImage = UIImage(CGImage: imageRef)
//        let data = UIImageJPEGRepresentation(thumbnail, 0.8)
        //let data = UIImagePNGRepresentation(thumbnail)
//        let directory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
//        data?.writeToFile(directory, atomically: true)
       return thumbnail
    }  
}