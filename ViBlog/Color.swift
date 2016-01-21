//
//  Color.swift
//  ViBlog
//
//  Created by Thang H Tong on 12/15/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static func myRedColor() -> UIColor {
        return UIColor(red:0.4, green:0.02, blue:0.1, alpha:1)
    }
    
    static func myYellowColor() -> UIColor {
        return UIColor(red:0.99, green:0.82, blue:0.04, alpha:1)
    }
    
    static func myPurpleColor() -> UIColor {
        return  UIColor(red:0.47, green:0.38, blue:0.4, alpha:1)
    }
    
    static func myBlueColor() -> UIColor {
        return  UIColor(red:0.12, green:0.8, blue:0.87, alpha:1)
    }
    
    static func lightBrown() -> UIColor {
        return UIColor(red:0.24, green:0.02, blue:0.01, alpha:1)
    }
    
    static func darkBlue() -> UIColor {
        return UIColor(red:0.16, green:0.2, blue:0.54, alpha:1)
    }
    static func myGray() -> UIColor {
        return UIColor(red:0.45, green:0.45, blue:0.45, alpha:1)
    }
    
    static func myWhiteColor() -> UIColor {
        return UIColor(red:0.99, green:0.99, blue:0.99, alpha:1)
    }
    static func myDarkBrown() -> UIColor {
        return UIColor(red:0.29, green:0.2, blue:0.15, alpha:1)
    }
    static func myGreenColor() -> UIColor {
        return UIColor(red:0.77, green:0.92, blue:0.78, alpha:1)
    }
    static func myYellow() -> UIColor {
        return UIColor(red:0.89, green:0.87, blue:0, alpha:1)
    }
}

class Color {
    
    static func setupAppearanceColor() {
        UINavigationBar.appearance().tintColor = UIColor.myWhiteColor()
        UITabBar.appearance().tintColor = UIColor.myDarkBrown()
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "backgroundNavigationBar"), forBarMetrics: .Default)
        UITabBar.appearance().backgroundImage = UIImage(named: "backgroundTabBar")
    }
    static func blurEffect(view: UIView, image: UIImage) {
        view.backgroundColor = UIColor(patternImage: image)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        view.addSubview(blurEffectView)
    }
    
}
