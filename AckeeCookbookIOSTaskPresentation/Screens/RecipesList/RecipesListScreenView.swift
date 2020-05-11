//
//  RecipesListScreenView.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit

class RecipesInListScreenView: ScreenViewWithNavigationBar {

    // MARK: Elements

    let titleLabel = UILabel()
    let addRecipeButton = AlphaHighlightButton()
    let collectionViewLayout = FeedCollectionViewFlowLayout()
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
        let image = Images.plusInCircle
        addRecipeButton.setImage(image.withTintColor(Colors.blue), for: .normal)
        addRecipeButton.setImage(image.withTintColor(Colors.blue), for: .highlighted)
    }

    private let recipeListItemViewCollectionViewCellIdentifier = "recipeListItemViewCollectionViewCellIdentifier"
    private func setupCollectionView() {
        collectionView.alwaysBounceVertical = true
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.backgroundColor = .white
        collectionView.register(RecipeListItemCollectionViewCell.self, forCellWithReuseIdentifier: recipeListItemViewCollectionViewCellIdentifier)
        collectionView.addSubview(collectionViewRefreshControl)
    }

    // Layout

    override func layoutSubviews() {
        super.layoutSubviews()
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
    }

    // MARK: Cells

    func recipeListItemViewCollectionViewCell(_ indexPath: IndexPath) -> RecipeListItemCollectionViewCell! {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recipeListItemViewCollectionViewCellIdentifier, for: indexPath) as? RecipeListItemCollectionViewCell
        return cell
    }

}

private let decoratorIdentifier: String = "tyu"

final class FeedCollectionViewFlowLayout: UICollectionViewLayout {
    
    override init() {
        super.init()
        self.register(FeedSeparatorView.self, forDecorationViewOfKind: decoratorIdentifier)
    }
    
    required init?(coder: NSCoder) { return nil }
    
    override func prepare() {
        super.prepare()
        prepareRecipes()
    }
    
    private var recipesLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    private var recipesSeparatorsLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    private func prepareRecipes() {
        recipesLayoutAttributes = []
        recipesSeparatorsLayoutAttributes = []
        guard let collectionView = collectionView else { return }
        let section = 0
        let numberOfItems = collectionView.numberOfItems(inSection: section)
        let bounds = collectionView.bounds
        let boundsWidth = Int(bounds.width)
        let x = 24
        let width = boundsWidth - x * 2
        let spacing = 16
        var y = spacing
        let height = 76
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: section)
            let recipeLayoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            recipeLayoutAttribute.frame = CGRect(x: x, y: y, width: width, height: height)
            recipesLayoutAttributes.append(recipeLayoutAttribute)
            y += height + spacing
            if item != numberOfItems - 1 {
                let recipeSeparatorLayoutAttribute = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "tyu", with: indexPath)
                recipeSeparatorLayoutAttribute.frame = CGRect(x: x, y: y, width: width, height: 1)
                recipesSeparatorsLayoutAttributes.append(recipeSeparatorLayoutAttribute)
                y += spacing
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = recipesLayoutAttributes + recipesSeparatorsLayoutAttributes
        let layoutAttributesInRect = layoutAttributes.filter({ $0.frame.intersects(rect) })
        return layoutAttributesInRect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let section = indexPath.section
        let item = indexPath.item
        if section == 0 {
            return recipesLayoutAttributes[item]
        }
        return nil
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
        if elementKind == "tyu" {
            return recipesSeparatorsLayoutAttributes[indexPath.item]
        }
        return nil
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        if let last = recipesLayoutAttributes.last {
            let width = collectionView.bounds.width
            let height = last.frame.origin.y + last.frame.size.height + 16
            return CGSize(width: width, height: height)
        }
        return .zero
    }
    
    private var deletedIndexPaths: [IndexPath] = []
    private var insertedIndexPaths: [IndexPath] = []
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        guard let collectionView = collectionView else { return }
        for updateItem in updateItems {
            let updateAction = updateItem.updateAction
            switch updateAction {
            case .insert:
                guard let indexPath = updateItem.indexPathAfterUpdate else { return }
                insertedIndexPaths.append(indexPath)
            case .delete:
                guard var indexPath = updateItem.indexPathBeforeUpdate else { return }
                let section = indexPath.section
                let item = indexPath.item
                if section == 0 {
                    let numberOfItems = collectionView.numberOfItems(inSection: section)
                    if item == numberOfItems {
                        indexPath.item -= 1
                        deletedIndexPaths.append(indexPath)
                    } else {
                        deletedIndexPaths.append(indexPath)
                    }
                }
            default:
                break
            }
        }
    }
    
    override func indexPathsToDeleteForDecorationView(ofKind elementKind: String) -> [IndexPath] {
        var indexPathsToDeleteForDecorationView = super.indexPathsToDeleteForDecorationView(ofKind: elementKind)
        indexPathsToDeleteForDecorationView.append(contentsOf: deletedIndexPaths)
        deletedIndexPaths = []
        return indexPathsToDeleteForDecorationView
    }

    override func indexPathsToInsertForDecorationView(ofKind elementKind: String) -> [IndexPath] {
        var indexPathsToInsertForDecorationView = super.indexPathsToInsertForDecorationView(ofKind: elementKind)
        indexPathsToInsertForDecorationView.append(contentsOf: insertedIndexPaths)
        insertedIndexPaths = []
        return indexPathsToInsertForDecorationView
    }
}

private class FeedSeparatorView: UICollectionReusableView {

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        backgroundColor = Colors.highlightGray
    }
}
