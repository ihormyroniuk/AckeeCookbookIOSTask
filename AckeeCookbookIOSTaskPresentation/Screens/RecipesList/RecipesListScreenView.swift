//
//  RecipesListScreenView.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit

class RecipesListScreenView: ScreenViewWithNavigationBar {

    // MARK: Elements

    let titleLabel = UILabel()
    let addRecipeButton = UIButton(type: .contactAdd)
    let collectionViewLayout = UICollectionViewFlowLayout()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        return collectionView
    }()
    let collectionViewRefreshControl = UIRefreshControl()

    // MARK: Setup

    override func setup() {
        super.setup()
        backgroundColor = .white
        addSubview(collectionView)
        setupCollectionView()
    }

    override func setupStatusBarView() {
        super.setupStatusBarView()
        statusBarView.backgroundColor = .white
    }

    override func setupNavigationBarView() {
        super.setupNavigationBarView()
        navigationBarView.backgroundColor = .white
        navigationBarView.addSubview(titleLabel)
        setupTitleLabel()
        navigationBarView.addSubview(addRecipeButton)
        setupAddRecipeButton()
    }

    private func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 3
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
    }

    private func setupAddRecipeButton() {

    }

    private let recipeListItemViewCollectionViewCellIdentifier = "recipeListItemViewCollectionViewCellIdentifier"
    private func setupCollectionView() {
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.register(RecipeListItemCollectionViewCell.self, forCellWithReuseIdentifier: recipeListItemViewCollectionViewCellIdentifier)
        collectionView.addSubview(collectionViewRefreshControl)
    }

    // Layout

    override func layout() {
        super.layout()
        layoutAddRecipeButton()
        layoutTitleLabel()
        layoutCollectionView()
    }

    private func layoutAddRecipeButton() {
        let width: CGFloat = 32
        let height: CGFloat = 32
        let x: CGFloat = navigationBarView.bounds.width - 8 - width
        let y: CGFloat = (navigationBarView.bounds.height - height) / 2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        addRecipeButton.frame = frame
    }

    private func layoutTitleLabel() {
        let possibleWidth: CGFloat = navigationBarView.bounds.width - 2 * (navigationBarView.bounds.width - addRecipeButton.frame.origin.x + 8)
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

    private func layoutCollectionView() {
        let x: CGFloat = 0
        let y = navigationBarView.frame.origin.y + navigationBarView.frame.height
        let width = bounds.size.width
        let height = bounds.height - y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        collectionView.frame = frame
        collectionViewLayout.minimumInteritemSpacing = 12
        collectionViewLayout.minimumLineSpacing = 12
    }

    // MARK: Cells

    func recipeListItemViewCollectionViewCell(_ indexPath: IndexPath) -> RecipeListItemCollectionViewCell! {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recipeListItemViewCollectionViewCellIdentifier, for: indexPath) as? RecipeListItemCollectionViewCell
        return cell
    }

    func recipeListItemViewCollectionViewCellSize(_ indexPath: IndexPath) -> CGSize {
        let availableWidthInt = Int(collectionView.bounds.width)
        let minimumItemWidthAndSpace: Int = 320 + 12
        let maximumNumberOfItemsForAvailableWidth = (availableWidthInt - 12) / minimumItemWidthAndSpace
        let width: CGFloat = collectionView.bounds.width / CGFloat(maximumNumberOfItemsForAvailableWidth) - 12
        let height: CGFloat = 76
        let size = CGSize(width: width, height: height)
        return size
    }

}

class RecipeListItemCollectionViewCell: AUICollectionViewCell {

    private let horizontalStackView = UIStackView()
    private let pictureImageView = UIImageView()
    private let verticalRightStackView = UIStackView()
    let nameLabel = UILabel()
    private let verticalRightBottomStackView = UIStackView()
    private let durationHorizontalStackView = UIStackView()
    let scoreProgressView = ScoreProgressView()
    private let durationPictureImageView = UIImageView()
    let durationLabel = UILabel()

    // MARK: Setup

    override func setup() {
        super.setup()
        contentView.addSubview(horizontalStackView)
        setupHorizontalStackView()
    }

    private func setupHorizontalStackView() {
        horizontalStackView.distribution = .fillProportionally
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
        //verticalRightBottomStackView.addArrangedSubview(scoreProgressView)
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

    // MARK: AutoLayout

    override func autoLayout() {
        super.autoLayout()
        autoLayoutPictureImageView()
        autolayoutDurationPictureImageView()
    }

    func autoLayoutPictureImageView() {
        let height: CGFloat = bounds.height
        let width = height
        pictureImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        pictureImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
    }

    private func autolayoutDurationPictureImageView() {
        let width: CGFloat = 12
        let height: CGFloat = width
        durationPictureImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        durationPictureImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
    }

}

class ScoreProgressView: AUIView {

    private let horizontalStackView = UIStackView()

    override func setup() {
        super.setup()
        addSubview(horizontalStackView)
        setupHorizontalStackView()
    }

    private func setupHorizontalStackView() {
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.spacing = 2
    }

    // MARK: Layout

    override func layout() {
        super.layout()
        layoutHorizontalStackView()
    }

    private func layoutHorizontalStackView() {
        let frame = bounds
        horizontalStackView.frame = frame
    }

    // MARK: Star

    private var starImageView: UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Star", in: Bundle(for: RecipeListItemCollectionViewCell.self), compatibleWith: nil)
        imageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
        return imageView
    }

    // MARK: Value

    func setValue(_ value: Float) {
        let base = value * 5
        let count = Int(base.rounded(.toNearestOrAwayFromZero))
        horizontalStackView.removeAllArrangedSubviews()
        let array: [UIImageView] = [starImageView, starImageView, starImageView]
        horizontalStackView.addArrangedSubviews(array)
    }
}

