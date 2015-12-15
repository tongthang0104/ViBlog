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
    
    static func uploadImage (image: UIImage, completion: (identifier: String?) -> Void) {
        
        
        
    
//        
//        
////        
////        if let data = data as? String {
////            let image = UIImage(base64: data)
////            completion(image: image)
////        }
//        let file = PFFile(name: "image", data: data)
//        //        file.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
//        //            if succeeded {
//        //                //2
//        //                self.saveWallPost(file)
//        //            } else if let error = error {
//        //                //3
//        //                self.showErrorView(error)
//        //            }
//        //            }, progressBlock: { percent in
//        //                //4
//        //                print("Uploaded: \(percent)%")
//        //        })
//        completion(identifier: "-K1l4125TYvKMc7rcp5e")
//    }
//    static func imageForIdentifier(identifer: String, completion: (image: UIImage?) -> Void) {
//        completion(image: UIImage(named: "defaultPhoto"))
//    }
//    
//    //    static func userHasProfilePicture
    
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