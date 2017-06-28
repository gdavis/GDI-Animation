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
    let curve: GDIAnimationCurve
}

class DemoCollectionViewController: UICollectionViewController {
    
    private let demoAnimations: [CellData] = [
        CellData(curve: GDIAnimationCurve(.linear)),
        CellData(curve: GDIAnimationCurve(.softInOut)),
        CellData(curve: GDIAnimationCurve(.strongIn)),
        CellData(curve: GDIAnimationCurve(.strongOut)),
        CellData(curve: GDIAnimationCurve(.strongInOut)),
        CellData(curve: GDIAnimationCurve(.slamIn)),
        CellData(curve: GDIAnimationCurve(.slamOut)),
        CellData(curve: GDIAnimationCurve(.strongBounceIn)),
        CellData(curve: GDIAnimationCurve(.strongBounceOut)),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.itemSize = CGSize(width: view.frame.width/2 - 5, height: layout.itemSize.height)
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
    @IBOutlet weak var curveView: GDIAnimationDebugView!
    @IBOutlet weak var playIcon: UIImageView!
    
    fileprivate func configure(for cellData: CellData) {
        nameLabel.text = cellData.curve.gdiCurveType.name
        curveView.configure(for: cellData.curve)
    }
    
    @IBAction func playTapped(_ sender: Any) {
        if curveView.animating == false {
            playIcon.isHidden = true
            curveView.performAnimation()
        } else {
            playIcon.isHidden = false
            curveView.stopAnimation()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        curveView.stopAnimation()
        playIcon.isHidden = false
    }
}
