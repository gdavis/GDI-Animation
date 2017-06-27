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
    let curve: GDIAnimationCurve
}

class DemoCollectionViewController: UICollectionViewController {
    
    private let demoAnimations: [CellData] = [
        CellData(title: "linear", curve: GDIAnimationCurve(.linear)),
        CellData(title: "hard ease in", curve: GDIAnimationCurve(.hardEaseIn)),
        CellData(title: "hard ease out", curve: GDIAnimationCurve(.hardEaseOut))
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
    @IBOutlet weak var curveView: GDIAnimationDebugView!
    
    fileprivate func configure(for cellData: CellData) {
        nameLabel.text = cellData.title
        curveView.configure(for: cellData.curve)
    }
}
