//
//  AddRecipeScreenView.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/31/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit

class AddRecipeScreenView: ScreenViewWithNavigationBar {

    // MARK: Elements

    let titleLabel = UILabel()
    let addButton = UIButton(type: .system)
    let backButton = UIButton(type: .system)
    let scrollView = UIScrollView()
    let nameTextInput = TextViewInputView()

    // MARK: Setup

    override func setup() {
        super.setup()
        backgroundColor = .white
        addSubview(scrollView)
        setupScrollView()
    }

    override func setupStatusBarView() {
        super.setupStatusBarView()
        statusBarView.backgroundColor = .white
    }

    override func setupNavigationBarView() {
        super.setupNavigationBarView()
        navigationBarView.backgroundColor = .white
        navigationBarView.addSubview(backButton)
        setupBackButton()
        navigationBarView.addSubview(addButton)
        setupAddButton()
        navigationBarView.addSubview(titleLabel)
        setupTitleLabel()
    }

    private func setupBackButton() {
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        let image = UIImage(named: "Back", in: Bundle(for: RecipeListItemCollectionViewCell.self), compatibleWith: nil)
        backButton.setImage(image, for: .normal)
    }

    private func setupAddButton() {
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    }

    private func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 3
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
    }

    private func setupScrollView() {
        scrollView.addSubview(nameTextInput)
    }

    // MARK: Layout

    override func layout() {
        super.layout()
        layoutBackButton()
        layoutAddButton()
        layoutTitleLabel()
        layoutScrollView()
        layoutNameTextInput()
        setScrollViewContentSize()
    }

    private func layoutBackButton() {
        let titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        backButton.titleEdgeInsets = titleEdgeInsets
        let contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        backButton.contentEdgeInsets = contentEdgeInsets
        let possibleHeight = navigationBarView.bounds.height
        let possibleWidth = navigationBarView.bounds.width / 4
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = backButton.sizeThatFits(possibleSize)
        let width: CGFloat = size.width
        let height: CGFloat = size.height
        let x: CGFloat = 8
        let y: CGFloat = (navigationBarView.bounds.height - height) / 2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        backButton.frame = frame
    }

    private func layoutAddButton() {
        let possibleHeight = navigationBarView.bounds.height
        let possibleWidth = navigationBarView.bounds.width / 4
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = addButton.sizeThatFits(possibleSize)
        let width: CGFloat = size.width
        let height: CGFloat = size.height
        let x: CGFloat = navigationBarView.bounds.width - 8 - width
        let y: CGFloat = (navigationBarView.bounds.height - height) / 2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        addButton.frame = frame
    }

    private func layoutTitleLabel() {
        let possibleWidth: CGFloat = navigationBarView.bounds.width - 2 * (navigationBarView.bounds.width - addButton.frame.origin.x + 8)
        let possibleHeight: CGFloat = navigationBarView.bounds.height
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        var size = titleLabel.sizeThatFits(possibleSize)
        if size.height > possibleHeight {
            size.height = possibleHeight
        }
        let x: CGFloat = (navigationBarView.bounds.width - size.width) / 2
        let y: CGFloat = (navigationBarView.bounds.height - size.height) / 2
        let origin = CGPoint(x: x, y: y)
        let frame = CGRect(origin: origin, size: size)
        titleLabel.frame = frame
    }

    private func layoutScrollView() {
        let x: CGFloat = 0
        let y = navigationBarView.frame.origin.y + navigationBarView.frame.height
        let width = bounds.size.width
        let height = bounds.height - y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        scrollView.frame = frame
    }

    private func layoutNameTextInput() {
        let origin = CGPoint.zero
        let possibleHeight = CGFloat.greatestFiniteMagnitude
        let possibleWidth = scrollView.bounds.width
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = nameTextInput.sizeThatFits(possibleSize)
        let frame = CGRect(origin: origin, size: size)
        nameTextInput.frame = frame
        nameTextInput.setNeedsLayout()
        nameTextInput.layoutIfNeeded()
    }

    private func setScrollViewContentSize() {
        let width = scrollView.frame.size.width
        let height = nameTextInput.frame.origin.y + nameTextInput.frame.height
        let size = CGSize(width: width, height: height)
        scrollView.contentSize = size
    }

}

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
    }

    private func setupUnderlineLayer() {
        underlineLayer.backgroundColor = UIColor.lightGray.cgColor
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
        return size
    }

}
