//
//  UITableviewCellExtension.swift
//  ViBlog
//
//  Created by Thang H Tong on 1/19/16.
//  Copyright © 2016 Thang. All rights reserved.
//

import Foundation

extension UITableViewCell {
    
    func addCustomSeperator(lineColor: UIColor) {
        let seperatorView = UIView(frame: CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width + 200, height: 1))
        seperatorView.backgroundColor = lineColor
        self.addSubview(seperatorView)
    }
}

extension UICollectionReusableView {
    func addCustomeSeparator(lineColor: UIColor) {
        let seperatorView = UIView(frame: CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width + 200, height: 1))
        seperatorView.backgroundColor = lineColor
        self.addSubview(seperatorView)
    }
}