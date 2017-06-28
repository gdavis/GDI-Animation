//: A UIKit based Playground to present user interface

import UIKit
import PlaygroundSupport
import GDI_Animation

let frame = CGRect(x: 0, y: 0, width: 100, height: 200)
let views: [GDIAnimationDebugView] = [
    GDIAnimationDebugView(curve: .linear, frame: frame),
//    GDIAnimationDebugView(curve: .softInOut, frame: frame),
//    GDIAnimationDebugView(curve: .strongIn, frame: frame),
//    GDIAnimationDebugView(curve: .strongOut, frame: frame),
//    GDIAnimationDebugView(curve: .strongInOut, frame: frame),
    GDIAnimationDebugView(curve: .strongBounceIn, frame: frame),
    GDIAnimationDebugView(curve: .strongBounceOut, frame: frame),
]

views.forEach { $0.autoplay = true }

let container = UIStackView(arrangedSubviews: views)
container.spacing = 10
container.axis = .vertical
container.distribution = .fillEqually
container.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: frame.width * 2 + container.spacing, height: (frame.height + container.spacing) * CGFloat(views.count)))

PlaygroundPage.current.liveView = container

