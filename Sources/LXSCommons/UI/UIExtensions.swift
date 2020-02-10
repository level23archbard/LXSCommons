//
//  UIExtensions.swift
//  LXSCommons
//
//  Created by Alex Rote on 3/4/15.
//  Copyright (c) 2015 Alex Rote. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

// Extensions relating to UIKit classes
// UIImage
// UIGestureRecognizer
// UIPanGestureRecognizer
// NSLayoutConstraint

#if os(iOS)

public extension UIImage {
    
    func image(byApplyingAlpha alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, CGFloat(0.0))
        defer {
            UIGraphicsEndImageContext()
        }
        
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return self
        }
        guard let cgImage = cgImage else {
            return self
        }
        
        let area = CGRect(origin: CGPoint.zero, size: size)
        
        ctx.scaleBy(x: 1.0, y: -1.0)
        ctx.translateBy(x: 0.0, y: -area.height)
        ctx.setBlendMode(.multiply)
        ctx.setAlpha(alpha)
        
        ctx.draw(cgImage, in: area)
        
        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
            return newImage
        } else {
            return self
        }
    }
    
    func image(rotatedByDegrees degrees: CGFloat, flipHorizontally flip: Bool = false) -> UIImage {
        return image(rotatedByRadians: degrees * CGFloat.pi / 180.0, flipHorizontally: flip)
    }
    
    func image(rotatedByRadians radians: CGFloat, flipHorizontally flip: Bool = false) -> UIImage {
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        rotatedViewBox.transform = CGAffineTransform(rotationAngle: radians)
        let rotatedSize = rotatedViewBox.frame.size
        
        UIGraphicsBeginImageContextWithOptions(rotatedSize, false, CGFloat(0.0))
        defer {
            UIGraphicsEndImageContext()
        }
        
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return self
        }
        guard let cgImage = cgImage else {
            return self
        }
        
        ctx.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0)
        ctx.rotate(by: radians)
        if flip {
            ctx.scaleBy(x: -1.0, y: -1.0)
        } else {
            ctx.scaleBy(x: 1.0, y: -1.0)
        }
        ctx.setBlendMode(.multiply)
        
        ctx.draw(cgImage, in: CGRect(center: CGPoint.zero, size: size))
        
        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
            return newImage
        } else {
            return self
        }
    }
    
    func image(changedByOrientation orientation: UIImage.Orientation) -> UIImage {
        if let cgImage = cgImage {
            return UIImage(cgImage: cgImage, scale: 1.0, orientation: orientation)
        } else {
            return self
        }
    }
}

public extension UIGestureRecognizer {
    
    var location: CGPoint {
        return location(in: view)
    }
    
    func cancel() {
        let original = isEnabled
        isEnabled = false
        isEnabled = original
    }
}

public extension UIPanGestureRecognizer {
    
    var velocity: CGPoint {
        return velocity(in: view)
    }
}

#endif

public extension NSLayoutConstraint {
    
    func activate() {
        isActive = true
    }
    
    func deactivate() {
        isActive = false
    }
}

public extension Array where Element == NSLayoutConstraint {
    
    func activate() {
        NSLayoutConstraint.activate(self)
    }
    
    func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }
}
