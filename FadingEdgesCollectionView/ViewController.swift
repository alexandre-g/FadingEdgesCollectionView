//
//  ViewController.swift
//  FadingEdgesCollectionView
//
//  Created by alex on 30/4/17.
//  Copyright © 2017 Alexandre Goloskok. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: FadingEdgesCollectionView!

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let iv = cell.viewWithTag(1) as! UIImageView
        iv.image = UIImage(named: "img_\(indexPath.row%3+1).jpg")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }

    @IBAction func onArrows(_ sender: UISwitch) {
        collectionView.showArrows = sender.isOn
    }

    @IBAction func onGradients(_ sender: UISwitch) {
        collectionView.showGradients = sender.isOn
    }

    @IBAction func onGradientLength(_ sender: UISlider) {
        collectionView.gradientLength = CGFloat(Int(sender.value))
    }

    @IBAction func onArrowLength(_ sender: UISlider) {
        collectionView.arrowLength = CGFloat(Int(sender.value))
    }
}

