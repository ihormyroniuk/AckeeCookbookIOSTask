//
//  TextViewInputView.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 4/2/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit

class TextViewInputView: AUIView {

    // MARK: Elements

    let titleLabel = UILabel()
    let textView = UITextView()
    private let underlineLayer = CALayer()

    // MARK: Setup

    override func setup() {
        super.setup()
        addSubview(titleLabel)
        setupTitleLabel()
        addSubview(textView)
        setupTextView()
        layer.addSublayer(underlineLayer)
        setupUnderlineLayer()
    }

    private func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = UIColor.systemBlue
    }

    private func setupTextView() {
        textView.isScrollEnabled = false
        textView.alwaysBounceVertical = false
        textView.bounces = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.tintColor = UIColor.systemBlue
        textView.textContainer.lineFragmentPadding = 0
    }

    private func setupUnderlineLayer() {
        underlineLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
    }

    // MARK: Layout

    override func layout() {
        super.layout()
        layoutTitleLabel()
        layoutTextView()
        layoutUnderlineLayer()
    }

    private func layoutTitleLabel() {
        let origin = CGPoint.zero
        let possibleWidth: CGFloat = bounds.width
        let possibleHeight = CGFloat.greatestFiniteMagnitude
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = titleLabel.sizeThatFits(possibleSize)
        let frame = CGRect(origin: origin, size: size)
        titleLabel.frame = frame
    }

    private func layoutTextView() {
        let x: CGFloat = 0
        let y: CGFloat = titleLabel.frame.origin.y + titleLabel.frame.size.height
        let origin = CGPoint(x: x, y: y)
        let possibleWidth: CGFloat = bounds.width
        let possibleHeight = CGFloat.greatestFiniteMagnitude
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        var size = textView.sizeThatFits(possibleSize)
        size.width = possibleWidth
        let frame = CGRect(origin: origin, size: size)
        textView.frame = frame
    }

    private func layoutUnderlineLayer() {
        let x: CGFloat = textView.frame.origin.x
        let y: CGFloat = textView.frame.origin.y + textView.frame.size.height
        let width = textView.frame.width
        let height: CGFloat = 1
        let frame = CGRect(x: x, y: y, width: width, height: height)
        underlineLayer.frame = frame
    }

    // MARK: Size

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let titleLabelsize = titleLabel.sizeThatFits(size)
        let textViewSize = textView.sizeThatFits(size)
        let sizeThatFits = CGSize(width: size.width, height: titleLabelsize.height + textViewSize.height + 1)
        return sizeThatFits
    }

}

class IngredientsInputView: AUIView {

    let titleLabel = UILabel()
    let inputViews: [IngredientInputView] = [IngredientInputView(), IngredientInputView()]
    let addButton = UIButton()

    override func setup() {
        super.setup()
        addSubview(titleLabel)
        setupTitleLabel()
        addSubview(addButton)
        setupAddButton()
        for inputView in inputViews {
            addSubview(inputView)
        }
    }

    private func setupTitleLabel() {
        
    }

    private func setupAddButton() {

    }

    override func layout() {
        super.layout()
        layoutTitleLabel()
        layoutInputViews()
        layoutAddButton()
    }

    private func layoutTitleLabel() {
        let origin = CGPoint.zero
        let possibleWidth: CGFloat = bounds.width
        let possibleHeight = bounds.height
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = titleLabel.sizeThatFits(possibleSize)
        let frame = CGRect(origin: origin, size: size)
        titleLabel.frame = frame
    }

    private func layoutInputViews() {
        let x: CGFloat = 0
        var y: CGFloat = titleLabel.frame.height + 12
        for inputView in inputViews {
            let availableWidth = bounds.width
            let availableHeight = bounds.height - titleLabel.frame.height
            let availableSize = CGSize(width: availableWidth, height: availableHeight)
            let sizeThatFits = inputView.sizeThatFits(availableSize)
            let origin = CGPoint(x: x, y: y)
            let frame = CGRect(origin: origin, size: sizeThatFits)
            inputView.frame = frame
            y += sizeThatFits.height + 4
        }
    }

    private func layoutAddButton() {
        let x: CGFloat = 0
        let y: CGFloat
        if let lastInputView = inputViews.last {
            y = lastInputView.frame.origin.y + lastInputView.frame.size.height + 4
        } else {
            y = titleLabel.frame.height + 4
        }
        let availableWidth = bounds.width
        let availableHeight = bounds.height
        let availableSize = CGSize(width: availableWidth, height: availableHeight)
        let sizeThatFits = addButton.sizeThatFits(availableSize)
        let origin = CGPoint(x: x, y: y)
        let frame = CGRect(origin: origin, size: sizeThatFits)
        addButton.frame = frame
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var height: CGFloat = 0
        height += titleLabel.sizeThatFits(size).height
        height += 4
        for inputView in inputViews {
            let sizeThatFits = inputView.sizeThatFits(size)
            height += sizeThatFits.height
            height += 4
        }
        if !inputViews.isEmpty {
            height -= 4
        }
        height += 4
        height += addButton.sizeThatFits(size).height
        let sizeThatFits = CGSize(width: size.width, height: height)
        return sizeThatFits
    }
}

class IngredientInputView: AUIView {

    // MARK: Elements

    let placeholderTextLayer = CATextLayer()
    let textView = UITextView()
    let underlineLayer = CALayer()

    // MARK: Setup

    override func setup() {
        super.setup()
        addSubview(textView)
        setupTextView()
        layer.addSublayer(underlineLayer)
        setupUnderlineLayer()
    }

    private func setupTextView() {
        textView.tintColor = UIColor.systemBlue
    }

    private func setupUnderlineLayer() {
        underlineLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
    }

    // MARK: Layout

    override func layout() {
        super.layout()
        layoutTextView()
        layoutUnderlineLayer()
    }

    private func layoutTextView() {
        let x: CGFloat = 0
        let y: CGFloat = 0
        let origin = CGPoint(x: x, y: y)
        var size = textView.sizeThatFits(bounds.size)
        size.width = bounds.width
        let frame = CGRect(origin: origin, size: size)
        textView.frame = frame
    }

    private func layoutUnderlineLayer() {
        let x: CGFloat = 0
        let y = textView.frame.height
        let width = textView.frame.width
        let height = underlineLayerHeight
        let frame = CGRect(x: x, y: y, width: width, height: height)
        underlineLayer.frame = frame
    }

    // MARK: Size

    private let underlineLayerHeight: CGFloat = 1
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let width: CGFloat = size.width
        let textViewSize = textView.sizeThatFits(size)
        let height: CGFloat = textViewSize.height + underlineLayerHeight
        let sizeThatFits = CGSize(width: width, height: height)
        return sizeThatFits
    }

}
