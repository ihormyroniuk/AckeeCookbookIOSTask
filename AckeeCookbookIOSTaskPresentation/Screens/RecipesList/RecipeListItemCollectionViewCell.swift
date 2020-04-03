//
//  RecipeListItemCollectionViewCell.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 4/2/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit

class RecipeListItemCollectionViewCell: AUICollectionViewCell {

    private let horizontalStackView = UIStackView()
    private let pictureImageView = AUIImageViewSetIntrinsicContentSize()
    private let verticalRightStackView = UIStackView()
    let nameLabel = UILabel()
    private let verticalRightBottomStackView = UIStackView()
    private let durationHorizontalStackView = UIStackView()
    let scoreProgressView = ScoreProgressView()
    private let durationPictureImageView = AUIImageViewSetIntrinsicContentSize()
    let durationLabel = UILabel()

    // MARK: Setup

    override func setup() {
        super.setup()
        contentView.addSubview(horizontalStackView)
        setupHorizontalStackView()
    }

    private func setupHorizontalStackView() {
        horizontalStackView.distribution = .fill
        horizontalStackView.spacing = 8
        horizontalStackView.alignment = .fill
        horizontalStackView.addArrangedSubview(pictureImageView)
        setupPictureImageView()
        horizontalStackView.addArrangedSubview(verticalRightStackView)
        setupVerticalRightStackView()
    }

    private func setupPictureImageView() {
        pictureImageView.contentMode = .scaleAspectFit
        pictureImageView.image = UIImage(named: "RecipesListItemPicture", in: Bundle(for: RecipeListItemCollectionViewCell.self), compatibleWith: nil)
    }

    private func setupVerticalRightStackView() {
        verticalRightStackView.axis = .vertical
        verticalRightStackView.distribution = .equalSpacing
        verticalRightStackView.alignment = .leading
        verticalRightStackView.addArrangedSubview(nameLabel)
        setupNameLabel()
        verticalRightStackView.addArrangedSubview(verticalRightBottomStackView)
        setupVerticalRightBottomStackView()
    }

    private func setupNameLabel() {
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.minimumScaleFactor = 0.5
        nameLabel.textColor = UIColor.systemBlue
    }

    private func setupVerticalRightBottomStackView() {
        verticalRightBottomStackView.axis = .vertical
        verticalRightBottomStackView.spacing = 4
        verticalRightBottomStackView.alignment = .leading
        verticalRightBottomStackView.addArrangedSubview(scoreProgressView)
        verticalRightBottomStackView.addArrangedSubview(durationHorizontalStackView)
        setupDurationHorizontalStackView()
    }

    private func setupDurationHorizontalStackView() {
        durationHorizontalStackView.alignment = .center
        durationHorizontalStackView.spacing = 5
        durationHorizontalStackView.addArrangedSubview(durationPictureImageView)
        setupDurationPictureImageView()
        durationHorizontalStackView.addArrangedSubview(durationLabel)
        setupDurationLabel()
    }

    private func setupDurationPictureImageView() {
        durationPictureImageView.contentMode = .scaleAspectFit
        durationPictureImageView.image = UIImage(named: "Clock", in: Bundle(for: RecipeListItemCollectionViewCell.self), compatibleWith: nil)
    }

    private func setupDurationLabel() {
        durationLabel.font = UIFont.systemFont(ofSize: 12)
    }

    // MARK: Layout

    override func layout() {
        super.layout()
        layoutHorizontalStackView()
        layoutVerticalRightStackView()
        autoLayoutPictureImageView()
        autolayoutDurationPictureImageView()
    }

    private func layoutHorizontalStackView() {
        let frame = contentView.bounds
        horizontalStackView.frame = frame
    }

    private func layoutVerticalRightStackView() {
        let layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        verticalRightStackView.layoutMargins = layoutMargins
        verticalRightStackView.isLayoutMarginsRelativeArrangement = true
    }

    func autoLayoutPictureImageView() {
        let height: CGFloat = bounds.height
        let width = height
        let intrinsicContentSize = CGSize(width: width, height: height)
        pictureImageView.setIntrinsicContentSize = intrinsicContentSize
    }

    private func autolayoutDurationPictureImageView() {
        let width: CGFloat = 12
        let height: CGFloat = width
        let intrinsicContentSize = CGSize(width: width, height: height)
        durationPictureImageView.setIntrinsicContentSize = intrinsicContentSize
    }
}

class ScoreProgressView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup

    func setup() {
        distribution = .equalSpacing
        spacing = 0
    }

    // MARK: Star

    private var starImageView: UIImageView {
        let imageView = AUIImageViewSetIntrinsicContentSize()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Star", in: Bundle(for: RecipeListItemCollectionViewCell.self), compatibleWith: nil)
        let width: CGFloat = 14
        let height: CGFloat = 14
        let intrinsicContentSize = CGSize(width: width, height: height)
        imageView.setIntrinsicContentSize = intrinsicContentSize
        return imageView
    }

    // MARK: Value

    func setScore(_ score: Float) {
        let count = Int(score.rounded(.toNearestOrAwayFromZero))
        var array: [UIImageView] = []
        for _ in 0..<count {
            array.append(starImageView)
        }
        removeAllArrangedSubviews()
        addArrangedSubviews(array)
    }
}

