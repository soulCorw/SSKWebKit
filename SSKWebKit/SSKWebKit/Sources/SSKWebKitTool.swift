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
