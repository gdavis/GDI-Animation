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
//    case softIn
//    case softOut
    case softInOut
    case strongIn
    case strongOut
    case strongInOut
    case slamIn
    case slamOut
    case strongBounceIn
    case strongBounceOut
    case dramaticEaseIn
    case dramaticEaseOut
    
    private func controlPoints(for type: GDIAnimationCurveType) -> (CGPoint, CGPoint)? {
        switch type {
        case .linear:
            return (CGPoint(x: 0, y: 0),        CGPoint(x: 1, y: 1))
            
        // soft
        case .softInOut:
            return (CGPoint(x: 0.5, y: 0),      CGPoint(x: 0.5, y: 1))
            
        // strong
        case .strongIn:
            return (CGPoint(x: 0.1, y: 1),      CGPoint(x: 0.1, y: 1))
        case .strongOut:
            return (CGPoint(x: 0.9, y: 0.1),     CGPoint(x: 1, y: 0.1))
        case .strongInOut:
            return (CGPoint(x: 0.9, y: 0),     CGPoint(x: 0.1, y: 1))
            
        // slam!
        case .slamIn:
            return (CGPoint(x: 0, y: 1),        CGPoint(x: 0, y: 1))
        case .slamOut:
            return (CGPoint(x: 1, y: 0),        CGPoint(x: 1, y: 0))
            
        // strong bounce
        case .strongBounceIn:
            return (CGPoint(x: 0.1, y: 1.5),    CGPoint(x: 0.75, y: 1))
        case .strongBounceOut:
            return (CGPoint(x: 0.1, y: 0),     CGPoint(x: 1, y: -0.75))
            
        // dramatic bounce
        case .dramaticEaseIn:
            return (CGPoint(x: 0.5, y: 1.5),    CGPoint(x: 0.5, y: 1))
        case .dramaticEaseOut:
            return (CGPoint(x: 0, y: 1),        CGPoint(x: 0, y: 1))
            
        default: return nil
        }
    }
    
    public var cubicTimingParameters: UICubicTimingParameters? {
        guard let cp1 = controlPoint1, let cp2 = controlPoint2 else { return nil }
        return UICubicTimingParameters(controlPoint1: cp1, controlPoint2: cp2)
    }
    public var springTimingParameters: UISpringTimingParameters? {
        return nil
    }
    
    public var controlPoint1: CGPoint? {
        return controlPoints(for: self)?.0
    }
    
    public var controlPoint2: CGPoint? {
        return controlPoints(for: self)?.1
    }
    
    public var name: String {
        switch self {
        case .linear:
            return "Linear"
        case .softInOut:
            return "Soft In Out"
        case .strongIn:
            return "Strong In"
        case .strongOut:
            return "Strong Out"
        case .strongInOut:
            return "Strong In Out"
        case .slamIn:
            return "Slam In"
        case .slamOut:
            return "Slam Out"
        case .strongBounceIn:
            return "Strong Bounce In"
        case .strongBounceOut:
            return "Strong Bounce Out"
        case .dramaticEaseIn:
            return "Dramatic Ease In"
        case .dramaticEaseOut:
            return "Dramatic Ease Out"
        }
    }
}

public class GDIAnimationCurve: UITimingCurveProvider {
    
    private enum EncodingKey: String {
        case gdiCurveType
    }
    
    public let gdiCurveType: GDIAnimationCurveType
    
    public init(_ curveType: GDIAnimationCurveType) {
        gdiCurveType = curveType
    }
    
    // MARK: - UITimingCurveProvider
    
    public var timingCurveType: UITimingCurveType {
        let cubicParams = gdiCurveType.cubicTimingParameters
        let springParams = gdiCurveType.springTimingParameters
        if cubicParams != nil && springParams != nil {
            return .composed
        } else if cubicParams != nil {
            return .cubic
        } else if springParams != nil {
            return .spring
        }
        return .builtin
    }
    public var cubicTimingParameters: UICubicTimingParameters? {
        return gdiCurveType.cubicTimingParameters
    }
    public var springTimingParameters: UISpringTimingParameters?
    
    // MARK: - NSCoding
    
    public required init?(coder aDecoder: NSCoder) {
        gdiCurveType = GDIAnimationCurveType(rawValue: Int(aDecoder.decodeInt32(forKey: EncodingKey.gdiCurveType.rawValue))) ?? .linear
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(gdiCurveType.rawValue, forKey: EncodingKey.gdiCurveType.rawValue)
    }
    
    // MARK: - NSCopying
    
    public func copy() -> Any {
        return GDIAnimationCurve(gdiCurveType)
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        return copy()
    }
}
