//
//  DarkenImageView.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 02.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import UIKit
import AUIKit

class DarkenImageView: AUIImageView {
    
    // MARK: Sublayers
    
    let darkenLayer = CALayer()
    
    override func setup() {
        super.setup()
        layer.addSublayer(darkenLayer)
        setupDarkenLayer()
    }
    
    var darkenAmount: CGFloat = 0 {
        didSet {
            darkenLayer.backgroundColor = UIColor.black.withAlphaComponent(darkenAmount).cgColor
        }
    }
    private func setupDarkenLayer() {
        darkenLayer.backgroundColor = UIColor.black.withAlphaComponent(darkenAmount).cgColor
    }
    
    // Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        darkenLayer.frame = bounds
        darkenLayer.removeAllAnimations()
    }
}
