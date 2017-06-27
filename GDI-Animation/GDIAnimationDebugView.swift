//
//  GDIAnimationDebugView.swift
//  GDI-Animation
//
//  Created by Grant Davis on 6/27/17.
//  Copyright © 2017 Grant Davis Interactive. All rights reserved.
//

import Foundation

open class GDIAnimationDebugView: UIView {
    
    var curve: GDIAnimationCurve? {
        didSet {
            updateLayers()
        }
    }
    
    let curveLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth = 2
        return layer
    }()
    
    let animatedDot: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        view.backgroundColor = UIColor.white
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 12.5
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor
        layer.backgroundColor = UIColor.gray.cgColor
        
        addSubview(animatedDot)
    }
    
    public convenience init(curve: GDIAnimationCurveType, frame: CGRect) {
        self.init(frame: frame)
        configure(for: GDIAnimationCurve(curve))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func configure(for animationCurve: GDIAnimationCurve) {
        curve = animationCurve
        setNeedsDisplay()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateLayers()
    }
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        guard let _ = window else { return }
        performAnimation()
    }
    
    private func performAnimation() {
        guard let curve = curve else { return }
        
        // reset dot to left side
        animatedDot.transform = CGAffineTransform.identity
        
        // create animation to move to right side of view
        let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: curve)
        
        animator.addAnimations {
            self.animatedDot.transform = CGAffineTransform(translationX: 100, y: 0)
        }
        
        animator.addCompletion { (position) in
            guard position == .end else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.animatedDot.transform = CGAffineTransform.identity
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.performAnimation()
            })
        }
        
        animator.startAnimation()
    }
    
    private func updateLayers() {
        guard let curve = curve else { return }
        
        let path = CGMutablePath()
        let start = CGPoint(x: 0, y: bounds.height)
        let end = CGPoint(x: bounds.width, y: 0)
        path.move(to: start)
        
        let curveType = curve.gdiCurveType
        let control1 = CGPoint(x: bounds.width * curveType.controlPoint1.x, y: bounds.height - bounds.height * curveType.controlPoint1.y)
        let control2 = CGPoint(x: bounds.width * curveType.controlPoint2.x, y: bounds.height - bounds.height * curveType.controlPoint2.y)
        path.addCurve(to: end, control1: control1, control2: control2)
        curveLayer.path = path
        
        curveLayer.frame = bounds
        if curveLayer.superlayer == nil {
            layer.addSublayer(curveLayer)
        }
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
    }
}
