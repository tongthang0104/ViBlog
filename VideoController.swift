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
        
    // upload Videos
    
    static func getVideo(url: NSURL, completion: (video: NSURL) -> ()) {
        let blogQuery = Blog.query()
        
        
//        blogQuery?.whereKey("video", equa)
        blogQuery?.findObjectsInBackgroundWithBlock({ (object, error) -> Void in
            if let object = object {
                for videoObject in object {
                    let theVideo = videoObject.objectForKey("videoFile")
                    theVideo?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                        if let data = data {
                            let video = NSURL(dataRepresentation: data, relativeToURL: url)
                            completion(video: video)
                        }
                    })
                }
            }
        })
        
    }
    
    static func fetchImageAtURL(url: NSURL, completion: (video: NSURL) -> ()) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let data = data {
                let video = NSURL(dataRepresentation: data, relativeToURL: url)
                let videoFile = NSBundle.mainBundle().pathForResource("\(video)", ofType: "mov")
//                NSURL(fileURLWithPath: url)
                completion(video: video)
            } else {
                completion(video: url)
            }
            }
            .resume()
    }

    
    static func uploadVideo(video: PFFile, completion: (identifier: String?)-> Void) {
        
        completion(identifier: "-k12312492hfnasd")
    }

    
    static func takeSnapshot(url: NSURL) {
        let asset: AVAsset = AVAsset(URL: url)
        let duration: CMTime = asset.duration
        let snapshot = CMTimeMake(duration.value / 2, duration.timescale)
        
        let generator = AVAssetImageGenerator(asset: asset)
        let imageRef: CGImageRef = try! generator.copyCGImageAtTime(snapshot, actualTime: nil)
        
        let thumbnail: UIImage = UIImage(CGImage: imageRef)
        let data = UIImageJPEGRepresentation(thumbnail, 0.8)
        //let data = UIImagePNGRepresentation(thumbnail)
        let directory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        data?.writeToFile(directory, atomically: true)
    }
    
    // Video for ID
    static func videoForID(identifier: String, completion: (video: NSURL) -> Void) {
        
        let blogQuery = Blog.query()!
        
        blogQuery.getObjectInBackgroundWithId(identifier) { (object, error) -> Void in
            if let object = object {
                
            }
        }
        let filePath = NSBundle.mainBundle().pathForResource("Sample", ofType: ".m4v", inDirectory: "")
        let url = NSURL(fileURLWithPath: filePath!)
      completion(video: url)
    }
    
    
    
}