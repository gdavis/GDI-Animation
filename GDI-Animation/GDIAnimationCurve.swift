//
//  GDIPropertyAnimation.swift
//  GDI-Animation
//
//  Created by Grant Davis on 6/27/17.
//  Copyright © 2017 Grant Davis Interactive. All rights reserved.
//

import Foundation
import UIKit

public enum GDIAnimationCurveType: Int {
    case linear
    case hardEaseIn
    case hardEaseOut
    case dramaticEaseIn
    case dramaticEaseOut
    case quadBounceOut
    case quadBounceIn
    
    public var controlPoint1: CGPoint {
        switch self {
        case .linear:
            return CGPoint(x: 0, y: 0)
        case .hardEaseIn:
            return CGPoint(x: 1, y: 0)
        case .hardEaseOut:
            return CGPoint(x: 0, y: 1)
            
        case .dramaticEaseIn:
            return CGPoint(x: 0.75, y: 0)
        case .dramaticEaseOut:
            return CGPoint(x: 0, y: 1)
            
        case .quadBounceOut:
            return CGPoint(x: 0, y: 3)
        case .quadBounceIn:
            return CGPoint(x: 0, y: -3)
        }
    }
    
    public var controlPoint2: CGPoint {
        switch self {
        case .linear:
            return CGPoint(x: 1, y: 1)
        case .hardEaseIn:
            return CGPoint(x: 1, y: 0)
        case .hardEaseOut:
            return CGPoint(x: 0, y: 1)
            
        case .dramaticEaseIn:
            return CGPoint(x: 0.8, y: 1)
        case .dramaticEaseOut:
            return CGPoint(x: 0, y: 1)
            
        case .quadBounceOut:
            return CGPoint(x: 1, y: 0)
        case .quadBounceIn:
            return CGPoint(x: 1, y: 2)
        }
    }
}

public class GDIAnimationCurve: UITimingCurveProvider {
    public var timingCurveType: UITimingCurveType { return .cubic }
    public var cubicTimingParameters: UICubicTimingParameters? {
        return UICubicTimingParameters(controlPoint1: gdiCurveType.controlPoint1, controlPoint2: gdiCurveType.controlPoint2)
    }
    public var springTimingParameters: UISpringTimingParameters?
    
    public let gdiCurveType: GDIAnimationCurveType
    
    public init(_ curveType: GDIAnimationCurveType) {
        gdiCurveType = curveType
    }
    
    public required init?(coder aDecoder: NSCoder) {
        gdiCurveType = GDIAnimationCurveType(rawValue: Int(aDecoder.decodeInt32(forKey: "gdiCurveType"))) ?? .linear
    }
    
    public func encode(with aCoder: NSCoder) {
    }
    
    public func copy() -> Any {
        return GDIAnimationCurve(gdiCurveType)
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        return copy()
    }
}
