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
        completion(identifier: "-K1l4125TYvKMc7rcp5e")
    }
    
    static func imageForIdentifier(identifer: String, completion: (image: UIImage?) -> Void) {
        completion(image: UIImage(named: "defaultPhoto"))
    }
    
}