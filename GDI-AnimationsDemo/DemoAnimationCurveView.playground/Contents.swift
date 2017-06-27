//: A UIKit based Playground to present user interface
  
import UIKit
import PlaygroundSupport

public enum GDIAnimationCurve {
    case linear
    case expoOut
    case expoIn
    case quadBounceOut
    case quadBounceIn
    
    public var controlPoint1: CGPoint {
        switch self {
        case .linear:
            return CGPoint(x: 0, y: 0)
        case .expoOut:
            return CGPoint(x: 1, y: 0)
        case .expoIn:
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
        case .expoOut:
            return CGPoint(x: 1, y: 0)
        case .expoIn:
            return CGPoint(x: 0, y: 1)
        case .quadBounceOut:
            return CGPoint(x: 1, y: 0)
        case .quadBounceIn:
            return CGPoint(x: 1, y: 2)
        }
    }
}

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
    
    let animatedView: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
        view.backgroundColor = UIColor.red
        return view
    }()
    
    private static let controlPointSize = CGSize(width: 5, height: 5)
    
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
        layer.addSublayer(controlPoint1Layer)
        layer.addSublayer(controlPoint2Layer)
        addSubview(animatedView)
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
        
        let cp1Origin = CGPoint(x: control1.x - controlPoint1Layer.frame.width * 0.5, y: control1.y - controlPoint1Layer.frame.height * 0.5)
        let cp2Origin = CGPoint(x: control2.x - controlPoint2Layer.frame.width * 0.5, y: control2.y - controlPoint2Layer.frame.height * 0.5)
        controlPoint1Layer.frame = CGRect(origin: cp1Origin, size: controlPoint1Layer.frame.size)
        controlPoint2Layer.frame = CGRect(origin: cp2Origin, size: controlPoint2Layer.frame.size)
        
        if curveLayer.superlayer == nil {
            layer.addSublayer(curveLayer)
        }
    }
}

let frame = CGRect(x: 0, y: 0, width: 200, height: 500)
let views: [AnimationCurveView] = [
//    AnimationCurveView(curve: .linear, frame: frame),
//    AnimationCurveView(curve: .expoOut, frame: frame),
//    AnimationCurveView(curve: .expoIn, frame: frame),
    AnimationCurveView(curve: .quadBounceOut, frame: frame),
    AnimationCurveView(curve: .quadBounceIn, frame: frame),
]

let container = UIStackView(arrangedSubviews: views)
container.spacing = 10
container.axis = .vertical
container.distribution = .fillEqually
container.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: frame.width, height: (frame.height + container.spacing) * CGFloat(views.count)))

PlaygroundPage.current.liveView = container
