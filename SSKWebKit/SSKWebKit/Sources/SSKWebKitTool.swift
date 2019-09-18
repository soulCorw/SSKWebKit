//
//  SSKWebKitTool.swift
//  SSKWebKit
//
//  Created by mac on 2019/9/17.
//  Copyright © 2019 SSK. All rights reserved.
//

import UIKit

class SSKWebKitTool {

    //
    static func transform(for image: UIImage, orientation: UIImage.Orientation) -> (UIImage, UIImage) {
        return (image, UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: orientation))
    }
    
    static func makeToolBarNextImage() -> (UIImage, UIImage) {
        return (UIImage(named: "toolbar_next_unavailable")!,
                self.transform(for: UIImage(named: "toolbar_back_available")!, orientation: .down).1)
    }
    
    static func makeToolBarBackImage() -> (UIImage, UIImage) {
        return (UIImage(named: "toolbar_back_available")!,
                self.transform(for: UIImage(named: "toolbar_next_unavailable")!, orientation: .down).1)
    }
    
    static func address<T: AnyObject>(o: T) -> String {
        // https://www.jianshu.com/p/84f244ec49dd
        // https://www.jianshu.com/p/a4c524630393
        return String.init(format: "%018p", unsafeBitCast(o, to: Int.self))
    }
}


internal extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: alpha
        )
    }
    
    
    
    
    
}

extension Bundle {
    
    static func sskWebkitBundle() -> Bundle? {
        if let path = Bundle(for: SSKWebNavigationToolBar.self).path(forResource: "SSKWebKit", ofType: "bundle") {
            return Bundle(path: path)
        }
        return  nil
    }
    
    static func backIcon() -> UIImage? {
        return UIImage(named: "toolbar_back_available", in: Bundle.sskWebkitBundle(), compatibleWith: nil)
       
    }
    
    static func nextIcon()-> UIImage? {
        return UIImage(named: "toolbar_next_unavailable", in: Bundle.sskWebkitBundle(), compatibleWith: nil)
    }
    
    static func makeToolBarNextImage() -> (UIImage, UIImage) {
        return (nextIcon()!,
                SSKWebKitTool.transform(for: backIcon()!, orientation: .down).1)
    }
    
    static func makeToolBarBackImage() -> (UIImage, UIImage) {
        return (backIcon()!,
                SSKWebKitTool.transform(for: nextIcon()!, orientation: .down).1)
    }
}
