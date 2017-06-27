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
    
    var curve: GDIAnimationCurveType? {
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
    
    let animatedView: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
        view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.75).cgColor
        view.layer.borderWidth = 5
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private static let controlPointSize = CGSize(width: 8, height: 8)
    
    let controlPoint1Layer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: controlPointSize)).cgPath
        layer.fillColor = UIColor.yellow.cgColor
        return layer
    }()
    
    let controlPoint2Layer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: controlPointSize)).cgPath
        layer.fillColor = UIColor.green.cgColor
        return layer
    }()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    convenience init(curve: GDIAnimationCurveType, frame: CGRect) {
        self.init(frame: frame)
        configure(for: curve)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 0.5
        layer.addSublayer(gridLayer)
        layer.addSublayer(controlPoint1Layer)
        layer.addSublayer(controlPoint2Layer)
        addSubview(animatedView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(for animationCurve: GDIAnimationCurveType) {
        curve = animationCurve
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayers()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        performAnimation()
    }
    
    private func performAnimation() {
        guard let curve = curve else { return }
        let animation = UIViewPropertyAnimator(duration: 1.0, timingParameters: GDIAnimationCurve(curve))
        animatedView.frame = CGRect(origin: CGPoint.zero, size: animatedView.frame.size)
        
        animation.addAnimations {
            self.animatedView.frame = CGRect(origin: CGPoint(x: self.gridLayer.frame.width, y: 0), size: self.animatedView.frame.size)
        }
        animation.addCompletion { (position) in
            if position == UIViewAnimatingPosition.end {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    self.performAnimation()
                })
            }
        }
        animation.startAnimation()
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
        
        let cp1Origin = CGPoint(x: control1.x - controlPoint1Layer.frame.width * 0.5, y: control1.y - controlPoint1Layer.frame.height * 0.5)
        let cp2Origin = CGPoint(x: control2.x - controlPoint2Layer.frame.width * 0.5, y: control2.y - controlPoint2Layer.frame.height * 0.5)
        controlPoint1Layer.frame = CGRect(origin: cp1Origin, size: controlPoint1Layer.frame.size)
        controlPoint2Layer.frame = CGRect(origin: cp2Origin, size: controlPoint2Layer.frame.size)
        
        if curveLayer.superlayer == nil {
            layer.addSublayer(curveLayer)
        }
    }
}

