//
//  GDIPropertyAnimation.swift
//  GDI-Animation
//
//  Created by Grant Davis on 6/27/17.
//  Copyright © 2017 Grant Davis Interactive. All rights reserved.
//

import Foundation

public enum GDIAnimationCurve {
    case linear
    case exponential
    
    public var controlPoint1: CGPoint {
        switch self {
        case .linear:
            return CGPoint(x: 0, y: 0)
        case .exponential:
            return CGPoint(x: 1, y: 0)
        }
    }
    
    public var controlPoint2: CGPoint {
        switch self {
        case .linear:
            return CGPoint(x: 1, y: 1)
        case .exponential:
            return CGPoint(x: 1, y: 0)
        }
    }
}

public class GDIPropertyAnimation {
    
    public class func animator(usingCurve curve: GDIAnimationCurve, duration: TimeInterval, animations: @escaping () -> Void) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: duration, controlPoint1: curve.controlPoint1, controlPoint2: curve.controlPoint2, animations: animations)
        
        return animator
    }
}
