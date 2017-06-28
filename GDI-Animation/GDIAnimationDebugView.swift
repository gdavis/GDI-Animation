//
//  GDIAnimationDebugView.swift
//  GDI-Animation
//
//  Created by Grant Davis on 6/27/17.
//  Copyright © 2017 Grant Davis Interactive. All rights reserved.
//

import Foundation

open class GDIAnimationDebugView: UIView {
    
    // MARK: - Constants
    
    let graphSize = CGSize(width: 100, height: 100)
    
    // MARK: - Variables
    
    var autoplay: Bool = false
    public var animating: Bool {
        return self.animator != nil
    }
    
    var curve: GDIAnimationCurve? {
        didSet {
            setNeedsLayout()
        }
    }
    
    let curveLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.red.cgColor
        layer.lineWidth = 2
        return layer
    }()
    
    let animatedDot: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        view.backgroundColor = UIColor.white
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        view.layer.borderWidth = 3.0
        view.layer.cornerRadius = 12.5
        view.clipsToBounds = true
        return view
    }()
    
    private var offsetX: CGFloat {
        return bounds.midX - graphSize.width * 0.5
    }
    
    private var offsetY: CGFloat {
        return bounds.midY - graphSize.height * 0.5
    }
    
    private var animatedLineY: CGFloat {
        return offsetY + graphSize.height + animatedDot.frame.height * 0.5 + 5
    }
    
    // MARK: - Initialization
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: graphSize.width, height: graphSize.height + animatedDot.frame.height)
    }
    
    public convenience init(curve: GDIAnimationCurveType, frame: CGRect) {
        self.init(frame: frame)
        configure(for: GDIAnimationCurve(curve))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor
        layer.backgroundColor = UIColor.gray.cgColor
        addSubview(animatedDot)
    }
    
    open func configure(for animationCurve: GDIAnimationCurve) {
        curve = animationCurve
    }
    
    private var previousViewSize: CGSize?
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if previousViewSize == nil || bounds.size != previousViewSize {
            stopAnimation()
            updateCurvePath()
            updateViewFrames()
            
            if autoplay {
                performAnimation()
            }
            previousViewSize = bounds.size
        }
    }
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        if let _ = window, autoplay == true {
            performAnimation()
        } else {
            stopAnimation()
        }
    }
    
    // MARK: - Animation
    
    private var animator: UIViewPropertyAnimator?
    
    public func performAnimation() {
        guard let curve = curve else { return }
        guard animator == nil else { return }
        
        let startTransform = CGAffineTransform(translationX: 0, y: 0)
        let endTransform = CGAffineTransform(translationX: graphSize.width, y: 0)
        
        animatedDot.transform = startTransform
        
        // create animation to move to right side of view
        animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: curve)
        
        animator?.addAnimations {
            self.animatedDot.transform = endTransform
        }
        
        animator?.addCompletion { [weak self] (position) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                guard let animator = self?.animator, animator.state == .inactive else { return }
                self?.animatedDot.transform = startTransform
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                guard let animator = self?.animator, animator.state == .inactive else { return }
                self?.animator = nil
                self?.performAnimation()
            })
        }
        
        animator?.startAnimation()
    }
    
    public func stopAnimation() {
        guard let animator = animator else { return }
        self.animator = nil
        animator.stopAnimation(true)
        animator.finishAnimation(at: .start)
    }
    
    // MARK: - Updates
    
    private func updateViewFrames() {
        curveLayer.frame = bounds
        animatedDot.frame = CGRect(origin: CGPoint(x: offsetX - animatedDot.frame.width * 0.5, y: animatedLineY - animatedDot.frame.height * 0.5), size: animatedDot.frame.size)
    }
    
    private func updateCurvePath() {
        guard let curve = curve, let controlPoint1 = curve.gdiCurveType.controlPoint1, let controlPoint2 = curve.gdiCurveType.controlPoint2 else { return }
        
        let path = CGMutablePath()
        let start = CGPoint(x: offsetX, y: offsetY + graphSize.height)
        let end = CGPoint(x: offsetX + graphSize.width, y: offsetY)
        path.move(to: start)
        
        let control1 = CGPoint(x: offsetX + graphSize.width * controlPoint1.x, y: offsetY + graphSize.height - graphSize.height * controlPoint1.y)
        let control2 = CGPoint(x: offsetX + graphSize.width * controlPoint2.x, y: offsetY + graphSize.height - graphSize.height * controlPoint2.y)
        path.addCurve(to: end, control1: control1, control2: control2)
        curveLayer.path = path
        
        if curveLayer.superlayer == nil {
            layer.addSublayer(curveLayer)
        }
    }
    
    // MARK: - Drawing
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // fill bg for graph
        context.setFillColor(UIColor.white.withAlphaComponent(0.25).cgColor)
        context.fill(CGRect(x: offsetX, y: offsetY, width: graphSize.width, height: graphSize.height))
        
        // set stroke style for graph grid lines
        context.setLineWidth(1)
        context.setStrokeColor(UIColor.white.withAlphaComponent(0.25).cgColor)
        
        for i in 0...4 {
            // draw vertical column lines
            let xp: CGFloat = CGFloat(i) * 25.0
            context.move(to: CGPoint(x: offsetX + xp, y: offsetY))
            context.addLine(to: CGPoint(x: offsetX + xp, y: offsetY + graphSize.height))
            context.strokePath()
            
            // draw vertical rows lines
            let yp: CGFloat = CGFloat(i) * 25.0
            context.move(to: CGPoint(x: offsetX, y: offsetY + yp))
            context.addLine(to: CGPoint(x: offsetX + graphSize.width, y: offsetY + yp))
            context.strokePath()
        }
        
        // draw left and bottom graph lines
        context.setLineWidth(2)
        context.setStrokeColor(UIColor.white.cgColor)
        context.move(to: CGPoint(x: offsetX, y: offsetY))
        context.addLine(to: CGPoint(x: offsetX, y: offsetY + graphSize.height))
        context.addLine(to: CGPoint(x: offsetX + graphSize.width, y: offsetY + graphSize.height))
        context.strokePath()
        
        // draw animation path
        context.setStrokeColor(UIColor.white.withAlphaComponent(0.5).cgColor)
        context.move(to: CGPoint(x: offsetX, y: animatedLineY))
        context.addLine(to: CGPoint(x: offsetX + graphSize.width, y: animatedLineY))
        context.strokePath()
    }
}
