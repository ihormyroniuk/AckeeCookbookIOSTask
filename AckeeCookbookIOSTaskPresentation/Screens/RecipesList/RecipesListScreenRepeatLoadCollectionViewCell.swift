//
//  RecipesListScreenRepeatLoadingCollectionViewCell.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 22.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit

class RecipesListScreenRepeatLoadCollectionViewCell: AUICollectionViewCell {

    // MARK: Subviews

    private let repeatLoadButton = AlphaHighlightButton()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        repeatLoadButton.setTitle("sdfdsf", for: .normal)
        contentView.addSubview(repeatLoadButton)
        setupRepeatLoadButton()
    }
    
    private func setupRepeatLoadButton() {
        repeatLoadButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        repeatLoadButton.setTitleColor(Colors.blue, for: .normal)
    }
    
    // MARK: Layout Subviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutRepeatLoadButton()
    }
    
    private func layoutRepeatLoadButton() {
        let possibleHeight = bounds.height
        let possibleWidth = bounds.width
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = repeatLoadButton.sizeThatFits(possibleSize)
        let width: CGFloat = size.width
        let height: CGFloat = size.height
        let x: CGFloat = (bounds.width - width) / 2
        let y: CGFloat = (bounds.height - height) / 2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        repeatLoadButton.frame = frame
    }
    
}
