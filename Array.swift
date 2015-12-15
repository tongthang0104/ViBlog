//
//  Array.swift
//  ViBlog
//
//  Created by Thang H Tong on 12/15/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import Foundation

extension Array {
    
    public func removeObject<T : Equatable>(object: T,  var fromArray array: [T])
    {
        let index = array.indexOf(object)
        array.removeAtIndex(index!)
    }

}