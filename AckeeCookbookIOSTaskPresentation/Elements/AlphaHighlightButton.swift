//
//  AlphaHighlightButton.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 03.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import UIKit
import AUIKit

class AlphaHighlightButton: AUIButton {
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                highlight()
            } else {
                unhighlight()
            }
        }
    }
    
    private func highlight() {
        alpha = 0.4
    }
    
    private func unhighlight() {
        alpha = 1
    }
    
}
