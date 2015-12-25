//
//  ImageController.swift
//  ViBlog
//
//  Created by Thang H Tong on 11/23/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import Foundation
import UIKit

class ImageController {
    
    static func fetchImageAtURL(url: NSURL, completion: (image: UIImage) -> ()) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (data != nil) {
                let image = UIImage(data: data!)
                completion(image: image!)
            } else {
                completion(image: UIImage())
            }
            }
            .resume()
    }
    
    static let defaultImage = UIImage(named: "defaultPhoto")
    
    // TODO: Not finish
    static func createThumbnails(thumbnails: UIImage, blog: Blog, completion: (success: Bool, error: NSError?) -> Void) {
        
        let imageData = UIImageJPEGRepresentation(thumbnails, 0.5)
        let imageFile = PFFile(name: "image.jpg", data: imageData!)
        
        do {
            try imageFile?.save()
        } catch {
            
        }
        guard let imageFiles = imageFile else {return}
        blog.setObject(imageFiles, forKey: "thumbnails")
        blog.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                completion(success: success, error: nil)
            } else {
                completion(success: false, error: error)
                print(error?.localizedDescription)
            }
        }
        
    }
    
    
    
    
    
    
    
}

extension UIImage {
    
    var base64String: String? {
        
        guard let data = UIImageJPEGRepresentation(self, 0.8) else {
            
            return nil
        }
        
        return data.base64EncodedStringWithOptions(.EncodingEndLineWithCarriageReturn)
    }
    
    convenience init?(base64: String) {
        
        if let imageData = NSData(base64EncodedString: base64, options: .IgnoreUnknownCharacters) {
            self.init(data: imageData)
        } else {
            return nil
        }
    }
}