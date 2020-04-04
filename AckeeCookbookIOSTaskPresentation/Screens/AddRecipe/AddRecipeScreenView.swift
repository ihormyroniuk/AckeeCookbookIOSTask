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
    let nameTextInputView = TextViewInputView()
    let infoTextInputView = TextViewInputView()
    let ingredientsInputViews = IngredientsInputView()

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
        scrollView.addSubview(nameTextInputView)
        scrollView.addSubview(infoTextInputView)
        scrollView.addSubview(ingredientsInputViews)
    }

    // MARK: Layout

    override func layout() {
        super.layout()
        layoutBackButton()
        layoutAddButton()
        layoutTitleLabel()
        layoutScrollView()
        layoutNameTextInput()
        layoutInfoTextInput()
        layoutIngredientsInputViews()
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
        let x: CGFloat = 24
        let y: CGFloat = 30
        let origin = CGPoint(x: x, y: y)
        let possibleHeight: CGFloat = CGFloat.greatestFiniteMagnitude
        let possibleWidth = scrollView.bounds.width - x * 2
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = nameTextInputView.sizeThatFits(possibleSize)
        let frame = CGRect(origin: origin, size: size)
        nameTextInputView.frame = frame
        nameTextInputView.setNeedsLayout()
        nameTextInputView.layoutIfNeeded()
    }

    private func layoutInfoTextInput() {
        let x: CGFloat = 24
        let y: CGFloat = nameTextInputView.frame.origin.y + nameTextInputView.frame.size.height + 30
        let origin = CGPoint(x: x, y: y)
        let possibleHeight: CGFloat = CGFloat.greatestFiniteMagnitude
        let possibleWidth = scrollView.bounds.width - x * 2
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = infoTextInputView.sizeThatFits(possibleSize)
        let frame = CGRect(origin: origin, size: size)
        infoTextInputView.frame = frame
        infoTextInputView.setNeedsLayout()
        infoTextInputView.layoutIfNeeded()
    }

    private func layoutIngredientsInputViews() {
        let x: CGFloat = 24
        let y: CGFloat = infoTextInputView.frame.origin.y + infoTextInputView.frame.size.height + 30
        let origin = CGPoint(x: x, y: y)
        let possibleHeight: CGFloat = CGFloat.greatestFiniteMagnitude
        let possibleWidth = scrollView.bounds.width - x * 2
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = ingredientsInputViews.sizeThatFits(possibleSize)
        let frame = CGRect(origin: origin, size: size)
        ingredientsInputViews.frame = frame
    }

    private func setScrollViewContentSize() {
        let width = scrollView.frame.size.width
        let height = ingredientsInputViews.frame.origin.y + ingredientsInputViews.frame.height
        let size = CGSize(width: width, height: height)
        scrollView.contentSize = size
    }

}
