//
//  DemoCollectionViewController.swift
//  GDI-AnimationsDemo
//
//  Created by Grant Davis on 6/27/17.
//  Copyright © 2017 Grant Davis Interactive. All rights reserved.
//

import UIKit
import GDI_Animation

fileprivate let reuseIdentifier = "Cell"

fileprivate struct CellData {
    let title: String
    let imageName: String
    let curve: GDIAnimationCurve
}

class DemoCollectionViewController: UICollectionViewController {
    
    private let demoAnimations: [CellData] = [
        CellData(title: "linear", imageName: "linear", curve: .linear),
        CellData(title: "exponential", imageName: "exponential", curve: .exponential)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return demoAnimations.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DemoCollectionViewCell
        cell.configure(for: demoAnimations[indexPath.row])
        return cell
    }
}

class DemoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var curveView: DemoAnimationCurveView!
    
    fileprivate func configure(for cellData: CellData) {
        nameLabel.text = cellData.title
        curveView.configure(for: cellData.curve)
    }
}

class DemoAnimationCurveView: UIView {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor
        layer.backgroundColor = UIColor.gray.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func configure(for animationCurve: GDIAnimationCurve) {
        curve = animationCurve
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayers()
    }
    
    private func updateLayers() {
        guard let curve = curve else { return }
        
        let path = CGMutablePath()
        let start = CGPoint(x: 0, y: bounds.height)
        let end = CGPoint(x: bounds.width, y: 0)
        path.move(to: start)
        
        let control1 = CGPoint(x: bounds.width * curve.controlPoint1.x, y: bounds.height - bounds.height * curve.controlPoint1.y)
        let control2 = CGPoint(x: bounds.width * curve.controlPoint2.x, y: bounds.height - bounds.height * curve.controlPoint2.y)
        path.addCurve(to: end, control1: control1, control2: control2)
        curveLayer.path = path
        
        curveLayer.frame = bounds
        if curveLayer.superlayer == nil {
            layer.addSublayer(curveLayer)
        }
    }
}
