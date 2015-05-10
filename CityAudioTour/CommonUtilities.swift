//
//  CommonUtils.swift
//  CityAudioTour
//
//  Created by Juan Garcia on 5/9/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//
import UIKit

class CommonUtilities: NSObject {
    
    // MARK: Colours functions
    class func RGBA(#r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat)->UIColor{
        
        let color: UIColor = UIColor( red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: CGFloat(a) )
        return color
    }
    
    class func RGBColor(hexColor : NSString) -> UIColor{
        
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hexColorCode = hexColor as String
        
        if hexColorCode.hasPrefix("#")
        {
            let index   = advance(hexColorCode.startIndex, 1)
            let hex     = hexColorCode.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            
            if scanner.scanHexLongLong(&hexValue)
            {
                if count(hex) == 6
                {
                    red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF) / 255.0
                }
                else if count(hex) == 8
                {
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                }
                else
                {
                    print("invalid hex code string, length should be 7 or 9")
                }
            }
            else
            {
                println("scan hex error")
            }
        }
        
        let color: UIColor =  UIColor(red:CGFloat(red), green: CGFloat(green), blue:CGFloat(blue), alpha: 1.0)
        return color
    } 
}