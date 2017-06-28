//: A UIKit based Playground to present user interface

import UIKit
import PlaygroundSupport
import GDI_Animation

let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
let views: [GDIAnimationDebugView] = [
    GDIAnimationDebugView(curve: .linear, frame: frame),
    GDIAnimationDebugView(curve: .slamIn, frame: frame),
    GDIAnimationDebugView(curve: .slamOut, frame: frame),
    GDIAnimationDebugView(curve: .dramaticEaseIn, frame: frame),
    GDIAnimationDebugView(curve: .dramaticEaseOut, frame: frame),
    
    //    GDIAnimationDebugView(curve: .quadBounceOut, frame: frame),
//    GDIAnimationDebugView(curve: .quadBounceIn, frame: frame),
]

let container = UIStackView(arrangedSubviews: views)
container.spacing = 10
container.axis = .vertical
container.distribution = .fillEqually
container.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: frame.width * 2 + container.spacing, height: (frame.height + container.spacing) * CGFloat(views.count)))

PlaygroundPage.current.liveView = container

