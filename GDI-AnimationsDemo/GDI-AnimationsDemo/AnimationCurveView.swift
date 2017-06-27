//
//  AnimationCurveView.swift
//  GDI-AnimationsDemo
//
//  Created by Grant Davis on 6/27/17.
//  Copyright © 2017 Grant Davis Interactive. All rights reserved.
//

import UIKit
import QuartzCore
import GDI_Animation

class AnimationCurveView: UIView {
    
    var curve: GDIAnimationCurve? {
        didSet {
            updateLayers()
        }
    }
    
    let curveLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.red.cgColor
        layer.lineWidth = 2
        return layer
    }()
    
    let gridLayer: CALayer = {
        let layer = CALayer()
        layer.borderWidth = 1
        layer.borderColor = UIColor.blue.cgColor
        return layer
    }()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    convenience init(curve: GDIAnimationCurve, frame: CGRect) {
        self.init(frame: frame)
        configure(for: curve)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 0.5
        layer.addSublayer(gridLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func configure(for animationCurve: GDIAnimationCurve) {
        curve = animationCurve
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayers()
    }
    
    private func updateLayers() {
        guard let curve = curve else { return }
        
        let width = gridLayer.frame.width
        let height = gridLayer.frame.height
        let path = CGMutablePath()
        let verticalOffset = (bounds.height - height) * 0.5
        let start = CGPoint(x: 0, y: verticalOffset + height)
        let end = CGPoint(x: width, y: verticalOffset + 0)
        path.move(to: start)
        
        let control1 = CGPoint(x: width * curve.controlPoint1.x, y: verticalOffset + height - height * curve.controlPoint1.y)
        let control2 = CGPoint(x: width * curve.controlPoint2.x, y: verticalOffset + height - height * curve.controlPoint2.y)
        path.addCurve(to: end, control1: control1, control2: control2)
        curveLayer.path = path
        
        curveLayer.frame = bounds
        gridLayer.frame = CGRect(origin: CGPoint(x: 0, y: verticalOffset), size: intrinsicContentSize)
        
        if curveLayer.superlayer == nil {
            layer.addSublayer(curveLayer)
        }
    }
}
