//
//  ViewController.swift
//  VisualEffect
//
//  Created by Никита Казанцев on 25.01.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var backgroundImageView:UIImageView!
    
    let imageSet = ["paris", "rome", "istanbul"]
    var blurEffectView: UIVisualEffectView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Randomly pick an image
        let selectedImageIndex = Int(arc4random_uniform(3))
        // Apply blurring effect
        backgroundImageView.image = UIImage(named: imageSet[selectedImageIndex])
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        blurEffectView?.frame = view.bounds
    }


}

